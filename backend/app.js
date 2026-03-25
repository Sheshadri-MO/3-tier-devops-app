const express = require('express');
const mysql = require('mysql2');
const redis = require('redis');
require('dotenv').config();

const app = express();
app.use(express.json());

/* ================== CONFIG ================== */
const DB_HOST = process.env.DB_HOST || "localhost";
const REDIS_HOST = process.env.REDIS_HOST || "localhost";

/* ================== MYSQL ================== */
const db = mysql.createConnection({
  host: DB_HOST,
  user: "appuser",
  password: "password",
  database: "myapp"
});

db.connect((err) => {
  if (err) {
    console.error("❌ MySQL Connection Error:", err);
  } else {
    console.log("✅ MySQL Connected");

    // Create table if not exists
    db.query(`
      CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255),
        password VARCHAR(255),
        name VARCHAR(255)
      )
    `);
  }
});

/* ================== REDIS ================== */
const redisClient = redis.createClient({
  url: `redis://${REDIS_HOST}:6379`
});

redisClient.connect()
  .then(() => console.log("✅ Redis Connected"))
  .catch(err => console.error("❌ Redis Error:", err));

/* ================== ROUTES ================== */

// HEALTH CHECK
app.get('/health', (req, res) => {
  res.send("OK");
});

// LOGIN
app.post('/api/login', (req, res) => {
  const { username, password } = req.body;

  db.query(
    "SELECT * FROM users WHERE username=? AND password=?",
    [username, password],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }

      if (result.length > 0) {
        res.json({ message: "Login success" });
      } else {
        res.status(401).json({ message: "Invalid credentials" });
      }
    }
  );
});

// ADD USER
app.get('/api/add', (req, res) => {
  const random = Math.floor(Math.random() * 100);

  db.query(
    "INSERT INTO users (username, password, name) VALUES (?, ?, ?)",
    [`user${random}`, "pass123", `User ${random}`],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).send("Error inserting user");
      }

      // Clear cache after insert
      redisClient.del("users");

      res.send("User Added");
    }
  );
});

// USERS WITH CACHE
app.get('/api/users', async (req, res) => {
  try {
    const cached = await redisClient.get("users");

    if (cached) {
      console.log("⚡ From Redis");
      return res.json(JSON.parse(cached));
    }

    db.query("SELECT name FROM users", async (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }

      console.log("🐢 From MySQL");

      await redisClient.set("users", JSON.stringify(result), {
        EX: 10   // cache for 10 seconds
      });

      res.json(result);
    });

  } catch (err) {
    console.error(err);
    res.status(500).send("Server error");
  }
});

/* ================== SERVER ================== */
app.listen(3000, () => {
  console.log("🚀 Server running on port 3000");
});
const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const redis = require('redis');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

// ✅ Redis Client
const redisClient = redis.createClient({
  url: 'redis://redis:6379'
});

redisClient.on('error', (err) => console.log('Redis Error:', err));

(async () => {
  await redisClient.connect();
  console.log("Connected to Redis");
})();

// ✅ MySQL Connection
const db = mysql.createConnection({
  host: 'mysql',
  user: 'root',
  password: 'root',
  database: 'users'
});

db.connect((err) => {
  if (err) {
    console.log("MySQL connection failed:", err);
  } else {
    console.log("Connected to MySQL");
  }
});

// ✅ Health check (IMPORTANT for debugging)
app.get('/', (req, res) => {
  res.send("Backend is running 🚀");
});

// ✅ Login API
app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    // 🔹 Check cache first
    const cached = await redisClient.get(username);
    if (cached) {
      return res.send("Login success (Cache)");
    }

    // 🔹 Check DB
    db.query(
      "SELECT * FROM users WHERE username=? AND password=?",
      [username, password],
      async (err, results) => {

        if (err) {
          console.log("DB Error:", err);
          return res.status(500).send("Database error");
        }

        if (results.length > 0) {
          await redisClient.setEx(username, 60, "valid");
          res.send("Login success (DB)");
        } else {
          res.send("Invalid credentials");
        }
      }
    );

  } catch (err) {
    console.log("Error:", err);
    res.status(500).send("Server error");
  }
});

// ✅ Listen on all interfaces (CRITICAL for Docker)
app.listen(3000, '0.0.0.0', () => {
  console.log("Server running on port 3000");
});
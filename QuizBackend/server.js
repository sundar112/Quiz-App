const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const dotenv = require("dotenv");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const User = require("./Model/User.js");
const Question = require("./Model/Question.js");

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const MONGO_URL = "mongodb://127.0.0.1:27017/QuizApp";

mongoose.connect(MONGO_URL)
  .then(() => console.log("Connected to DB"))
  .catch((err) => console.log(err));

const SECRET_KEY = "mysecretkey"; // Change this to a strong key in production

// Register
app.post("/register", async (req, res) => {
  try {
    const { username, email, password } = req.body;
    if (!username || !email || !password) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: "Email already in use" });
    }

    // // ✅ Hash password before saving
    // const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({ username, email, password });
    await newUser.save();

    res.status(201).json({ message: "User registered successfully!" });
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});


// Login
app.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: "Invalid email or password" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: "Invalid email or password" });
    }

    const token = jwt.sign({ userId: user._id, role: user.role }, SECRET_KEY, { expiresIn: "7d" });
    res.json({ token, userId: user._id, role: user.role });
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// Middleware to verify token
const authMiddleware = (req, res, next) => {
  const token = req.headers.authorization;
  if (!token) return res.status(401).json({ error: "Unauthorized" });

  jwt.verify(token, SECRET_KEY, (err, decoded) => {
    if (err) return res.status(403).json({ error: "Invalid token" });
    req.user = decoded;
    next();
  });
};

// Get user info
app.get("/user", authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId).select("-password");
    if (!user) return res.status(404).json({ error: "User not found" });

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});
// app.get("/questions", async (req, res) => {
//   try {
//     const allQuestions = await Question.find({});
//     res.json(allQuestions); // Send the response
//   } catch (error) {
//     res.status(500).json({ error: "Internal Server Error" });
//   }
// });
app.get("/questions", async (req, res) => {
  try {
    const difficulty = req.query.difficulty;
    console.log("Requested Difficulty:", difficulty);  // Debugging line
    const filter = difficulty ? { difficulty } : {};

    const allQuestions = await Question.find(filter);
    res.json(allQuestions);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});



const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));

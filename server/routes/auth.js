const express = require('express');
const User = require('../models/user');
const bcryptjs = require('bcryptjs');
const authRouter = express.Router();
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth');

// Signups a user
authRouter.post('/api/signup', async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ message: 'User already exists' });
    }

    const hashPassword = await bcryptjs.hash(password, 8);

    let newUser = new User({
      email,
      name,
      password: hashPassword,
    });

    newUser = await newUser.save();
    return res.json(newUser);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Sign in a user
authRouter.post('/api/signin', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'User not found' });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user._id }, 'secret', { expiresIn: '1h' });
    res.json({
      token,
      ...user._doc,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Authentication
authRouter.post('/api/token-is-valid', async (req, res) => {
  try {
    const token = req.header('x-auth-token');
    if (!token) return res.json(false);

    const verified = jwt.verify(token, 'secret');
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    return res.json(true);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get user
authRouter.get('/api/', auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user, token: req.token });
});

module.exports = authRouter;

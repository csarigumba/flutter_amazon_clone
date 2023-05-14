const express = require('express');
const User = require('../models/user');
const bcryptjs = require('bcryptjs');

const authRouter = express.Router();

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
authRouter.post('/api/signup', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
     if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = authRouter;

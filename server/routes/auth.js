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

module.exports = authRouter;

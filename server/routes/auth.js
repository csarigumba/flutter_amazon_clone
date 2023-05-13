const express = require('express');
const User = require('../models/user');

const authRouter = express.Router();

authRouter.post('/api/signup', async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ message: 'User already exists' });
    }

    let newUser = new User({
      email,
      name,
      password,
    });

    newUser = await newUser.save();
    return res.json(newUser);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = authRouter;

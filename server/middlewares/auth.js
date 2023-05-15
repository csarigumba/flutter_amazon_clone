const jwt = require('jsonwebtoken');

const auth = (req, res, next) => {
  try {
    const token = req.header('x-auth-token');
    if (!token) return res.status(401).json({ message: 'No authentication token, authorization denied' });

    const verified = jwt.verify(token, 'secret');
    if (!verified) return res.status(401).json({ message: 'Token verification failed, authorization denied' });

    req.user = verified.id;
    req.token = token;
    next();
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = auth;

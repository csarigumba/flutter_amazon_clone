const express = require('express');
const app = express();
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const DB_HOST =
  'mongodb+srv://cediesarigumba:Nkj1TMbkiefAauCP@cluster0.zmntlxo.mongodb.net/?retryWrites=true&w=majority';

app.use(express.json());
app.use(authRouter);

mongoose
  .connect(DB_HOST, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch(err => {
    console.log(err);
  });

const port = 3000;

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});

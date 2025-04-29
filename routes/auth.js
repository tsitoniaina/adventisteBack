const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');
require('dotenv').config();

const router = express.Router();

router.post('/register', async (req, res) => {
    const { name, email, password } = req.body;
    console.log("Body reçu :", req.body);
    if (!name || !email || !password) {
      return res.status(400).json({ error: "Tous les champs sont requis." });
    }
  
    const hashedPassword = await bcrypt.hash(password, 10);
  
    db.query(
      'INSERT INTO districts (name, email, password) VALUES (?, ?, ?)',
      [name, email, hashedPassword],
      (err, result) => {
        if (err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ error: 'Email déjà utilisé.' });
          }
          return res.status(500).json({ error: err.message });
        }
        res.status(201).json({ message: 'Compte créé avec succès' });
      }
    );
  });
  
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  db.query('SELECT * FROM districts WHERE email = ?', [email], async (err, results) => {
    if (err) return res.status(500).json({ error: err.message });

    if (results.length === 0) {
      return res.status(400).json({ error: 'Email incorrect' });
    }

    const user = results[0];
    const match = await bcrypt.compare(password, user.password);

    if (!match) return res.status(400).json({ error: 'Mot de passe incorrect' });

    const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });

    res.json({ message: 'Connexion réussie', token });
  });
});

router.get('/profile', verifyToken, (req, res) => {
  res.json({ message: `Bienvenue District ID ${req.user.id}` });
});

function verifyToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.sendStatus(401);

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
}

module.exports = router;

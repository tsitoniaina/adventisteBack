const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');
require('dotenv').config();

const router = express.Router();

router.post('/register', async (req, res) => {
  let { name, email, password, role, region_id, district_id, eglise_id } = req.body;

  const toNullableInt = (val) => (val === '' || val === undefined || val === null) ? null : parseInt(val);
  region_id = toNullableInt(region_id);
  district_id = toNullableInt(district_id);
  eglise_id = toNullableInt(eglise_id);

  if (!name || !email || !password || !role) {
    return res.status(400).json({ error: "Champs obligatoires manquants." });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    if (role === 'coordinateur_district') {
      if (!region_id || !district_id || !eglise_id) {
        return res.status(400).json({ error: "Tous les champs (région, district, église) sont requis pour le coordinateur de district." });
      }
    } else {
      region_id = null;
      district_id = null;
      eglise_id = null;
    }

    const sql = `
      INSERT INTO users (name, email, password, role, region_id, district_id, eglise_id)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `;
    const values = [name, email, hashedPassword, role, region_id, district_id, eglise_id];

    db.query(sql, values, (err, result) => {
      if (err) {
        console.error("❌ Erreur SQL :", err);
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(400).json({ error: "Email déjà utilisé." });
        }
        return res.status(500).json({ error: err.message });
      }

      res.status(201).json({ message: "Utilisateur inscrit avec succès." });
    });

  } catch (err) {
    console.error("❌ Erreur serveur :", err);
    res.status(500).json({ error: "Erreur serveur." });
  }
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

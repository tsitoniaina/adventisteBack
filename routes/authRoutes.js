const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');
const sendConfirmationEmail = require('../utils/sendMail');
const router = express.Router();
require('dotenv').config();

router.post('/register', (req, res) => {
  const { name, email, password, role, district_id, region_id } = req.body;

  if (!name || !email || !password || !role) {
    return res.status(400).json({ error: 'Champs obligatoires manquants.' });
  }

  bcrypt.hash(password, 10, (errHash, hashedPassword) => {
    if (errHash) {
      console.error('❌ Erreur hash :', errHash);
      return res.status(500).json({ error: 'Erreur de hash.' });
    }

    db.query(
      'INSERT INTO users (name, email, password, role, district_id, region_id) VALUES (?, ?, ?, ?, ?, ?)',
      [name, email, hashedPassword, role, district_id, region_id],
      async (err, result) => {
        if (err) {
          console.error("❌ Erreur MySQL :", err);
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ error: 'Email déjà utilisé.' });
          }
          return res.status(500).json({ error: err.message });
        }

        const token = jwt.sign({ id: result.insertId, email }, process.env.JWT_SECRET, { expiresIn: '1d' });

        console.log("✅ Token :", token); 

        try {
          await sendConfirmationEmail({ name, email }, token);
          console.log("📨 Email envoyé à :", email);
          res.status(201).json({ message: 'Inscription réussie. Vérifie ton e-mail.' });
        } catch (mailErr) {
          console.error("❌ Erreur Nodemailer :", mailErr);
          res.status(500).json({ error: "Erreur lors de l'envoi de l'e-mail de confirmation." });
        }
      }
    );
  });
});

router.get('/verify-email', (req, res) => {
  const { token } = req.query;
  if (!token) return res.status(400).send('Token manquant');

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) return res.status(400).send('Token invalide ou expiré');

    const userId = decoded.id;

    db.query('UPDATE users SET is_verified = true WHERE id = ?', [userId], (err, result) => {
      if (err) return res.status(500).send('Erreur serveur');
      res.send('✅ Email confirmé avec succès. Vous pouvez maintenant vous connecter.');
    });
  });
});

router.post('/login', (req, res) => {
  const { email, password } = req.body;

  db.query('SELECT * FROM users WHERE email = ?', [email], async (err, results) => {
    if (err || results.length === 0) return res.status(400).json({ error: 'Email invalide' });

    const user = results[0];
    if (!user.is_verified) {
      return res.status(403).json({ error: 'Veuillez confirmer votre adresse e-mail avant de vous connecter.' });
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(400).json({ error: 'Mot de passe invalide' });

    const token = jwt.sign(
      {
        id: user.id,
        role: user.role,
        district_id: user.district_id,
        region_id: user.region_id,
      },
      process.env.JWT_SECRET,
      { expiresIn: '2h' }
    );

    res.json({ token, user });
  });
});


module.exports = router;


const express = require('express');
const db = require('../db');
const bcrypt = require("bcrypt");
const verifyToken = require('../middleware/authMiddleware'); 

const router = express.Router();

router.post('/', verifyToken, (req, res) => {
  const { user_id, parcours } = req.body;

  if (!user_id || !parcours) {
    return res.status(400).json({ error: "Champs requis manquants." });
  }

  db.query(
    'INSERT INTO aspirants (user_id, parcours) VALUES (?, ?)',
    [user_id, parcours],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.status(201).json({ message: 'Aspirant créé avec succès' });
    }
  );
});
router.get("/district", verifyToken, (req, res) => {
  const { role, district_id } = req.user;

  if (role !== "coordinateur_district") {
    return res.status(403).json({ error: "Accès refusé" });
  }

  db.query(
    `SELECT id, name, email FROM users WHERE role = 'aspirant' AND district_id = ?`,
    [district_id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

router.post("/district", verifyToken, async (req, res) => {
  const { name, email, password, parcours } = req.body;
  const { district_id, region_id } = req.user;

  if (!name || !email || !password || !parcours) {
    return res.status(400).json({ error: "Champs requis manquants." });
  }

  if (!district_id || !region_id) {
    return res.status(400).json({ error: "district_id ou region_id manquant pour l'utilisateur." });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    // Étape 1 : créer l'utilisateur
    const insertUser = `
      INSERT INTO users (name, email, password, role, district_id, region_id)
      VALUES (?, ?, ?, 'aspirant', ?, ?)
    `;
    db.query(insertUser, [name, email, hashedPassword, district_id, region_id], (err, result) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(400).json({ error: "Email déjà utilisé." });
        }
        return res.status(500).json({ error: err.message });
      }

      const userId = result.insertId;

      // Étape 2 : créer l'aspirant
      const insertAspirant = `INSERT INTO aspirants (user_id, parcours, status) VALUES (?, ?, 'en_cours')`;
      db.query(insertAspirant, [userId, parcours], (err2) => {
        if (err2) {
          return res.status(500).json({ error: err2.message });
        }

        return res.status(201).json({ message: "Aspirant ajouté avec succès." });
      });
    });
  } catch (err) {
    res.status(500).json({ error: "Erreur serveur." });
  }
});


module.exports = router;

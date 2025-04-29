
const express = require('express');
const db = require('../db');
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
  console.log("✅ Route /aspirants/district appelée");
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


module.exports = router;

const express = require('express');
const db = require('../db');
const verifyToken = require('../middleware/authMiddleware');
const router = express.Router();

router.get('/', verifyToken, (req, res) => {
  db.query('SELECT * FROM requirements', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

router.post('/', verifyToken, (req, res) => {
  const { parcours, title, description } = req.body;
  db.query('INSERT INTO requirements (parcours, title, description) VALUES (?, ?, ?)',
    [parcours, title, description],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Exigence ajoutée' });
    });
});

router.get('/aspirants/:id/requirements', verifyToken, (req, res) => {
  console.log("✅ Route GET /aspirants/:id/requirements appelée !");
  const aspirantId = req.params.id;
  const sql = `
    SELECT ar.id AS ligne_id, r.parcours, r.title, r.description, ar.status
    FROM aspirant_requirements ar
    JOIN requirements r ON ar.requirement_id = r.id
    WHERE ar.aspirant_id = ?
    ORDER BY r.parcours
  `;
  db.query(sql, [aspirantId], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

module.exports = router;
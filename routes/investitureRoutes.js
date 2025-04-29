const express = require('express');
const db = require('../db');
const verifyToken = require('../middleware/authMiddleware');
const router = express.Router();

router.get('/', verifyToken, (req, res) => {
  db.query('SELECT * FROM investitures', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

router.post('/', verifyToken, (req, res) => {
  const { date, location, region_id, notes } = req.body;
  db.query('INSERT INTO investitures (date, location, region_id, notes) VALUES (?, ?, ?, ?)',
    [date, location, region_id, notes],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Investiture créée' });
    });
});

module.exports = router;
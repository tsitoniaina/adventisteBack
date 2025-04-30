const express = require('express');
const db = require('../db');
const router = express.Router();

router.get('/regions', (req, res) => {
  db.query('SELECT id, name FROM regions', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

router.get('/districts', (req, res) => {
  const { region_id } = req.query;
  if (!region_id) return res.status(400).json({ error: "Paramètre region_id requis." });

  db.query('SELECT id, name FROM districts WHERE region_id = ?', [region_id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

router.get('/eglises', (req, res) => {
  const { district_id } = req.query;
  if (!district_id) return res.status(400).json({ error: "Paramètre district_id requis." });

  db.query('SELECT id, name FROM eglise WHERE district_id = ?', [district_id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

module.exports = router;

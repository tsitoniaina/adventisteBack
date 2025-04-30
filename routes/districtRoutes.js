const express = require("express");
const db = require("../db");
const verifyToken = require("../middleware/authMiddleware");
const router = express.Router();

router.get("/districts/by-region", verifyToken, (req, res) => {
  const region_id = req.user.region_id;

  if (!region_id) {
    return res.status(400).json({ error: "Région non spécifiée pour cet utilisateur." });
  }

  db.query("SELECT id, name FROM districts WHERE region_id = ?", [region_id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

module.exports = router;



const express = require("express");
const db = require("../db");
const verifyToken = require("../middleware/authMiddleware");
const router = express.Router();

// ✅ Liste des aspirants de la région
router.get("/aspirants", verifyToken, (req, res) => {
  console.log("👤 Utilisateur connecté :", req.user);
  if (req.user.role !== "coordinateur_region") {
    return res.status(403).json({ error: "Accès interdit" });
  }
  const region_id = req.user.region_id;

  db.query(
    `SELECT id, name, email, district_id FROM users WHERE role = 'aspirant' AND region_id = ?`,
    [region_id],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

// ✅ Voir les mémoires en attente de validation
router.get("/memoires/en_attente", verifyToken, (req, res) => {
  if (req.user.role !== "coordinateur_region") {
    return res.status(403).json({ error: "Accès interdit" });
  }

  db.query(
    `SELECT m.*, u.name as aspirant_name FROM memoires m JOIN users u ON m.user_id = u.id WHERE m.is_validated = 0`,
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

// ✅ Valider ou refuser un mémoire
router.patch("/memoires/:id/validate", verifyToken, (req, res) => {
  if (req.user.role !== "coordinateur_region") {
    return res.status(403).json({ error: "Accès interdit" });
  }

  const memoireId = req.params.id;
  const { is_validated } = req.body; 
  const validated_by = req.user.id;

  db.query(
    `UPDATE memoires SET is_validated = ?, validated_by = ?, validated_at = NOW() WHERE id = ?`,
    [is_validated, validated_by, memoireId],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Mémoire mis à jour." });
    }
  );
});

module.exports = router;

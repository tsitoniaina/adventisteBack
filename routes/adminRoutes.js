const express = require("express");
const db = require("../db");
const verifyToken = require("../middleware/authMiddleware");

const router = express.Router();

router.get("/users", verifyToken, (req, res) => {
  if (req.user.role !== "admin") {
    return res.status(403).json({ error: "Accès refusé" });
  }

  const query = `
    SELECT u.id, u.name, u.email, u.role, u.is_verified, d.name AS district_name, r.name AS region_name
    FROM users u
    LEFT JOIN districts d ON u.district_id = d.id
    LEFT JOIN regions r ON u.region_id = r.id
  `;

  db.query(query, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

router.get("/requirements", verifyToken, (req, res) => {
  if (req.user.role !== "admin") return res.sendStatus(403);
  db.query("SELECT * FROM requirements", (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

router.get("/proofs", verifyToken, (req, res) => {
  if (req.user.role !== "admin") {
    return res.status(403).json({ error: "Accès refusé" });
  }

  db.query(
    `SELECT p.*, u.name AS aspirant_name, r.title AS requirement_title
     FROM proofs p
     JOIN users u ON p.user_id = u.id
     JOIN requirements r ON p.requirement_id = r.id`,
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});


router.get("/memoires", verifyToken, (req, res) => {
  if (req.user.role !== "admin") return res.sendStatus(403);
  db.query(
    `SELECT m.*, u.name as aspirant_name FROM memoires m JOIN users u ON m.user_id = u.id`,
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

router.patch('/users/:id/verify', (req, res) => {
  const userId = parseInt(req.params.id, 10);

  if (isNaN(userId)) {
    return res.status(400).json({ error: 'ID utilisateur invalide.' });
  }

  const sql = 'UPDATE users SET is_verified = 1 WHERE id = ?';

  db.query(sql, [userId], (err, result) => {
    if (err) {
      console.error('❌ Erreur SQL :', err);
      return res.status(500).json({ error: 'Erreur lors de la mise à jour.' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Utilisateur non trouvé.' });
    }

    res.json({ message: '✅ Utilisateur activé avec succès.' });
  });
});


module.exports = router;

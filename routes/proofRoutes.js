const express = require("express");
const multer = require("multer");
const path = require("path");
const db = require("../db");
const verifyToken = require("../middleware/authMiddleware");

const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const name = `proof-${Date.now()}${ext}`;
    cb(null, name);
  },
});

router.get("/", verifyToken, (req, res) => {
    const user_id = req.user.id;
  
    db.query(
      "SELECT * FROM proofs WHERE user_id = ?",
      [user_id],
      (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
      }
    );
  });
  
const upload = multer({ storage });
router.post("/", verifyToken, upload.single("file"), (req, res) => {
  const { requirement_id } = req.body;
  const user_id = req.user.id;

  if (!req.file) {
    return res.status(400).json({ error: "Aucun fichier envoyé" });
  }

  const filePath = req.file.filename;

  db.query(
    "INSERT INTO proofs (user_id, requirement_id, file_path) VALUES (?, ?, ?)",
    [user_id, requirement_id, filePath],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Preuve enregistrée", file: filePath });
    }
  );
});

router.patch("/:id/validate", verifyToken, (req, res) => {
    const proofId = req.params.id;
    const { status } = req.body;
  
    if (!["valide", "refuse"].includes(status)) {
      return res.status(400).json({ error: "Statut invalide" });
    }
  
    db.query(
      "UPDATE proofs SET status = ? WHERE id = ?",
      [status, proofId],
      (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: `Preuve ${status} avec succès.` });
      }
    );
  });
  
  router.get("/validation", verifyToken, (req, res) => {
    console.log("✅ Coordinateur connecté :", req.user); // ← ICI
    const district_id = req.user.district_id;
  
    db.query(
      `SELECT p.*, u.name AS aspirant_name, r.title AS requirement_title
       FROM proofs p
       JOIN users u ON p.user_id = u.id
       JOIN requirements r ON p.requirement_id = r.id
       WHERE p.status = 'en_attente' AND u.district_id = ?`,
      [district_id],
      (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
      }
    );
  });
  
  

module.exports = router;

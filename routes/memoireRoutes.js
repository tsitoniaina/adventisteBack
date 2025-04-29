
const express = require("express");
const multer = require("multer");
const path = require("path");
const verifyToken = require("../middleware/authMiddleware");
const db = require("../db");

const router = express.Router();

router.get("/", verifyToken, (req, res) => {
    const user_id = req.user.id;
  
    db.query(
      "SELECT * FROM memoires WHERE user_id = ?",
      [user_id],
      (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
      }
    );
  });
  
// 📦 Configuration du stockage multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/"); // 📁 Le fichier sera stocké ici
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const filename = `memoire-${Date.now()}${ext}`;
    cb(null, filename);
  },
});


const upload = multer({ storage });

// 🧾 Endpoint pour soumettre un mémoire (PDF)
router.post("/", verifyToken, upload.single("file"), (req, res) => {
  const user_id = req.user.id;

  if (!req.file) {
    return res.status(400).json({ error: "Aucun fichier reçu" });
  }

  const file_path = req.file.filename;

  db.query(
    "INSERT INTO memoires (user_id, file_path) VALUES (?, ?)",
    [user_id, file_path],
    (err) => {
      if (err) {
        console.error("❌ Erreur DB :", err);
        return res.status(500).json({ error: err.message });
      }
      res.status(201).json({ message: "Mémoire soumis avec succès !" });
    }
  );
});

module.exports = router;

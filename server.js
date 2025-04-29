const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 4000;

app.use(cors());         
app.use(express.json());  

app.post('/location', (req, res) => {
  const { latitude, longitude, accuracy, timestamp } = req.body;

  if (!latitude || !longitude) {
    return res.status(400).json({ error: 'Coordonnées manquantes' });
  }

  console.log('📍 Nouvelle position reçue :');
  console.log(`Latitude: ${latitude}`);
  console.log(`Longitude: ${longitude}`);
  console.log(`Précision: ${accuracy} mètres`);
  console.log(`Date: ${new Date(timestamp).toLocaleString()}`);

  return res.status(200).json({ message: 'Position enregistrée avec succès !' });
});

app.listen(PORT, () => {
  console.log(`🚀 Serveur backend en écoute sur http://localhost:${PORT}`);
});

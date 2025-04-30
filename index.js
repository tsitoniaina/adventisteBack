const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const path = require('path');


const authRoutes = require('./routes/authRoutes');
const aspirantRoutes = require('./routes/aspirantRoutes');
const requirementRoutes = require('./routes/requirementRoutes');
const investitureRoutes = require('./routes/investitureRoutes');
const memoireRoutes = require('./routes/memoireRoutes');
const regionRoutes = require('./routes/regionRoutes');
const adminRoutes = require('./routes/adminRoutes');
const locationRoutes = require('./routes/locationRoutes');
const proofRoutes = require('./routes/proofRoutes');

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/aspirants', aspirantRoutes);
app.use('/api/requirements', requirementRoutes);
app.use('/api/investitures', investitureRoutes);
app.use('/api/memoires', memoireRoutes);
app.use('/api/proofs', proofRoutes);
app.use('/api/region', regionRoutes);
app.use('/api/admin', adminRoutes);
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/api/locations', locationRoutes);


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Serveur lancé sur http://localhost:${PORT}`);
});


const verifyToken = require('./middleware/authMiddleware');

console.log(typeof verifyToken); // Doit afficher "function"

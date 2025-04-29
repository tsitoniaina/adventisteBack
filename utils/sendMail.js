// const nodemailer = require('nodemailer');
// require('dotenv').config();

// const transporter = nodemailer.createTransport({
//   service: 'gmail',
//   auth: {
//     user: process.env.MAIL_USER,
//     pass: process.env.MAIL_PASS,
//   },
// });

// const sendConfirmationEmail = async (user, token) => {
//   const url = `${process.env.BASE_URL}/api/auth/verify-email?token=${token}`;
// console.log(url);
//   const mailOptions = {
//     from: `"Jeunesse" <${process.env.MAIL_USER}>`,
//     to: user.email,
//     subject: 'Confirme ton inscription',
//     html: `
//       <h3>Bienvenue ${user.name} !</h3>
//       <p>Merci de t'inscrire. Clique sur le lien suivant pour confirmer ton adresse e-mail :</p>
//       <a href="${url}">${url}</a>
//     `
//   };

//   try {
//     const info = await transporter.sendMail(mailOptions);
//     console.log('✅ Email envoyé :', info.messageId);
//     return info;
//   } catch (error) {
//     console.error('❌ Erreur lors de l’envoi de l’e-mail :', error);
//     throw error;
//   }
// };

// module.exports = sendConfirmationEmail;
const nodemailer = require('nodemailer');
require('dotenv').config();

const transporter = nodemailer.createTransport({
  host: 'mail.irayteam.com',
  port: 465,
  secure: true, // TLS => true car port 465
  auth: {
    user: 'animogeo@irayteam.com',
    pass: 'FxSXMi1yeq',
  },
  tls: {
    rejectUnauthorized: false // parfois nécessaire pour serveurs personnalisés
  }
});

const sendConfirmationEmail = async (user, token) => {
  const url = `${process.env.BASE_URL}/api/auth/verify-email?token=${token}`;

  const mailOptions = {
    from: `"Jeunesse" <${process.env.SENDER_MAIL}>`,
    to: user.email,
    subject: 'Confirme ton inscription',
    html: `
      <h3>Bienvenue ${user.name} !</h3>
      <p>Merci de t'inscrire. Clique sur le lien suivant pour confirmer ton adresse e-mail :</p>
      <a href="${url}">${url}</a>
    `
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log('📨 Email envoyé :', info.messageId);
    return info;
  } catch (error) {
    console.error('❌ Erreur d’envoi d’e-mail :', error);
    throw error;
  }
};

module.exports = sendConfirmationEmail;

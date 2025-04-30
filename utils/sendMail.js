const nodemailer = require('nodemailer');
require('dotenv').config();

const transporter = nodemailer.createTransport({
  host: 'mail.irayteam.com',
  port: 465,
  secure: true, 
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
      <p>Merci pour votre inscription.</p>
      <p>Votre compte est en attente de validation par un administrateur. Vous recevrez un email de confirmation une fois votre compte activé.</p>
      <p>Nous vous remercions pour votre patience.</p>
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

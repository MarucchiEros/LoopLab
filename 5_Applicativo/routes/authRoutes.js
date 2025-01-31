const express = require("express");
const router = express.Router();
const authController = require("../controllers/authController"); // Importa il controller per l'autenticazione

// Rotte di autenticazione
router.get("/", authController.home); // Home page
router.get("/login", authController.loginPage); // Pagina di login
router.post("/register", authController.register); // Registrazione utente
router.post("/login", authController.login); // Login utente

module.exports = router; // Esporta il router

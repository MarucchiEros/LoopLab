const express = require("express");
const hbs = require("hbs");
const bodyParser = require("body-parser");
const path = require("path");
const session = require("express-session"); // Aggiungi express-session
const authRoutes = require("./routes/authRoutes"); // Importa le rotte di autenticazione

const app = express();

// Configurazione della sessione
app.use(session({
  secret: "your_secret_key", // Modifica con una chiave segreta
  resave: false,
  saveUninitialized: true,
}));

// Middleware per il parsing dei body delle richieste
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Configurazione HBS
app.set("view engine", "hbs");
app.set("views", path.join(__dirname, "views")); // Cartella views

// Servire file statici (CSS, JS, immagini)
app.use(express.static(path.join(__dirname, "public")));

// Usa le rotte di autenticazione (login, registrazione, etc.)
app.use(authRoutes); // Usa il router per le rotte di autenticazione

// Rotta per la home (visibile solo se l'utente è loggato)
app.get("/home", (req, res) => {
    if (req.session.user) {
        res.render("home", { user: req.session.user }); // Renderizza la home con i dati dell'utente
    } else {
        res.redirect("/login"); // Se l'utente non è loggato, reindirizza alla pagina di login
    }
});

// Rotta di logout (chiude la sessione dell'utente)
app.get("/logout", (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return res.status(500).send("Errore durante il logout");
        }
        res.redirect("/login"); // Reindirizza alla pagina di login dopo il logout
    });
});

// Porta del server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server avviato su http://localhost:${PORT}`));

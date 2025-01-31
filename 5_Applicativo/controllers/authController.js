const bcrypt = require("bcrypt");
const db = require("../db"); // Assicurati che questo file sia configurato correttamente

// Home page: solo gli utenti loggati possono accedervi
exports.home = (req, res) => {
    if (req.session.user) {
        res.render("home", { user: req.session.user });
    } else {
        res.redirect("/login");
    }
};

// Pagina di login
exports.loginPage = (req, res) => {
    res.render("login"); // Assicurati che il template 'login.hbs' esista
};

// Registrazione utente
exports.register = (req, res) => {
    const { first_name, last_name, username, email, password } = req.body;

    bcrypt.hash(password, 10, (err, hashedPassword) => {
        if (err) {
            return res.status(500).send("Errore durante l'hash della password");
        }

        const query = "INSERT INTO users (first_name, last_name, username, email, password_hash) VALUES (?, ?, ?, ?, ?)";
        db.query(query, [first_name, last_name, username, email, hashedPassword], (err, result) => {
            if (err) {
                return res.status(500).send("Errore durante la registrazione dell'utente");
            }

            res.redirect("/login");
        });
    });
};

// Login utente
exports.login = (req, res) => {
    const { username, password } = req.body;

    const query = "SELECT * FROM users WHERE username = ?";
    db.query(query, [username], (err, result) => {
        if (err) {
            return res.status(500).send("Errore durante la ricerca dell'utente");
        }

        if (result.length === 0) {
            return res.status(400).send("Username non trovato");
        }

        const user = result[0];

        bcrypt.compare(password, user.password_hash, (err, isMatch) => {
            if (err) {
                return res.status(500).send("Errore durante il confronto delle password");
            }

            if (isMatch) {
                req.session.user = user;
                res.redirect("/home");
            } else {
                res.status(400).send("Password errata");
            }
        });
    });
};

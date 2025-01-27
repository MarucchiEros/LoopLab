-- Creazione del database
DROP DATABASE IF EXISTS LoopLab;
CREATE DATABASE LoopLab;

-- Utilizzo del database
USE LoopLab;

-- Tabella per gli utenti
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabella per i suoni predefiniti
DROP TABLE IF EXISTS sounds;
CREATE TABLE sounds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    type ENUM('effect', 'instrument') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabella per le colonne sonore create dagli utenti
DROP TABLE IF EXISTS soundtracks;
CREATE TABLE soundtracks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabella per i cerchi nella composizione
DROP TABLE IF EXISTS circles;
CREATE TABLE circles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    soundtrack_id INT NOT NULL,
    radius FLOAT NOT NULL,
    volume FLOAT NOT NULL,
    position_x FLOAT NOT NULL,
    position_y FLOAT NOT NULL,
    sound_id INT,
    FOREIGN KEY (soundtrack_id) REFERENCES soundtracks(id) ON DELETE CASCADE,
    FOREIGN KEY (sound_id) REFERENCES sounds(id)
);

-- Tabella per gli effetti applicati ai suoni
DROP TABLE IF EXISTS effects;
CREATE TABLE effects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    parameters JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabella per associare effetti ai cerchi
DROP TABLE IF EXISTS circle_effects;
CREATE TABLE circle_effects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    circle_id INT NOT NULL,
    effect_id INT NOT NULL,
    FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE,
    FOREIGN KEY (effect_id) REFERENCES effects(id) ON DELETE CASCADE
);

-- Tabella per i suoni caricati dagli utenti
DROP TABLE IF EXISTS user_sounds;
CREATE TABLE user_sounds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabella per i log degli errori e delle attività
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    log_level ENUM('INFO', 'WARNING', 'ERROR') NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

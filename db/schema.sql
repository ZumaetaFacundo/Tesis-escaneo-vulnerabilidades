CREATE DATABASE IF NOT EXISTS proyecto_java
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE proyecto_java;

CREATE TABLE assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM('IP', 'HOST', 'WEB') NOT NULL,
    address VARCHAR(255) NOT NULL,
    criticality ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE scans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    scan_type ENUM('NMAP', 'OPENVAS', 'ZAP') NOT NULL,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'RUNNING', 'FINISHED', 'FAILED') NOT NULL,
    FOREIGN KEY (asset_id) REFERENCES assets(id)
);

CREATE TABLE vulnerabilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    scan_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    severity ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') NOT NULL,
    cvss_score DECIMAL(3,1),
    description TEXT,
    FOREIGN KEY (scan_id) REFERENCES scans(id)
);

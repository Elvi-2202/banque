CREATE TABLE client (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    date_naissance DATE NOT NULL,
    dt_entrer_relation DATE,
    mdp VARCHAR(255) NOT NULL,
    dt_crea TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_modif TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE compte_bancaire (
    id_compte INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('COURANT','EPARGNE') NOT NULL,
    numero_compte VARCHAR(30) NOT NULL UNIQUE,
    solde DECIMAL(15, 2) DEFAULT 0 CHECK (solde >= 0),
    devise VARCHAR(10) DEFAULT 'EUR',
    statut VARCHAR(20),  
    dt_crea TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_modif TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_client INT NOT NULL,
    FOREIGN KEY (id_client) REFERENCES client(id_client)
 
);
 
CREATE TABLE transaction_bancaire (
    id_transaction INT AUTO_INCREMENT PRIMARY KEY,
    montant DECIMAL(15,2) NOT NULL,
    dt_crea TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    description TEXT,
    id_compte_bancaire INT NOT NULL,
    type ENUM('VIREMENT','DEPOT','RETRAIT') NOT NULL,
    FOREIGN KEY (id_compte_bancaire) REFERENCES compte_bancaire(id_compte)
);
 
CREATE TABLE type_operation (
    id_type INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);
 
CREATE TABLE operation (    
  id_operation INT PRIMARY KEY,  
  montant DECIMAL(15, 2) NOT NULL CHECK (montant > 0),
  statut ENUM('EN_ATTENTE','VALIDE','REFUSE') DEFAULT 'EN_ATTENTE',
  dt_exec TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
  ref_destinataire VARCHAR(50),  
  description TEXT,
  id_transaction_bancaire INT NOT NULL,
  id_type_operation INT NOT NULL,
  FOREIGN KEY (id_transaction_bancaire) REFERENCES transaction_bancaire(id_transaction),
  FOREIGN KEY (id_type_operation) REFERENCES type_operation(id_type)
);
 
CREATE TABLE beneficiaire (
    id_beneficiaire INT AUTO_INCREMENT PRIMARY KEY,
    iban VARCHAR(34) NOT NULL UNIQUE,
    nom VARCHAR(150) NOT NULL,
    dt_crea TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_client INT NOT NULL,
    FOREIGN KEY (id_client) REFERENCES client(id_client) ON DELETE RESTRICT
);
 
CREATE TABLE carte_bancaire (
    id_carte INT AUTO_INCREMENT PRIMARY KEY,
    numero_carte VARCHAR(20) NOT NULL UNIQUE,
    dt_expiration DATE NOT NULL,
    cvc CHAR(3) NOT NULL,
    plafond_paiement DECIMAL(15,2) NOT NULL,
    statut ENUM('ACTIVE','BLOQUEE','EXPIREE') DEFAULT 'ACTIVE',
    id_compte_bancaire INT NOT NULL,
    FOREIGN KEY (id_compte_bancaire) REFERENCES compte_bancaire(id_compte)
);
 
CREATE TABLE systeme (
    id_systeme INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','ANALYSTE','SUPPORT') NOT NULL,
    dt_crea TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 
);
 
CREATE TABLE alerte_fraude (
    id_alerte_fraude INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    statut ENUM('EN_COURS','TRAITEE','FAUSSE_ALERTE') DEFAULT 'EN_COURS',
    dt_alerte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dt_resolu TIMESTAMP NULL,
    id_transaction INT NOT NULL,
    id_systeme INT NULL,
    FOREIGN KEY (id_transaction) REFERENCES transaction_bancaire(id_transaction) ON DELETE RESTRICT,
    FOREIGN KEY (id_systeme) REFERENCES systeme(id_systeme) ON DELETE SET NULL
 
);
 
CREATE TABLE audit_logs (  
  id_audit INT AUTO_INCREMENT PRIMARY KEY,  
  id_client INT,  
  id_systeme INT,
  id_compte INT NULL,
  id_transaction INT NULL,
  action_effectuee VARCHAR(255) NOT NULL,  
  dt_action TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),
  details_technique TEXT,  
  FOREIGN KEY (id_client) REFERENCES client(id_client),
  FOREIGN KEY (id_systeme) REFERENCES systeme(id_systeme),
  FOREIGN KEY (id_compte) REFERENCES compte_bancaire(id_compte),
  FOREIGN KEY (id_transaction) REFERENCES transaction_bancaire(id_transaction)
 
);
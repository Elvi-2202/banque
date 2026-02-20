INSERT INTO client (nom, prenom, email, date_naissance, dt_entrer_relation, mdp) VALUES
('Dupont', 'Jean', 'jean.dupont@email.com', '1985-05-12', '2020-01-10', 'hash_mdp_1'),
('Martin', 'Alice', 'alice.martin@email.com', '1992-09-23', '2021-03-15', 'hash_mdp_2'),
('Durand', 'Marc', 'marc.durand@email.com', '1978-12-01', '2019-06-20', 'hash_mdp_3'),
('Lefebvre', 'Sophie', 'sophie.lefe@email.com', '1995-02-28', '2022-11-05', 'hash_mdp_4'),
('Moreau', 'Lucas', 'lucas.moreau@email.com', '2000-07-14', '2023-01-12', 'hash_mdp_5');
 
 
 
INSERT INTO compte_bancaire (type, numero_compte, solde, devise, statut, id_client) VALUES
('COURANT', 'FR7612345678901', 1550.00, 'EUR', 'ACTIF', 1),
('EPARGNE', 'FR7612345678902', 5000.50, 'EUR', 'ACTIF', 1),
('COURANT', 'FR7622345678903', 250.00, 'EUR', 'ACTIF', 2),
('COURANT', 'FR7633345678904', 12300.00, 'EUR', 'ACTIF', 3),
('COURANT', 'FR7644345678905', 10.00, 'EUR', 'ACTIF', 4);
 
 
INSERT INTO transaction_bancaire (montant, description, id_compte_bancaire, type) VALUES
(50.00, 'Courses Supermarché', 1, 'RETRAIT'),
(200.00, 'Loyer Janvier', 3, 'VIREMENT'),
(1500.00, 'Salaire', 1, 'DEPOT'),
(20.00, 'Abonnement Netflix', 4, 'RETRAIT'),
(100.00, 'Anniversaire', 5, 'DEPOT');
 
 
INSERT INTO type_operation (libelle) VALUES
('Paiement CB'), ('Virement Sortant'), ('Virement Entrant'), ('Retrait DAB'), ('Frais Bancaires');
 
 
INSERT INTO operation (id_operation, montant, statut, ref_destinataire, description, id_transaction_bancaire, id_type_operation) VALUES
(1, 50.00, 'VALIDE', 'Leclerc', 'Achat nourriture', 1, 1),
(2, 200.00, 'EN_ATTENTE', 'Propriétaire', 'Loyer', 2, 2),
(3, 1500.00, 'VALIDE', 'Employeur SAS', 'Salaire mensuel', 3, 3),
(4, 20.00, 'VALIDE', 'Netflix', 'Streaming', 4, 1),
(5, 100.00, 'REFUSE', 'Ami Lucas', 'Cadeau', 5, 2);
 
INSERT INTO beneficiaire (iban, nom, id_client) VALUES
('FR76999888777666', 'EDF Energie', 1),
('FR76111222333444', 'Propriétaire Appart', 2),
('FR76555444333222', 'Ma Maman', 3),
('FR76000111222333', 'Garage Auto', 1),
('FR76444555666777', 'Impôts Gouv', 4);
 
 
INSERT INTO carte_bancaire (numero_carte, dt_expiration, cvc, plafond_paiement, statut, id_compte_bancaire) VALUES
('4970123456789012', '2026-12-31', '123', 2000.00, 'ACTIVE', 1),
('4970999988887777', '2027-06-30', '999', 500.00, 'ACTIVE', 1),
('4970223456789013', '2025-06-30', '456', 1500.00, 'ACTIVE', 3),
('4970333456789014', '2027-01-15', '789', 5000.00, 'ACTIVE', 4),
('4970443456789015', '2024-03-20', '321', 1000.00, 'BLOQUEE', 5);
 
 
INSERT INTO systeme (email, password, role) VALUES
('admin@banque.com', 'pass_admin_1', 'ADMIN'),
('support1@banque.com', 'pass_supp_1', 'SUPPORT'),
('analyste_fraude@banque.com', 'pass_ana_1', 'ANALYSTE'),
('admin2@banque.com', 'pass_admin_2', 'ADMIN'),
('support2@banque.com', 'pass_supp_2', 'SUPPORT');
 
 
INSERT INTO alerte_fraude (type, statut, dt_alerte, dt_resolu, id_transaction, id_systeme) VALUES
('Montant inhabituel', 'EN_COURS', CURRENT_TIMESTAMP, NULL, 3, 3),
('Lieu suspect', 'TRAITEE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, 3),
('Doublon', 'FAUSSE_ALERTE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 2, 3),
('Compte inactif', 'EN_COURS', CURRENT_TIMESTAMP, NULL, 4, 3),
('Tentative forcée', 'TRAITEE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 5, 1);
 
 
INSERT INTO audit_logs (id_client, id_systeme, id_compte, id_transaction, action_effectuee, ip_address, details_technique) VALUES
(1, 1, 1, 1, 'Connexion client', '192.168.1.1', 'Navigateur Chrome Windows'),
(1, 1, 1, 1, 'Modification plafond carte', '10.0.0.5', 'Admin ID 1 changed limit'),
(2, 2, 3, 2, 'Émission virement', '82.45.12.3', 'App Mobile iOS'),
(3, 3, 1, 3, 'Analyse Fraude', '10.0.0.22', 'Scan automatique'),
(4, 4, 5, 4, 'Échec authentification', '176.12.34.56', '3 tentatives erronées');
 
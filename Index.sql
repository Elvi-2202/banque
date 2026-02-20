CREATE INDEX idx_client_email ON client(email);
CREATE INDEX idx_compte_solde ON compte_bancaire(solde);
CREATE INDEX idx_transac_date ON transaction_bancaire(dt_crea);
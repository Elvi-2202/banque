CREATE PROCEDURE effectuer_virement(
    IN p_source INT,
    IN p_destination INT,
    IN p_montant DECIMAL(15,2),
    IN p_description VARCHAR(255),
    IN p_client INT,
    IN p_systeme INT

)

BEGIN
    DECLARE solde_source DECIMAL(15,2);
    DECLARE trans_id INT;
    START TRANSACTION;
    SELECT solde INTO solde_source
    FROM compte_bancaire
    WHERE id_compte = p_source
    FOR UPDATE;

    IF solde_source < p_montant THEN
        INSERT INTO transaction_bancaire(montant, id_compte_bancaire, type, description)
        VALUES (p_montant, p_source, 'VIREMENT', CONCAT('ECHEC : ', p_description));
        INSERT INTO audit_logs(id_client, id_systeme, id_compte, action_effectuee, details_technique)
        VALUES (p_client, p_systeme, p_source, 'Virement annulé', CONCAT('Solde insuffisant : ', p_montant));
        ROLLBACK;
 
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Solde insuffisant pour effectuer le virement.';
    END IF;

    UPDATE compte_bancaire
    SET solde = solde - p_montant
    WHERE id_compte = p_source;
 
    UPDATE compte_bancaire
    SET solde = solde + p_montant
    WHERE id_compte = p_destination;

    INSERT INTO transaction_bancaire(montant, id_compte_bancaire, type, description)
    VALUES (p_montant, p_source, 'VIREMENT', p_description);
    SET trans_id = LAST_INSERT_ID();

    INSERT INTO audit_logs(id_client, id_systeme, id_compte, id_transaction, action_effectuee, details_technique)
    VALUES (p_client, p_systeme, p_source, trans_id, 'Virement exécuté', CONCAT('Vers compte ', p_destination, ', montant : ', p_montant));
   
    COMMIT;
 
END


CALL effectuer_virement(1, 3, 100.00, 'Paiement loyer', 1, 1);
CALL effectuer_virement(5, 1, 5000.00, 'Test virement', 4, 1);
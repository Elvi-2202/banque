CREATE PROCEDURE virement_securise (
    IN p_compte_source INT,
    IN p_compte_destination INT,
    IN p_montant DECIMAL(15,2),
    IN p_description TEXT
)
BEGIN
    DECLARE v_solde DECIMAL(15,2);
 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        INSERT INTO audit_logs (
            id_compte,
            action_effectuee,
            details_technique
        )
        VALUES (
            p_compte_source,
            'ECHEC VIREMENT',
            'Erreur SQL detectee - rollback automatique'
        );
    END;
 
    START TRANSACTION;
 
    SELECT solde INTO v_solde
    FROM compte_bancaire
    WHERE id_compte = p_compte_source
    FOR UPDATE;
 
    IF v_solde < p_montant THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solde insuffisant';
    END IF;
 
    UPDATE compte_bancaire
    SET solde = solde - p_montant
    WHERE id_compte = p_compte_source;
 
    UPDATE compte_bancaire
    SET solde = solde + p_montant
    WHERE id_compte = p_compte_destination;
 
    INSERT INTO transaction_bancaire
        (montant, description, id_compte_bancaire, type)
    VALUES
        (p_montant, p_description, p_compte_source, 'VIREMENT');

    INSERT INTO audit_logs
        (id_compte, action_effectuee, details_technique)
    VALUES
        (p_compte_source, 'VIREMENT REUSSI', CONCAT('Montant : ', p_montant));
 
    COMMIT;
END


Verifier les soldes avant : SELECT * FROM compte_bancaire WHERE id_compte IN (1,3);
Lancer le virement : CALL virement_securise(1, 3, 100, 'Test virement');
Verifier les soldes après : SELECT * FROM compte_bancaire WHERE id_compte IN (1,3);
Verifier les logs : SELECT * FROM audit_logs ORDER BY id_audit DESC LIMIT 1;

verifier si le solde est insuffisant : CALL virement_securise(1, 3, 100000, 'Test solde insuffisant');
verification : SELECT * FROM compte_bancaire WHERE id_compte IN (1,3);
Verifier les soldes après : SELECT * FROM compte_bancaire WHERE id_compte IN (1,3);
Verifier les logs : SELECT * FROM audit_logs ORDER BY id_audit DESC LIMIT 1;

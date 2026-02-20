WITH volumetotal AS (
    SELECT
        id_client,
        SUM(solde) as montants_déposés
    FROM compte_bancaire
    GROUP BY id_client
)
SELECT
    client.nom,
    client.prenom,
    volumetotal.montants_déposés,
    RANK() OVER (ORDER BY  volumetotal.montants_déposés DESC) as rang
FROM volumetotal
JOIN client ON volumetotal .id_client = client.id_client
LIMIT 10
;
 
 
WITH DetectionAnomalie AS (
    SELECT
        id_transaction,
        id_compte_bancaire,
        montant,
        type,
        AVG(montant) OVER (PARTITION BY id_compte_bancaire) AS moyenne
    FROM transaction_bancaire
)
SELECT *
FROM DetectionAnomalie
WHERE type = 'RETRAIT' ;
 
SELECT * FROM compte_bancaire;
SELECT * FROM transaction_bancaire;
 
 
 
SELECT
    compte_bancaire.type AS type_du_compte,
    COUNT(transaction_bancaire.id_transaction) AS nombre_de_depots,
    SUM(transaction_bancaire.montant) AS montant_total_depose
FROM transaction_bancaire
JOIN compte_bancaire ON transaction_bancaire.id_compte_bancaire = compte_bancaire.id_compte
WHERE transaction_bancaire.type = 'DEPOT'
GROUP BY compte_bancaire.type WITH ROLLUP;
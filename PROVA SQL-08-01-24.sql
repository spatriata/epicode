create database My_e_commerce2;
CREATE TABLE if not exists vendite2 (
    id_transazione INT auto_increment primary key,
    categoria_prodotto VARCHAR(255),
    costo_vendita DECIMAL(10, 2),
    sconto DECIMAL(5, 2)
);
CREATE TABLE if not exists dettagli_vendite2 (
    id_transazione INT,
    data_transazione DATE,
    quantita_acquistata INT
);

--- il workbench mysql prende i contraits anche se minuscoli 

INSERT INTO vendite2 (categoria_prodotto, costo_vendita, sconto)
VALUES
('Elettronica', 500.00, 0.10),
('Abbigliamento', 1275.50, 0.05),
('Casa e Arredamento', 200.00, 0.15),
('Libri', 30.00, 0.15),
('Attrezzatura sportiva', 120.75, 0.08),
('Elettronica', 800.00, 0.12),
('Abbigliamento', 450.99, 0.03),
('Casa e Arredamento', 1500.25, 0.10),
('Libri', 25.50, 0.15),
('Attrezzatura sportiva', 90.00, 0.07);

INSERT INTO dettagli_vendite2 (id_transazione, data_transazione, quantita_acquistata)
VALUES
(1, '2023-12-01', 2),
(2, '2023-12-02', 1),
(3, '2023-11-03', 3),
(4, '2023-10-04', 5),
(5, '2023-10-05', 2),
(6, '2023-09-06', 1),
(7, '2023-08-07', 4),
(8, '2023-07-08', 2),
(9, '2023-07-09', 3),
(10, '2023-05-10', 1);

--- tutte le vendite avvenute in una data precisa. Siccome non avevo per nessuna vendita lo stesso giorno, ho selezionato solo lo stesso mese e anno 
SELECT id_transazione, quantita_acquistata
FROM dettagli_vendite2
WHERE DATE_FORMAT(data_transazione, '%Y-%m') = '2023-10';

--- aggiungo dei valori per il 50% di sconto perché non ne ho

INSERT INTO vendite2 (categoria_prodotto, costo_vendita, sconto)
Values
('Abbigliamento', 400.09, 0.6),
('Elettronica', 3000.12, 0.6);

INSERT INTO dettagli_vendite2 (id_transazione, data_transazione, quantita_acquistata)
VALUES
(2, '2023-01-08', 1),
(1, '2023-01-08', 2);

--- sconto maggiore al 50%.
select categoria_prodotto, costo_vendita
FROM vendite2
WHERE sconto > 0.5;

--- aggiungo altri valori al dataset
INSERT INTO vendite2 (categoria_prodotto, costo_vendita, sconto)
VALUES
('Abbigliamento', 600.00, 0.20),
('Libri', 40.00, 0.10),
('Casa e Arredamento', 300.50, 0.08),
('Attrezzatura sportiva', 150.25, 0.12),
('Elettronica', 1200.99, 0.15),
('Libri', 35.00, 0.05),
('Attrezzatura sportiva', 80.00, 0.10),
('Casa e Arredamento', 1800.75, 0.18),
('Abbigliamento', 500.50, 0.07),
('Elettronica', 750.00, 0.10),
('Abbigliamento', 600.00, 0.20),
('Libri', 40.00, 0.10),
('Casa e Arredamento', 300.50, 0.08),
('Attrezzatura sportiva', 150.25, 0.12),
('Elettronica', 1200.99, 0.15),
('Libri', 35.00, 0.05),
('Attrezzatura sportiva', 80.00, 0.10),
('Casa e Arredamento', 1800.75, 0.18),
('Abbigliamento', 500.50, 0.07),
('Elettronica', 750.00, 0.10);

INSERT INTO dettagli_vendite2 (id_transazione, data_transazione, quantita_acquistata)
VALUES
(13, '2023-10-15', 2),
(14, '2023-10-15', 1),
(15, '2023-10-15', 3),
(16, '2023-10-16', 5),
(17, '2023-10-16', 2),
(18, '2023-10-16', 1),
(19, '2023-10-17', 4),
(20, '2023-10-17', 2),
(21, '2023-10-17', 3),
(22, '2023-10-18', 1),
(11, '2023-10-15', 2),
(12, '2023-10-15', 1),
(13, '2023-10-15', 3),
(14, '2023-10-16', 5),
(15, '2023-10-16', 2),
(16, '2023-10-16', 1),
(17, '2023-10-17', 4),
(18, '2023-10-17', 2),
(19, '2023-10-17', 3),
(20, '2023-10-18', 1)
;

--- Calcola il totale delle vendite per categoria.
SELECT categoria_prodotto, SUM(costo_vendita) as totale_vendite_categoria
from vendite2
group by categoria_prodotto;
 
--- numero totale di prodotti venduti per ogni categoria.
Select v.categoria_prodotto,
count(dv.id_transazione) As numero_totale_p_venduti
from vendite2 v
join dettagli_vendite2 dv on v.id_transazione = dv.id_transazione
group by v.categoria_prodotto;

--- Seleziona le vendite ultimo trimestre

SELECT dv.id_transazione, dv.quantita_acquistata, dv.data_transazione,  v.categoria_prodotto
from dettagli_vendite2 dv
join vendite2 v on dv.id_transazione = v.id_transazione
where dv.data_transazione between CURDATE() - INTERVAL 3 MONTH AND CURDATE(); 

--- voglio provare anche a contare il numero di prodotti venduti

Select v.categoria_prodotto, count(dv.id_transazione) as numero_prodotti_venduti_trimestre
from vendite2 v
join dettagli_vendite2 dv on v.id_transazione = dv.id_transazione
where dv.data_transazione between current_date() - INTERVAL 3 MONTH and current_date()
group by v.categoria_prodotto;

--- già che ci sono, provo anche a fare la somma del costo delle vendite
Select v.categoria_prodotto, sum(v.costo_vendita) as totale_guadagno_trimestre
from vendite2 v
join dettagli_vendite2 dv on v.id_transazione = dv.id_transazione
where dv.data_transazione between current_date() - INTERVAL 3 MONTH and current_date()
group by categoria_prodotto;

---  Raggruppa le vendite per mese e calcola il totale delle vendite per ogni mese.
Select DATE_FORMAT(dv.data_transazione,'%M-%y') AS mese_transazione, sum(v.costo_vendita) as totale_guadagno_mensile
from vendite2 v
join dettagli_vendite2 dv on v.id_transazione = dv.id_transazione
group by mese_transazione;

--- Trova la categoria con lo sconto medio più alto.
SELECT categoria_prodotto, AVG(sconto) AS media_sconto
FROM vendite2
GROUP BY categoria_prodotto
ORDER BY media_sconto DESC
limit 1;

--- Confronta le vendite mese per mese per vedere incremento o il decremento delle vendite. Calcola l’incremento o decremento mese per mese
---- Ho dovuto fare una ricerca per svolgere questo punto perché non capivo come farlo con le funzioni che conoscevo. Ho visto che posso utilizzare le funzione 'lag'  

--- ho provato a farlo con un unico passaggio ma mi dava errore. Ho pensato di creare una vista per le vendite mensili e dopo calcolare incremento. 
create view VenditeMensili2 as
Select categoria_prodotto, DATE_FORMAT(dv.data_transazione,'%M-%y') AS mese_transazione, 
sum(v.costo_vendita) as totale_guadagno_mensile
from vendite2 v
join dettagli_vendite2 dv on v.id_transazione = dv.id_transazione
group by mese_transazione, categoria_prodotto;

SELECT 
    categoria_prodotto,
    mese_transazione,
    totale_guadagno_mensile,
    LAG(totale_guadagno_mensile) 
    OVER (PARTITION BY categoria_prodotto ORDER BY mese_transazione) 
    AS guadagno_mensile_precedente,
    totale_guadagno_mensile - LAG(totale_guadagno_mensile) 
    OVER (PARTITION BY categoria_prodotto ORDER BY mese_transazione) 
    AS incremento
FROM VenditeMensili2;

--- mi è venuto il dubbio che forse avrei dovuto vedere incremento e decremento totale non per categoria prodotto
CREATE VIEW VenditeMensiliTotali AS
SELECT 
    DATE_FORMAT(dv.data_transazione,'%M-%y') AS mese_transazione,
    SUM(v.costo_vendita) AS totale_guadagno_mensile
FROM vendite2 v
JOIN dettagli_vendite2 dv ON v.id_transazione = dv.id_transazione
GROUP BY mese_transazione;


SELECT 
    mese_transazione,
    totale_guadagno_mensile,
    LAG(totale_guadagno_mensile) OVER (ORDER BY mese_transazione) AS guadagno_mensile_precedente,
    totale_guadagno_mensile - LAG(totale_guadagno_mensile) OVER (ORDER BY mese_transazione) AS incremento
FROM VenditeMensiliTotali;

--- faccio prima il punto dieci che è più lungo ma meno complesso
--- Supponendo di avere una tabella clienti con i campi IDCliente e IDVendita,  scrivi una query per trovare i top 5 clienti con il maggior numero di acquisti. 
--- creo per prima cosa la tabella clienti
Create table clienti (
id_clienti varchar(55),
id_vendita int primary key);

INSERT INTO clienti (id_clienti, id_vendita) VALUES
('cliente1', 5),
('cliente2', 12),
('cliente3', 8),
('cliente4', 1),
('cliente5', 15),
('cliente6', 3),
('cliente7', 10),
('cliente8', 6),
('cliente9', 19),
('cliente10', 2),
('cliente1', 4),
('cliente1', 11),
('cliente6', 20),
('cliente6', 21),
('cliente6', 22),
('cliente6', 23),
('cliente4', 24),
('cliente4', 25),
('cliente4', 26),
('cliente8', 27),
('cliente8', 28),
('cliente8', 29);

- - - top 5

SELECT id_clienti, COUNT(id_vendita) AS numero_acquisti
FROM clienti
GROUP BY id_clienti
ORDER BY numero_acquisti DESC
LIMIT 5;

--- vendite stagionali: ho dovuto fare un sacco di ricerche e tentativi per questo punto. Sono sicura esista un modo più semplice per risolverlo ma non riesco a capire quale. 
--- Ho creato una vista dove ho utilizzato 'case' una sorta di 'if condition' come avrei fatto con python così da raggruppare le vendite su base stagionale. 

CREATE VIEW VenditeStagionali AS
SELECT 
    CASE 
        WHEN MONTH(dv.data_transazione) IN (3, 4, 5) THEN 'Primavera'
        WHEN MONTH(dv.data_transazione) IN (6, 7, 8) THEN 'Estate'
        WHEN MONTH(dv.data_transazione) IN (9, 10, 11) THEN 'Autunno'
        ELSE 'Inverno'
    END AS stagione,
    SUM(v.costo_vendita) AS totale_guadagno_stagionale
FROM vendite2 v
JOIN dettagli_vendite2 dv ON v.id_transazione = dv.id_transazione
GROUP BY stagione;

--- fatto questo con lo stesso procedimento di prima utilizzo 'lag' per l incremento e decremento
SELECT 
    stagione,
    totale_guadagno_stagionale,
    LAG(totale_guadagno_stagionale) OVER (ORDER BY stagione) AS guadagno_stagionale_precedente,
    totale_guadagno_stagionale - LAG(totale_guadagno_stagionale) OVER (ORDER BY stagione) AS incremento
FROM VenditeStagionali;
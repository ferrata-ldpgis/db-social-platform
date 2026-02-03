-- Seleziona tutti gli utenti e calcolane l'età (25)
SELECT *, AGE(birthdate) as eta FROM users;
--25

--Seleziona tutti i post senza Like (13)
SELECT * FROM posts WHERE id NOT IN (
    SELECT post_id FROM likes
);
--13

--Conta il numero di like per ogni post (165)
SELECT
    p.id,
    p.title,
    COUNT(l.post_id) AS likes_count
FROM posts p
LEFT JOIN likes l ON l.post_id = p.id
GROUP BY p.id, p.title;
--165

--Ordina gli utenti per il numero di media caricati (25)
SELECT COUNT(*) as count_media,m.user_id,u.username,u.email
FROM users as u
JOIN medias as m ON m.user_id = u.id
GROUP BY m.user_id,u.username,u.email ORDER BY m.user_id DESC;


--Ordina gli utenti per totale di likes ricevuti nei loro posts (25)
SELECT
    u.id,
    u.username,
    COUNT(l.user_id) AS total_likes_received
FROM users u
JOIN posts p ON p.user_id = u.id
JOIN likes l ON l.post_id = p.id
GROUP BY u.id, u.username
ORDER BY total_likes_received DESC;
--25

--Seleziona tutti i post degli utenti tra i 20 e i 30 anni (49)
SELECT p.*, EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.birthdate)) as eta
FROM posts p
JOIN users u ON u.id = p.user_id
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.birthdate)) >= 20 AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.birthdate))<=30;
--24 ???

SELECT
    p.*,
    DATE_PART('year', AGE(u.birthdate)) AS eta
FROM posts p
JOIN users u ON u.id = p.user_id
WHERE u.birthdate BETWEEN
      CURRENT_DATE - INTERVAL '30 years'
  AND CURRENT_DATE - INTERVAL '20 years';
--10

--Seleziona il numero di post e di media per ogni utente (25)
SELECT COUNT(*), AVG(COUNT(*)) OVER () AS avg_posts_per_user, p.user_id
FROM posts as p
GROUP BY p.user_id;

--Seleziona tutti i post che contengono il tag 'serata' (8)
SELECT *
FROM posts
WHERE tags::jsonb ? 'serata';

--Ordina i post in base al numero di tag (165)
SELECT
    p.*,
    json_array_length(p.tags) AS num_tags
FROM posts p
ORDER BY json_array_length(p.tags) DESC;
--165

--Ordina gli utenti in base al numero di tag usati nei loro post (25)
SELECT
    u.id,
    u.username,
    COALESCE(SUM(json_array_length(p.tags)), 0) AS total_tags
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
GROUP BY u.id, u.username
ORDER BY total_tags DESC;
--25


--VIEW
--Lista dei media di tipo immagine, di cui visualizzare solo il path e la mail dell'utente collegato, in lowercase. Il caso d'uso saranno query per recuperare una lista di path a partire da una mail.
--cambio tipologia colonna email di users
ALTER TABLE users
ALTER COLUMN email TYPE CITEXT
USING email::citext;


--creare indice su lower case
CREATE INDEX idx_users_email_lower ON users (LOWER(email));

--creazione dell'indice
CREATE INDEX idx_users_username ON public.users USING btree (username);


SELECT COUNT(*)
FROM medias as m
WHERE m.type ='photo';
--663

SELECT u.username,u.email,m.path
FROM medias as m
JOIN users as u ON u.id=m.user_id
WHERE m.type ='photo';
--663

--creazione della vista
CREATE view v_medias_img AS
SELECT u.username,lower(u.email::citext) AS email,m.path
FROM medias as m
JOIN users as u ON u.id=m.user_id
WHERE m.type ='photo';


--controllo
EXPLAIN ANALYZE
SELECT path FROM v_medias_img WHERE email ='mario.rossi@example.com';


--creazione della vista materializzata
CREATE MATERIALIZED view mv_medias_img AS
SELECT u.username,lower(u.email::text) AS email,m.path
FROM medias as m
JOIN users as u ON u.id=m.user_id
WHERE m.type ='photo';

--creazione degli indici
CREATE INDEX idx_mv_users_username ON public.mv_medias_img USING btree (username);
CREATE INDEX idx_mv_users_email ON public.mv_medias_img USING btree (email);

--controllo
EXPLAIN ANALYZE
SELECT path FROM mv_medias_img WHERE email ='mario.rossi@example.com';

--Tutti i media e tag relativi al post associato. La query tipica sarà recuperare i vari record collegati a una user-id.
--vista
CREATE view v_medias_tags AS
SELECT p.title,p.tags::jsonb, u.username, u.email, u.id as user_id
FROM medias as m
JOIN posts as p ON m.user_id = p.user_id
JOIN users as u ON m.user_id = u.id
GROUP BY p.title,p.tags::jsonb,u.username, u.email, u.id
ORDER BY u.id;

--creare indice title
CREATE INDEX idx_posts_title ON posts (title);

EXPLAIN ANALYZE
SELECT * FROM v_medias_tags
WHERE user_id=1;


--vista materializzata
CREATE MATERIALIZED view mv_medias_tags AS
SELECT p.title,p.tags::jsonb, u.username, u.email, u.id as user_id
FROM medias as m
JOIN posts as p ON m.user_id = p.user_id
JOIN users as u ON m.user_id = u.id
GROUP BY p.title,p.tags::jsonb,u.username, u.email, u.id
ORDER BY u.id;


--creazione degli indici
CREATE INDEX idx_mv_medias_tags_posts_title ON public.mv_medias_tags USING btree (title);
CREATE INDEX idx_mv_medias_tags_posts_tags ON public.mv_medias_tags USING GIN (tags);
CREATE INDEX idx_mv_medias_tags_users_username ON public.mv_medias_tags USING btree (username);
CREATE INDEX idx_mv_medias_tags_users_email ON public.mv_medias_tags USING btree (email);
CREATE INDEX idx_mv_medias_tags_users_id ON public.mv_medias_tags USING btree (user_id);


EXPLAIN ANALYZE
SELECT * FROM mv_medias_tags
WHERE user_id=1;


--JSON
--Recuperare tutti i media che hanno il tag X.
SELECT * FROM posts WHERE tags::jsonb @> '"cena"';

--Convertire i campi JSON esistenti in JSONB.
ALTER TABLE posts
ALTER COLUMN tags TYPE jsonb
USING tags::jsonb;

--Recuperare tutti i media che hanno il tag X.
SELECT * FROM posts WHERE tags @> '"cena"';

--Ragionare sull’indice.
CREATE INDEX idx_tags_path
ON posts USING GIN(tags jsonb_path_ops);

--Recuperare tutti i media che hanno il tag X.
EXPLAIN ANALYZE
SELECT * FROM posts WHERE tags @> '["cena"]';


--BONUS: creare una vista che esploda gli array riportando una row per ogni tag esistente, senza duplicati. Una soluzione può essere con lateral e distinct.
SELECT DISTINCT jsonb_array_elements_text(tags) AS tag
FROM posts
ORDER BY jsonb_array_elements_text(tags);

SELECT DISTINCT title,jsonb_array_elements_text(tags)
FROM posts p
CROSS JOIN LATERAL jsonb_array_elements_text(tags) AS tag
ORDER BY jsonb_array_elements_text(tags);


--Aggiungere nuovo campo JSONB oggetto (meta dei post o preferenze degli utenti).
ALTER TABLE users
ADD COLUMN info jsonb DEFAULT '{}'::jsonb;

--Ragionare sull’indice.
CREATE INDEX idx_users_info_gin
ON users
USING GIN (info);


--Popolare la tabella manualmente (o generando dati casuali random/md5 e iterando con generate_series).
--Se info non contiene nulla:
UPDATE users
SET info = '{"darkMode": true}'::jsonb
WHERE id = 1;

--Se info contiene già altri dati:
UPDATE users
SET info = info || '{"darkMode": true}'::jsonb
WHERE id = 1;

--query
SELECT *
FROM users
WHERE info ->> 'darkMode' = 'true';

SELECT *
FROM users
WHERE info @> '{"darkMode": true}';


UPDATE users
SET info = jsonb_set(info, '{darkMode}', 'true'::jsonb)
WHERE id = 5;


--Creare vista che mostra l’elenco degli utenti con darkMode: true.
CREATE VIEW v_users_darkmode AS
SELECT id, username, email, info
FROM users
WHERE info @> '{"darkMode": true}';

--
EXPLAIN ANALYZE
SELECT * FROM v_users_darkmode;

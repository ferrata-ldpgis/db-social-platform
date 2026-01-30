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

--Ordina gli utenti in base al numero di tag usati nei loro post (25)
SELECT
    u.id,
    u.username,
    COALESCE(SUM(json_array_length(p.tags)), 0) AS total_tags
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
GROUP BY u.id, u.username
ORDER BY total_tags DESC;

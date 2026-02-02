--Correzioni db:


--Tabella media_post
--controllo orfani
SELECT post_id FROM media_post WHERE post_id NOT IN (
	SELECT id FROM posts
);
--elimino gli orfani
DELETE  FROM media_post WHERE post_id NOT IN (
	SELECT id FROM posts
);

--quindi creazione della foreign key:
ALTER TABLE media_post
ADD CONSTRAINT media_post_ibfk_3
FOREIGN KEY (post_id)
REFERENCES posts(id)
ON UPDATE CASCADE
ON DELETE CASCADE;


--Tabella likes
--controllo orfani
SELECT post_id FROM likes WHERE post_id NOT IN (
	SELECT id FROM posts
);
--elimino gli orfani
DELETE  FROM likes WHERE post_id NOT IN (
	SELECT id FROM posts
);

--quindi creazione della foreign key:
ALTER TABLE likes
ADD CONSTRAINT likes_ibfk_3
FOREIGN KEY (post_id)
REFERENCES posts(id)
ON UPDATE CASCADE
ON DELETE CASCADE;


--INDICI

CREATE INDEX idx_likes_user_id ON public.likes USING btree (user_id);
CREATE INDEX idx_medias_user_id ON public.medias USING btree (user_id);
CREATE INDEX fki_medias_media_ibfk_2 ON public.media_post USING btree (media_id);
CREATE INDEX fki_medias_post_ibfk_3 ON public.media_post USING btree (post_id);

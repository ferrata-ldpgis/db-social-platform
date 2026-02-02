--
-- PostgreSQL database dump
--

\restrict 5sqBro1WyhuwgfyiXMdVZZrYA0ZbUaOMhmB2Kos7Ip2P1fiXQ1CmkVlVKhBgmer

-- Dumped from database version 17.7 (Ubuntu 17.7-3.pgdg24.04+1)
-- Dumped by pg_dump version 18.1 (Ubuntu 18.1-1.pgdg24.04+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.likes (
    post_id integer,
    user_id integer,
    date timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    trial572 character(1)
);


--
-- Name: media_post; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_post (
    post_id integer,
    media_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    trial572 character(1)
);


--
-- Name: medias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medias (
    id integer NOT NULL,
    user_id integer,
    type character varying(5),
    path character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    trial572 character(1)
);


--
-- Name: medias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medias_id_seq OWNED BY public.medias.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    user_id integer,
    title character varying(255),
    date timestamp without time zone,
    tags json,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    trial572 character(1)
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255),
    email character varying(255),
    password character varying(255),
    birthdate date,
    phone character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    trial572 character(1)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: medias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medias ALTER COLUMN id SET DEFAULT nextval('public.medias_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: medias pk_medias; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medias
    ADD CONSTRAINT pk_medias PRIMARY KEY (id);


--
-- Name: posts pk_posts; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT pk_posts PRIMARY KEY (id);


--
-- Name: users pk_users; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: fki_media_media_ibfk_2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_media_media_ibfk_2 ON public.media_post USING btree (media_id);


--
-- Name: fki_media_post_ibfk_3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_media_post_ibfk_3 ON public.media_post USING btree (post_id);


--
-- Name: idx_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_email ON public.users USING btree (email);


--
-- Name: idx_likes_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_likes_user_id ON public.likes USING btree (user_id);


--
-- Name: idx_medias_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_medias_user_id ON public.medias USING btree (user_id);


--
-- Name: idx_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_phone ON public.users USING btree (phone);


--
-- Name: idx_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_post_id ON public.likes USING btree (post_id);


--
-- Name: idx_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_id ON public.posts USING btree (user_id);


--
-- Name: likes likes_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_ibfk_2 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: likes likes_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_ibfk_3 FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: media_post media_post_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_post
    ADD CONSTRAINT media_post_ibfk_2 FOREIGN KEY (media_id) REFERENCES public.medias(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: media_post media_post_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_post
    ADD CONSTRAINT media_post_ibfk_3 FOREIGN KEY (post_id) REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: medias medias_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medias
    ADD CONSTRAINT medias_ibfk_1 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: posts posts_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_ibfk_1 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 5sqBro1WyhuwgfyiXMdVZZrYA0ZbUaOMhmB2Kos7Ip2P1fiXQ1CmkVlVKhBgmer


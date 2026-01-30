CREATE TABLE "user"(
    "id" BIGINT NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "surname" VARCHAR(50) NOT NULL,
    "nick_name" VARCHAR(50) NOT NULL,
    "email" VARCHAR(50) NOT NULL,
    "ts_create" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
CREATE INDEX "user_nick_name_index" ON
    "user"("nick_name");
ALTER TABLE
    "user" ADD PRIMARY KEY("id");
ALTER TABLE
    "user" ADD CONSTRAINT "user_nick_name_unique" UNIQUE("nick_name");
ALTER TABLE
    "user" ADD CONSTRAINT "user_email_unique" UNIQUE("email");
CREATE TABLE "filerepository"(
    "id" BIGINT NOT NULL,
    "post_id" BIGINT NOT NULL,
    "filename_orig" VARCHAR(255) NOT NULL,
    "filename" VARCHAR(255) NOT NULL,
    "size" INTEGER NOT NULL,
    "mimetype" VARCHAR(30) NOT NULL,
    "ts" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "filerepository" ADD PRIMARY KEY("id");
ALTER TABLE
    "filerepository" ADD CONSTRAINT "filerepository_filename_orig_unique" UNIQUE("filename_orig");
CREATE TABLE "post"(
    "id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "label" VARCHAR(25000) NOT NULL,
    "ts_crate" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "ts_update" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "post" ADD PRIMARY KEY("id");
CREATE TABLE "likes2posts"(
    "id" BIGINT NOT NULL,
    "post_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "ts_created" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "ts_updated" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "likes2posts" ADD PRIMARY KEY("id");
ALTER TABLE
    "likes2posts" ADD CONSTRAINT "likes2posts_post_id_foreign" FOREIGN KEY("post_id") REFERENCES "post"("id");
ALTER TABLE
    "filerepository" ADD CONSTRAINT "filerepository_post_id_foreign" FOREIGN KEY("post_id") REFERENCES "post"("id");
ALTER TABLE
    "likes2posts" ADD CONSTRAINT "likes2posts_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "user"("id");
ALTER TABLE
    "user" ADD CONSTRAINT "user_name_foreign" FOREIGN KEY("name") REFERENCES "post"("user_id");
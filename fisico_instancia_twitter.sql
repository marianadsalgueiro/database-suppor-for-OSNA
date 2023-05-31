DROP TYPE IF EXISTS References_Type CASCADE;
CREATE TYPE References_Type AS ENUM (
    'Retweet',
    'Reply',
    'Quote'
);

DROP TYPE IF EXISTS Media_Type CASCADE;
CREATE TYPE Media_Type AS ENUM (
    'Video',
    'Image',
    'GIF'
);

DROP TABLE IF EXISTS Hashtag;
CREATE TABLE Hashtag (
    hashtag_PK INT NOT NULL PRIMARY KEY,
    hashtag TEXT
);

DROP TABLE IF EXISTS Account;
CREATE TABLE Account (
    URL TEXT,
    verified BOOLEAN,
    name TEXT,
    picture TEXT,
    id TEXT PRIMARY KEY,
    bio TEXT,
    location TEXT,
    account_name TEXT,
    fk_pinned_tweet_id TEXT,
    followers int,
    following int,
    created_at timestamp,
    fk_Annotation_PK INT
);

DROP TABLE IF EXISTS Tweet;
CREATE TABLE Tweet (
    possibly_sensitive BOOLEAN,
    URL TEXT,
    id TEXT PRIMARY KEY,
    fk_hashtag_PK INT,
    reply_settings TEXT,
    source TEXT,
    language TEXT,
    view_count INT,
    fk_Account_id TEXT,
    timestamp TIMESTAMP,
    like_count INT,
    quote_count INT,
    reply_count INT,
    retweet_count INT,
    text TEXT,
    fk_Media_id TEXT,
    fk_Annotation_PK INT
);

   
DROP TABLE IF EXISTS Annotation;
CREATE TABLE Annotation (
    annotation_PK INT NOT NULL PRIMARY KEY,
    annotation TEXT
);

ALTER TABLE Account ADD CONSTRAINT FK_Account_2
    FOREIGN KEY (fk_pinned_tweet_id)
    REFERENCES Tweet (id)
    ON DELETE CASCADE;
   
ALTER TABLE Account ADD CONSTRAINT FK_Account_3
    FOREIGN KEY (fk_Annotation_PK)
    REFERENCES annotation (annotation_PK);

DROP TABLE IF EXISTS Media;
CREATE TABLE Media (
    id TEXT PRIMARY KEY,
    type Media_Type,
    URL TEXT,
    alt_text TEXT,
    duration_ms INT
);  

ALTER TABLE Tweet ADD CONSTRAINT FK_Tweet_2
    FOREIGN KEY (fk_hashtag_PK)
    REFERENCES Hashtag (hashtag_PK)
    ON DELETE NO ACTION;
 
ALTER TABLE Tweet ADD CONSTRAINT FK_Tweet_3
    FOREIGN KEY (fk_Account_id)
    REFERENCES Account (id)
    ON DELETE CASCADE;
 
ALTER TABLE Tweet ADD CONSTRAINT FK_Tweet_4
    FOREIGN KEY (fk_Media_id)
    REFERENCES media (id);
 
ALTER TABLE Tweet ADD CONSTRAINT FK_Tweet_5
    FOREIGN KEY (fk_Annotation_PK)
    REFERENCES annotation (annotation_PK);

DROP TABLE IF EXISTS References_Table;
CREATE TABLE References_Table (
    references_tweet TEXT,
    referenced_tweet TEXT,
    type References_Type
);

ALTER TABLE References_Table ADD CONSTRAINT FK_References_1
    FOREIGN KEY (references_tweet)
    REFERENCES Tweet (id)
    ON DELETE CASCADE;
 
ALTER TABLE References_Table ADD CONSTRAINT FK_References_2
    FOREIGN KEY (referenced_tweet)
    REFERENCES Tweet (id)
    ON DELETE CASCADE;

DROP TABLE IF EXISTS Follows;
CREATE TABLE Follows (
    fk_Account_id TEXT,
    fk_Account_id_ TEXT
);

ALTER TABLE Follows ADD CONSTRAINT FK_Follows_1
    FOREIGN KEY (fk_Account_id)
    REFERENCES Account (id)
    ON DELETE CASCADE;
 
ALTER TABLE Follows ADD CONSTRAINT FK_Follows_2
    FOREIGN KEY (fk_Account_id_)
    REFERENCES Account (id)
    ON DELETE CASCADE;

DROP TABLE IF EXISTS Belongs_To_Timeline;
CREATE TABLE Belongs_To_Timeline (
    fk_Account_id TEXT,
    fk_Tweet_id TEXT
);

ALTER TABLE Belongs_To_Timeline ADD CONSTRAINT FK_Belongs_To_Timeline_1
    FOREIGN KEY (fk_Account_id)
    REFERENCES Account (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Belongs_To_Timeline ADD CONSTRAINT FK_Belongs_To_Timeline_2
    FOREIGN KEY (fk_Tweet_id)
    REFERENCES Tweet (id)
    ON DELETE SET NULL;

DROP TABLE IF EXISTS Mentions;
CREATE TABLE Mentions (
    fk_Account_id TEXT,
    fk_Tweet_id TEXT
);

ALTER TABLE Mentions ADD CONSTRAINT FK_Mentions_1
    FOREIGN KEY (fk_Account_id)
    REFERENCES Account (id)
    ON DELETE SET NULL;
 
ALTER TABLE Mentions ADD CONSTRAINT FK_Mentions_2
    FOREIGN KEY (fk_Tweet_id)
    REFERENCES Tweet (id)
    ON DELETE SET NULL;

DROP TABLE IF EXISTS Likes;
CREATE TABLE Likes (
    fk_Tweet_id TEXT,
    fk_Account_id TEXT
);

ALTER TABLE Likes ADD CONSTRAINT FK_Likes_1
    FOREIGN KEY (fk_Tweet_id)
    REFERENCES Tweet (id)
    ON DELETE SET NULL;
 
ALTER TABLE Likes ADD CONSTRAINT FK_Likes_2
    FOREIGN KEY (fk_Account_id)
    REFERENCES Account (id)
    ON DELETE SET NULL;
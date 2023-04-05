PRAGMA foreign_keys=ON;

DROP TABLE IF EXISTS users; 
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL, 
    lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions; 
CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows; 
CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    reply_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL, 
    FOREIGN KEY (question_id) REFERENCES questions(id), 
    FOREIGN KEY (reply_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Arthur', 'Miller'),
  ('Bob', 'Barley'),
  ('Rokas', 'Jeriomenkos'),
  ('KYLE', 'GINZBURG'),
  ('Eugene', 'Neil');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Meaning of Life', 'What is the meaning of life?', 
    (SELECT id FROM users WHERE fname = 'Arthur' AND lname = 'Miller')),
    ('Rokas personality', 'How tall do you think I am?',
    (SELECT id FROM users WHERE fname = 'Rokas' AND lname = 'Jeriomenkos'));

INSERT INTO
    question_follows(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Bob' AND lname = 'Barley'),
    (SELECT id FROM questions WHERE title = 'Rokas personality'))

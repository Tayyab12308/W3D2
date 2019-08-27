DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL

);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_id INTEGER NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Jared', 'Cazel'),
  ('Tayyab', 'Iqbal'),
  ('Ronald', 'Mcdonald');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('How do I?', 'Write SQL queries', (SELECT id FROM users WHERE fname = 'Ronald')),
  ('How do I?', 'Complete this assignment', (SELECT id FROM users WHERE fname = 'Jared')),
  ('How do I?', 'get a job', (SELECT id from users WHERE lname = 'Iqbal'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = 'Cazel'), (SELECT id FROM users WHERE fname = 'Ronald')),
  ((SELECT id FROM users WHERE fname = 'Ronald'), (SELECT id FROM users WHERE fname = 'Tayyab')),
  ((SELECT id FROM users WHERE fname = 'Tayyab'), (SELECT id FROM users WHERE fname = 'Jared'));

INSERT INTO 
  replies(body, question_id, user_id, parent_id)
VALUES
  ('Get through App Academy', (SELECT id FROM questions WHERE body = 'get a job'), (SELECT user_id FROM questions WHERE body = 'get a job'), NULL ),
  ('Do your homework', (SELECT id FROM questions WHERE body = 'Write SQL queries'), (SELECT user_id FROM questions WHERE body = 'Write SQL queries'), NULL ),
  ('Ask TA for help', (SELECT id FROM questions WHERE body = 'Complete this assignment'), (SELECT user_id FROM questions WHERE body = 'Complete this assignment'), NULL );

INSERT INTO 
  replies(body, question_id, user_id, parent_id)
VALUES
  ('Apply to jobs', (SELECT id FROM questions WHERE body = 'get a job'), (SELECT user_id FROM questions WHERE body = 'get a job'), (SELECT id FROM replies WHERE body = 'Get through App Academy')),
  ('Pay attention in lecture', (SELECT id FROM questions WHERE body = 'Write SQL queries'), (SELECT user_id FROM questions WHERE body = 'Write SQL queries'), (SELECT id FROM replies WHERE body = 'Do your homework')),
  ('Watch videos', (SELECT id FROM questions WHERE body = 'Complete this assignment'), (SELECT user_id FROM questions WHERE body = 'Complete this assignment'), (SELECT id FROM replies WHERE body = 'Ask TA for help'));

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = 'Cazel'), (SELECT id FROM questions WHERE body = 'Write SQL queries')),
  ((SELECT id FROM users WHERE fname = 'Ronald'), (SELECT id FROM questions WHERE body = 'Write SQL queries')),
  ((SELECT id FROM users WHERE fname = 'Tayyab'), (SELECT id FROM questions WHERE body = 'Write SQL queries')),
  
  ((SELECT id FROM users WHERE lname = 'Cazel'), (SELECT id FROM questions WHERE body = 'Complete this assignment')),
  ((SELECT id FROM users WHERE fname = 'Ronald'), (SELECT id FROM questions WHERE body = 'Complete this assignment')),
  ((SELECT id FROM users WHERE fname = 'Tayyab'), (SELECT id FROM questions WHERE body = 'Complete this assignment')),
    
  ((SELECT id FROM users WHERE lname = 'Cazel'), (SELECT id FROM questions WHERE body = 'get a job')),
  ((SELECT id FROM users WHERE fname = 'Ronald'), (SELECT id FROM questions WHERE body = 'get a job')),
  ((SELECT id FROM users WHERE fname = 'Tayyab'), (SELECT id FROM questions WHERE body = 'get a job'));
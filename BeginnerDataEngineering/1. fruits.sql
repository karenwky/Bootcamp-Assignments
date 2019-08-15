DROP DATABASE IF EXISTS fruits; 

CREATE DATABASE fruits; 
USE fruits; 

CREATE TABLE fruit (
  id int AUTO_INCREMENT, 
  name varchar(255), 
  color varchar(255), 
  taste varchar(255), 
  PRIMARY KEY (id)
); 

CREATE TABLE stock (
  id int PRIMARY KEY, 
  fruit_id int NOT NULL, 
  description varchar(255), 
  quantity int, 
  price float, 
  FOREIGN KEY (fruit_id) REFERENCES fruit(id)
); 

INSERT INTO fruit (name, color, taste) VALUES ('lemon', 'yellow', 'sour'); 
INSERT INTO fruit (name, color, taste) VALUES ('orange', 'orange', 'juicy'); 
INSERT INTO fruit (name, color, taste) VALUES ('grapefruit', 'orange', 'bitter'); 
INSERT INTO fruit (name, color, taste) VALUES ('lime', 'green', 'sour'); 
INSERT INTO fruit (name, color, taste) VALUES ('tangerine', 'yellow', 'sweet'); 

/* 1. Use the update command to change the colour of orange fruit to yellow. */
UPDATE fruit
SET color = 'yellow'
WHERE name = 'orange'; 

/* 2. Delete tangerine from the fruit table. */
DELETE FROM fruit
WHERE name = 'tangerine'; 

/* 3. Select all fruit from the table. */
SELECT *
FROM fruit; 

/* 4. Select all fruit where the colour is orange or green. */
SELECT *
FROM fruit
WHERE color = 'orange' OR color = 'green'; 

/* 5. Delete the fruit (and dependent) tables. */
ALTER TABLE stock DROP FOREIGN KEY stock_ibfk_1; 
DROP TABLE fruit; 
DROP TABLE stock; 

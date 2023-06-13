CREATE DATABASE library;
USE library;

CREATE TABLE books(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
author VARCHAR(255) NOT NULL,
PRIMARY KEY(id)
);

INSERT INTO books(name, author)
VALUES('Icebreaker','Hannah Grace'),
('A court of thorns and roses','Sarah J.Maas'),
('Bittersweet','Morgan Elizabeth'),
('Tis the season for revenge','Morgan Elizabeth'),
('Last on the list','Amy Daws'),
('Liberte','Gita Trelease'),
('The book thief','Markus Zusak'),
('The ballad of songbirds and snakes','Suzanne Collins'),
('Heartstopper','Alice Oseman'),
('The Maze Runner','James Dashner'),
('Coraline','Nail Gaiman'),
('The night circus','Erin Morgenstern'),
('The hobbit','J.R.R Tolkien'),
('Wuthering heights','Emily Bronte'),
('Frankenstein','Mary Shelley');

SELECT * FROM books;

CREATE TABLE customer(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
contact VARCHAR(11),
PRIMARY KEY(id)
);

INSERT INTO customer(name, contact)
VALUES('Jane Doe','07567345765'),
('John Doe','07982315678'),
('Liam Parsons','07856456345'),
('Lisa Turner','07654217880'),
('Bethany Turner','07899654567'),
('Bilbo Baggins','07543256745'),
('Samwise Gamgee','07898760561'),
('Luke Skywalker','07123412313'),
('Leila Oragna','07986753422'),
('Han Solo','07899673421'),
('Ash Ketchum','07556432876');

SELECT * FROM customer;

CREATE TABLE borrowed(
id INT NOT NULL AUTO_INCREMENT,
book_id INT NOT NULL,
date_borrowed DATE,
date_returned DATE,
customer_id INT NOT NULL,
PRIMARY KEY(id),
FOREIGN KEY (customer_id) REFERENCES customer(id),
FOREIGN KEY (book_id) REFERENCES books(id)
);

SET FOREIGN_KEY_CHECKS=1;

INSERT INTO borrowed(id, date_borrowed, date_returned, book_id, customer_id)
VALUES(1,'2023-01-23','2023-02-07',1,11),
(2,'2023-03-11',NULL,2,10),
(3,'2022-11-14','2022-11-29',3,9),
(4,'2023-04-01',NULL,4,8),
(5,'2022-12-29','2023-01-17',5,7),
(6,'2023-02-08','2023-03-22',6,7),
(7,'2022-01-28',NULL,7,5),
(8,'2023-02-16','2023-04-27',9,1),
(9,'2020-07-14','2020-09-11',8,4),
(10,'2021-12-12','2022-03-26',9,3),
(11,'2023-05-28',NULL,13,3),
(12,'2019-09-13',NULL,10,2),
(13,'2022-10-20','2023-06-01',11,1),
(14,'2018-01-14','2018-05-23',12,3),
(15,'2018-09-11','2019-03-01',13,4),
(16,'2022-07-08','2022-09-23',14,2),
(17,'2019-09-06','2020-06-01',15,11);

-- List books by most borrowed
SELECT books.name AS 'Most borrowed', COUNT(book_id) AS 'Amount'
FROM borrowed
JOIN books ON borrowed.book_id = books.id
GROUP BY book_id
ORDER BY COUNT(book_id) DESC;

-- Books that have not been returned
SELECT books.name AS 'Book', books.author AS 'Author' 
FROM borrowed
JOIN books ON borrowed.book_id = books.id
WHERE borrowed.date_returned IS NULL;

-- Books borrowed in 2022
SELECT borrowed.date_borrowed AS 'Date borrowed', books.name AS 'Book name'
FROM borrowed
JOIN books ON borrowed.book_id = books.id
WHERE date_borrowed > '2021-12-31' AND date_borrowed < '2023-01-01';

-- Books borrowed in 2022 using year function
SELECT borrowed.date_borrowed AS 'Date borrowed', books.name AS 'Book name'
FROM borrowed
JOIN books ON borrowed.book_id = books.id
WHERE YEAR(date_borrowed) = 2022;

-- Books Liam Parsons has read
SELECT customer.name AS 'Customer', books.name AS 'Book'
FROM borrowed
JOIN books ON borrowed.book_id = books.id
JOIN customer ON borrowed.customer_id = customer.id
WHERE customer.name = 'Liam Parsons';

-- Books Samwise Gamgee has not borrowed
SELECT DISTINCT books.name AS 'Book'
FROM borrowed
JOIN books ON borrowed.book_id = books.id
JOIN customer ON borrowed.customer_id = customer.id
WHERE customer.name != 'Samwise Gamgee';

-- Correct spelling mistake
UPDATE customer
SET name = 'Leila Organa'
WHERE id = 9;

-- First book borrowed
SELECT MIN(borrowed.date_borrowed) AS 'Date borrowed', books.name AS 'Name'
FROM borrowed
JOIN books ON borrowed.book_id = books.id;

-- Last book returned
SELECT MAX(borrowed.date_returned) AS 'Date returned', books.name As 'Name'
FROM borrowed
JOIN books ON borrowed.book_id = books.id;

-- List all customers and the books they have borrowed, alaphbetical order
SELECT customer.name AS 'Customer', books.name AS 'Book'
FROM borrowed
JOIN books ON borrowed.book_id = books.id
JOIN customer ON borrowed.customer_id = customer.id
ORDER BY 1;

-- Are The Maze Runner and Liberte availble for Leila to borrow
SELECT books.name AS 'Book', borrowed.date_borrowed, borrowed.date_returned
FROM borrowed
JOIN books ON borrowed.book_id = books.id
WHERE books.name IN ('The Maze Runner', 'Liberte');

-- Who stole The Maze Runner
SELECT books.name AS 'Book', customer.name AS 'Name', borrowed.date_borrowed AS 'Date borrowed', borrowed.date_returned AS 'Date returned'
FROM borrowed
JOIN books ON borrowed.book_id = books.id
JOIN customer ON borrowed.customer_id = customer.id
WHERE books.name = 'The Maze Runner'
AND borrowed.date_returned IS NULL;
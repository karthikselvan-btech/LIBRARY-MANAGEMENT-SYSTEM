create database if not exists Library_Management_System;
use Library_Management_System;

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Genre VARCHAR(50),
    PublicationYear INT,
    Quantity INT DEFAULT 1
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15),
    JoinDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    BorrowDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ReturnDate DATE,
    Status ENUM('Borrowed', 'Returned') DEFAULT 'Borrowed',
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- 1. Insert Data

-- Insert into Books:
INSERT INTO Books (Title, Author, Genre, PublicationYear, Quantity) 
VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 5),
('1984', 'George Orwell', 'Dystopian', 1949, 3),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 4);

-- Insert into Members:
INSERT INTO Members (FirstName, LastName, Email, PhoneNumber) 
VALUES 
('Karthik', 'Selvan', 'karthik.selvan@example.com', '1234567890'),
('Vimalan', 'Selvam', 'vimalan.selvam@example.com', '0987654321');

-- Insert into Transactions:
INSERT INTO Transactions (MemberID, BookID, BorrowDate) 
VALUES 
(1, 1, '2024-12-01'),
(2, 2, '2024-12-05');

-- ---------------------------------------------------------------------------------------------------
-- 2. Join Queries

-- 2.1. INNER JOIN
-- An INNER JOIN returns only the rows where there is a match between the two tables.

SELECT 
    Members.FirstName, 
    Members.LastName, 
    Books.Title, 
    Transactions.BorrowDate
FROM 
    Transactions
INNER JOIN Members ON Transactions.MemberID = Members.MemberID
INNER JOIN Books ON Transactions.BookID = Books.BookID;

-- Explanation: This query retrieves the first name, last name of the members, 
-- the title of the books they borrowed, and the borrow date, 
-- but only for members who have borrowed books (transactions).

-- ------------------------------------------------------------------------------------------------------

-- 2.2. LEFT JOIN

-- A LEFT JOIN returns all records from the left table (Transactions), and 
-- the matched records from the right table (Members and Books). 
-- If there is no match, NULL values will be returned for columns from the right table.

SELECT 
    Members.FirstName, 
    Members.LastName, 
    Books.Title, 
    Transactions.BorrowDate
FROM 
    Transactions
LEFT JOIN Members ON Transactions.MemberID = Members.MemberID
LEFT JOIN Books ON Transactions.BookID = Books.BookID;

-- Explanation: This query will return all transactions, 
-- including those where a member or book is not available, 
-- but with NULL values in the columns for missing data.

-- -----------------------------------------------------------------------------------------------------

-- 2.3. RIGHT JOIN

-- A RIGHT JOIN returns all records from the right table (Members and Books), 
-- and the matched records from the left table (Transactions). 
-- If there is no match, NULL values will be returned for columns from the left table.

SELECT 
    Members.FirstName, 
    Members.LastName, 
    Books.Title, 
    Transactions.BorrowDate
FROM 
    Transactions
RIGHT JOIN Members ON Transactions.MemberID = Members.MemberID
RIGHT JOIN Books ON Transactions.BookID = Books.BookID;

-- Explanation: This query returns all members and books, including those without any transactions. 
-- If there is no corresponding transaction, NULL values will be shown for the BorrowDate column.

-- --------------------------------------------------------------------------------------------------------------

-- 2.4. FULL JOIN

-- Retrieve all members and all books, including those without any associated transactions.

-- Note: Since MySQL does not support FULL OUTER JOIN directly, 
-- you can use a UNION of LEFT JOIN and RIGHT JOIN to achieve this.

SELECT 
    Members.MemberID,
    Members.FirstName,
    Members.LastName,
    Books.BookID,
    Books.Title,
    Transactions.TransactionID,
    Transactions.BorrowDate
FROM 
    Members
LEFT JOIN 
    Transactions ON Members.MemberID = Transactions.MemberID
LEFT JOIN 
    Books ON Transactions.BookID = Books.BookID

UNION

SELECT 
    Members.MemberID,
    Members.FirstName,
    Members.LastName,
    Books.BookID,
    Books.Title,
    Transactions.TransactionID,
    Transactions.BorrowDate
FROM 
    Books
LEFT JOIN 
    Transactions ON Books.BookID = Transactions.BookID
LEFT JOIN 
    Members ON Transactions.MemberID = Members.MemberID;


-- Explanation: Includes all rows from both Members and Books with matching Transactions, 
-- or NULL when no match exists.

-- --------------------------------------------------------------------------------------------------------





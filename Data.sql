DROP DATABASE IF EXISTS library;
CREATE DATABASE library;
USE library;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Games;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Fines;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS FinesLog;

CREATE TABLE Members
    (MemberName       VARCHAR(45),
    MemberId        INT,
    Birthday         DATE,
    PRIMARY KEY (MemberId));

CREATE TABLE Movies
    (MediaID        INT,
    Title            VARCHAR(64),
    Director        VARCHAR(64),
    Genre            VARCHAR(32),
    AgeRestriction    DECIMAL(2,0),
    Lang            VARCHAR(32),
    Subtitles        VARCHAR(32),
    PRIMARY KEY(MediaID));

CREATE TABLE Games
    (MediaID            INT,
     Title                VARCHAR(64),
     Genre                VARCHAR(32),
     AgeRestriction        DECIMAL(2,0),
     PRIMARY KEY(MediaID)
    );

CREATE TABLE Books
    (MediaID    INT,
    Author        VARCHAR(45),
    Title        VARCHAR(45),
    Genre        VARCHAR(45),
    Lang        VARCHAR(45),
    PRIMARY KEY(MediaID));

CREATE TABLE Rentals
    (MediaID        INT,
    MemberID        INT,
    ReturnDate      DATE,
    PRIMARY KEY(MediaID, MemberID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (MediaID) REFERENCES Books(MediaID),
    FOREIGN KEY (MediaID) REFERENCES Games(MediaID),
    FOREIGN KEY (MediaID) REFERENCES Movies(MediaID));

CREATE TABLE Fines
    (FineID      INT,
    MemberID     INT,
    Price        INT,
    PRIMARY KEY(FineID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID));

CREATE TABLE FinesLog
    (FineID        INT,
    MemberID       INT,
    PRIMARY KEY(FineID));

INSERT INTO FinesLog VALUES
('0','3003'),
('2','3003'),
('3','3016'),
('4','3007');

INSERT INTO Fines VALUES
('1','3003','100'),
('5','3014','100'),
('6','3008','100'), 
('7','3003','100'),
('8','3003','100');

INSERT INTO Rentals VALUES
('0001','3001','2021-04-11'),
('0020','3001','2021-04-06'),
('0013','3005','2021-02-02'),
('0005','3006','2021-03-05'),
('0018','3018','2021-03-16'),
('0010','3007','2021-02-21'),
('2002','30015','2021-05-02'),
('2020','3005','2021-05-14'),
('1336','3014','2021-04-26'),
('1302','3017','2021-04-30'),
('1722','3018','2021-04-30');

Insert Games VALUES
('2003','UnderWatch','FPS','7'),
('2065','New Warfare','FPS','16'),
('2632','Minebuild','SandBox','3'),
('2211','Amon Gus','Online co-op','7'),
('2345','Counter Attack','FPS','16'),
('2567','Age of Kingdoms 2','Strategy','7'),
('2222','BUPG','Battle royale','18'),
('2001','World of Battlecraft','MMO','11'),
('2020','Rainbow Seven Siege','FPS','16'),
('2002','Rats Ultragib','FPS','7');

INSERT INTO Books VALUES 
('0020', 'Douglas Adams', 'The Hitchhiker\'s Guide to the Galaxy', 'Comedy Science Fiction', 'English'), 
('0001', 'C. S. Lewis', 'The Lion, the Witch and the Wardrobe', 'Fantasy', 'English'),
('0002', 'Ken Follett', 'Jordens søjler', 'Historical Fiction', 'Danish'),
('0003', 'Ken Follett', 'Uendelige verden', 'Historical Fiction', 'Danish'),
('0004', 'Ken Follett', 'Den evige ild', 'Historical Fiction', 'Danish'),
('0005', 'J. K. Rowling', 'Harry Potter and the Philosopher\'s Stone', 'Fantasy', 'English'),
('0006', 'J. K. Rowling', 'Harry Potter and the Chamber of Secrets', 'Fantasy', 'English'),
('0007', 'J. K. Rowling', 'Harry Potter and the Prisoner of Azkaban', 'Fantasy', 'English'),
('0008', 'J. K. Rowling', 'Harry Potter and the Goblet of Fire', 'Fantasy', 'English'),
('0009', 'J. K. Rowling', 'Harry Potter and the Order of the Phoenix', 'Fantasy', 'English'),
('0010', 'J. K. Rowling', 'Harry Potter and the Half-Blood Prince', 'Fantasy', 'English'),
('0011', 'J. K. Rowling', 'Harry Potter and the Deathly Hallows', 'Fantasy', 'English'),
('0012', 'Jan Guillou', 'Brobyggerne', 'Historical Fiction', 'Danish'),
('0013', 'Jan Guillou', 'Dandy', 'Historical Fiction', 'Danish'),
('0014', 'Jan Guillou', 'Mellem rødt og sort', 'Historical Fiction', 'Danish'),
('0015', 'Abraham Silberschatz', 'Database System Concepts', 'Science & Technology', 'English'),
('0016', 'Flemming Nielson', 'Formal Methods, an appetizer', 'Science & Technology', 'English'),
('0017', 'Stephen Hawking', 'A brief history of time', 'Space', 'English'),
('0018', 'Bill Bryson', 'A Short History of Nearly Everything', 'Science & Technology', 'English'),
('0019', 'Dan Brown', 'The Da Vinci Code', 'Mystery Thriller', 'English');

INSERT INTO Movies VALUES
	(1021, "Pulp Fiction", "Quentin Tarantino", "Crime", 18, "English", "Danish"),
    (1302, "The Lion King", "Roger Allers", "Animation", 6, "English", "Danish"),
    (1699, "Forrest Gump", "Robert Zemeckis", "Drama", 13, "English", "Danish"),
    (1914, "Flickering Lights", "Anders Thomas Jensen", "Action", 16, "Danish", "English"),
    (1567, "Another Round", "Thomas Vinterberg", "Drama", 16, "Danish", "English"),
    (1939, "Terkel i Knibe", "Thorbjørn Christoffersen", "Comedy", 13, "Danish", "English"),
    (1123, "Back to the Future", "Robert Zemeckis", "Sci-Fi", 10, "English", "Danish"),
    (1722, "Wall-E", "Andrew Stanton", "Animation", 6, "English", "Danish"),
    (1336, "Borat Subsequent Moviefilm", "Jason Woliner", "Comedy", 18, "English", "Danish"),
    (1444, "City of God", "Fernando Meirelles", "Crime", 18, "Portuguese", "English");

INSERT INTO Members VALUES
('PewDiePie', 3001, '1982-01-08'), 
('Barack Obama', 3002, '1991-12-11'), 
('Hubert', 3003, '1999-04-09'), 
('Pezzarossa', 3004, '1988-03-07'),
('Dwayne (The Rock) Johnson', 3005, '1945-12-24'), 
('Gordon (It\'s Raw) Ramsay', 3006, '1970-09-12'),
('Barack Obama', 3007, '1968-07-31'),
('Ed Sheeran', 3008, '1984-02-29'), 
('J. K. Rowling', 3009, '1965-07-17'), 
('Banan Mand', 3010, '1988-10-10'), 
('Kaptajn Underhyler', 3011, '2010-02-01'),
('Clinton Bill', 3012, '2003-01-12'),
('Donald Trumpet', 3022, '2017-01-12'),
('Kanye West', 3013, '2002-09-29'), 
('Christiano Ronaldo', 3014, '2009-04-13'), 
('Albert Einstein', 30015, '1995-12-12'), 
('Lets do the try outs along the way', 3016, '1999-01-01'), 
('Dronningen', 3017, '2013-10-31'), 
('Oprah', 3018, '2955-06-07'),
('Peter Min Buschauffør', 3019, '2004-08-22'),
('Fedtmule', 3020, '2001-09-09');

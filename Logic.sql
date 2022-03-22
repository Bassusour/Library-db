use Library;
select * from Movies;

##Create function RentMedia (MedID INT, MemID INT) returns boolean 

drop function if exists MediaExists;
CREATE FUNCTION  MediaExists (MedID INT) RETURNS BOOLEAN RETURN
IF(((SELECT MediaID FROM books where MediaID = MedID)) OR ((SELECT MediaID FROM movies where MediaID = MedID)) OR ((SELECT MediaID FROM games where MediaID = MedID)), true, false);

drop function if exists MediaIsRented;
CREATE FUNCTION  MediaIsRented (MedID INT) RETURNS BOOLEAN RETURN
IF((SELECT MediaID FROM rentals where MediaID = MedID), true, false);

drop function if exists UserExists;
CREATE FUNCTION UserExists (MemID INT) RETURNS BOOLEAN RETURN
IF((SELECT MemberID FROM Members WHERE MemberID = MemID),true,false);

DROP FUNCTION IF EXISTS HasAgeRestriction ;
CREATE FUNCTION  HasAgeRestriction (MedID INT) RETURNS BOOLEAN RETURN
IF(((SELECT MediaID FROM movies where MediaID = MedID)) OR ((SELECT MediaID FROM games where MediaID = MedID)), true, false);

drop function if exists UserAge;
CREATE FUNCTION UserAge (MemID INT) RETURNS int RETURN
TIMESTAMPDIFF(YEAR, (Select BirthDay from Members WHERE memberID = MemID), NOW());

DROP PROCEDURE IF EXISTS RentMedia;
DELIMITER // 
Create Procedure RentMedia (MedID INT, MemID INT)
BEGIN
IF (!(MediaIsRented(MedID)) AND (MediaExists(MedID)) AND (UserExists(MemID)))
	THEN
    IF HasAgeRestriction(MedID)
		THEN IF (UserAge (MemID)) >= (select AgeRestriction from movies where medID = MediaId) OR (UserAge (MemID)) >= (select AgeRestriction from games where medID = MediaId)
			Then INSERT INTO rentals VALUES  (medID, MemID, date_add(curdate(),interval 30 day));
		ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Member is not old enoough to rent this media';
		END IF;
    ELSE
		INSERT INTO rentals VALUES  (medID, MemID, date_add(curdate(),interval 30 day));
	END IF;
ELSE
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Media does not exist';
END IF;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS ReturnMedia;
delimiter //
CREATE PROCEDURE ReturnMedia (MedID INT)
BEGIN
DELETE FROM Rentals where MediaID = MedID;
END;
//
delimiter ;

##function for generationg a unique id for a fine
drop function if exists FineNumberTracker;
CREATE FUNCTION  FineNumberTracker() RETURNS INT RETURN
if((select Max(FineID) from fines),((select Max(FineID) from fines)+1),0);

DROP PROCEDURE IF EXISTS LoopThroughRentals;
##Procedure that loops through the rentals table and issue a fine if the media is overdue
delimiter //
CREATE PROCEDURE LoopThroughRentals()
BEGIN
DECLARE n INT DEFAULT 0;
DECLARE currentRow INT DEFAULT 0;
SELECT COUNT(*) FROM rentals INTO n;
SET currentRow=0;
WHILE currentRow < n DO
IF ((SELECT ReturnDate FROM rentals LIMIT currentRow ,1) <= curdate()) 
Then INSERT INTO fines VALUES (FineNumberTracker(),(SELECT memberID FROM rentals LIMIT currentRow,1),'100.0');
END IF;
SET currentRow= currentRow+1;
END WHILE;
End;
//
delimiter ;

##Event that issues fines every day if a media is overdue
SET GLOBAL event_scheduler = 0;
DROP EVENT IF EXISTS IssueFine;
CREATE EVENT IssueFine 
ON SCHEDULE EVERY 1 DAY 
DO 
call LoopThroughRentals();

##Procedure that allows for librarians to remove fines
DROP PROCEDURE IF EXISTS PayFine;
delimiter //
CREATE PROCEDURE PayFine(fiID INT)
begin
DELETE FROM fines where FineID = fiID;
end;
//
delimiter ;

DROP PROCEDURE IF EXISTS AddMovie;
DELIMITER // 
Create Procedure AddMovie (MedID INT, Title VARCHAR(64), Director VARCHAR(64), Genre VARCHAR(32), AgeRestriction DECIMAL(2,0), Lang VARCHAR(32), Subtitles VARCHAR(32))
BEGIN
IF (!(MediaExists(MedID))) 
Then INSERT INTO Movies VALUES  (MedID, Title, Director, Genre, AgeRestriction, Lang, Subtitles);
END IF;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS AddBook;
DELIMITER // 
Create Procedure AddBook (MedID INT, Author VARCHAR(45), Titel VARCHAR(45), Genre	VARCHAR(45), Lang VARCHAR(45))
BEGIN
IF (!(MediaExists(MedID))) 
Then INSERT INTO Books VALUES  (MedID, Author, Titel, Genre, Lang);
END IF;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS AddGame;
DELIMITER // 
Create Procedure AddGame (MedID INT, Title VARCHAR(64), Genre VARCHAR(32), AgeRestriction DECIMAL(2,0))
BEGIN
IF (!(MediaExists(MedID))) 
Then INSERT INTO Games VALUES  (MedID, Title, Genre, AgeRestriction);
END IF;
END; //
DELIMITER ;


drop function if exists FineNumberTracker;
CREATE FUNCTION  FineNumberTracker() RETURNS INT RETURN
IF ((select max(fineID) from (select max(FineID) as fineID from finesLog UNION select max(fineID) as fineID from fines) as fineID), (select max(fineID) from (select max(FineID) as fineID from finesLog UNION select max(fineID) as fineID from fines) as fineID)+1,0);

select * from mediaLog;


SELECT * FROM Members WHERE (UserAge(MemberId)) >= 16;

# TRIGGER
DROP TRIGGER IF EXISTS AddFineToLog
DELIMITER //
CREATE TRIGGER AddFineToLog AFTER DELETE ON fines FOR EACH ROW
BEGIN
    INSERT INTO FinesLog VALUES(OLD.FineID, OLD.MemberID);
END//
DELIMITER ;

# CREATE A VIEW
CREATE VIEW adult_members AS SELECT membername, memberid FROM members WHERE userage(memberid) >= 18;
SELECT * FROM adult_members;

SELECT MemberID, FineID, Price FROM Members NATURAL JOIN fines ORDER BY memberID;

SELECT MemberID, MemberName FROM rentals NATURAL JOIN Members HAVING COUNT(memberID) > 1;

SELECT  (SELECT COUNT(*) FROM books WHERE lang="danish") AS danish_books,
        (SELECT COUNT(*) FROM movies WHERE lang="danish") AS danish_movies FROM dual;

# UPDATE DATE ON EVERY RENTAL
UPDATE Rentals SET ReturnDate = DATE_ADD(ReturnDate, INTERVAL 1 DAY);
select * from rentals;

DELETE FROM Books WHERE Lang = 'Danish';
select * from books;


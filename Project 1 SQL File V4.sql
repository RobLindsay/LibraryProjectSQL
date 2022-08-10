
--************************************************* 
--*************************************************
--Create Book Table with ISBN, Title 

DROP TABLE Project1_Books;
CREATE TABLE Project1_Books (
    ISBN10 VARCHAR2(10) NOT NULL, --!!!!!Choosing to go with the ISBN10 numeber
    Title  VARCHAR2(256) NOT NULL,  
        
    CONSTRAINT BookPK PRIMARY KEY(ISBN10)
    );

INSERT INTO Project1_Books  
       SELECT ISBN10, Title 
       FROM project1_books_load;

--SELECT * FROM Project1_Book;

--************************************************* 
--*************************************************
--Create Book_Authors Table with Aurthor_ID, ISBN
--!!Still Need To Do: No Author Given Scenario, everything else is done

    --!!!!Need to Normalize and change NULL author entries to indication.  Possibly 'No Author Given'
    --!!!!Challenge Here will be in getting all Authors from each book, SEE TABLE AUTHOR FOR SUGGESTION
    --!!!!See notes from 9/15 Lecture 
    --!!!!Unique ID could be ISBN || Author # of book

--First Create Temp_Author_Table to contain ISBN, Author, CommaCount(Author)
DROP TABLE Temp_Author_Table;
CREATE TABLE Temp_Author_Table AS (
    SELECT  ISBN10, Author, 
            LENGTH(REPLACE(Author,',','||')) - LENGTH (Author)+1 AS Number_Authors,
            regexp_substr(Author, '[^,]+' , 1 , 1) AS Author1,
            ISBN10 || '1' AS Author1ID,
            regexp_substr(Author, '[^,]+' , 1 , 2) AS Author2,
            ISBN10 || '2' AS Author2ID,
            regexp_substr(Author, '[^,]+' , 1 , 3) AS Author3,
            ISBN10 || '3' AS Author3ID,
            regexp_substr(Author, '[^,]+' , 1 , 4) AS Author4,
            ISBN10 || '4' AS Author4ID,
            regexp_substr(Author, '[^,]+' , 1 , 5) AS Author5,
            ISBN10 || '5' AS Author5ID
    FROM PROJECT1_Books_Load)
    ;
--SELECT * FROM Temp_Author_Table ORDER BY Number_Authors Desc;
--DESC TEMP_Author_Table;

--Now Create Book_Aurthos Table with Author_ID, ISBN
DROP TABLE Project1_Book_Authors;            
CREATE TABLE Project1_Book_Authors(
    Author_ID   VARCHAR2 (13) NOT NULL,      
    ISBN        VARCHAR2 (10) NOT NULL,
    
    CONSTRAINT BKAuthorPK   PRIMARY KEY (Author_ID),
    CONSTRAINT BKAuthorFK   FOREIGN KEY (ISBN) 
        REFERENCES Project1_Books(ISBN10)
    );

--Insert each of the AuthorID columns and their respective ISBN into Book_Authors
INSERT INTO Project1_Book_Authors  
       SELECT Author1ID, ISBN10 FROM Temp_Author_Table WHERE Author1 is not null;
INSERT INTO Project1_Book_Authors  
       SELECT Author2ID, ISBN10 FROM Temp_Author_Table WHERE Author2 is not null;
INSERT INTO Project1_Book_Authors  
       SELECT Author3ID, ISBN10 FROM Temp_Author_Table WHERE Author3 is not null;
INSERT INTO Project1_Book_Authors  
       SELECT Author4ID, ISBN10 FROM Temp_Author_Table WHERE Author4 is not null;
INSERT INTO Project1_Book_Authors  
       SELECT Author5ID, ISBN10 FROM Temp_Author_Table WHERE Author5 is not null;
--SELECT * FROM Project1_Book_Authors; 


--*************************************************  
--************************************************* 
--Create Authors Table with AuthorID, Name
--!!Still Need To Do: No Author Given Scenario, everything else is done
    --!!!!USE The Same Code As The Book_Authors but with Name instead of ISBN
    --!!!!Could also create a temporary table of ISBN, AuthorName, AuthorID the Drop temp table

DROP TABLE Project1_Authors;    
CREATE TABLE Project1_Authors(
    Author_ID   VARCHAR2(13)    NOT NULL,     
    Name        VARCHAR2(100)   NOT NULL,
    
    CONSTRAINT  AuthorNamesPK   PRIMARY KEY (Author_ID)
    );        

--Insert each of the AuthorID columns and their respective ISBN into Book_Authors
INSERT INTO Project1_Authors  
       SELECT Author1ID, Author1 FROM Temp_Author_Table WHERE Author1 is not null;
INSERT INTO Project1_Authors  
       SELECT Author2ID, Author2 FROM Temp_Author_Table WHERE Author2 is not null;
INSERT INTO Project1_Authors  
       SELECT Author3ID, Author3 FROM Temp_Author_Table WHERE Author3 is not null;
INSERT INTO Project1_Authors  
       SELECT Author4ID, Author4 FROM Temp_Author_Table WHERE Author4 is not null;
INSERT INTO Project1_Authors  
       SELECT Author5ID, Author5 FROM Temp_Author_Table WHERE Author5 is not null;
--SELECT * FROM Project1_Authors; 

DROP TABLE Temp_Author_Table;         --This should be at the end of this section, created in previous section


--*************************************************
--*************************************************
--Create Library_Branch Table with Branch_ID, Branch_Name, Address
CREATE TABLE Project1_Library_Branch (
    Branch_ID   NUMBER (2)      NOT NULL,
    Branch_Name VARCHAR2(30)    NOT NULL,
    Address     VARCHAR2(50)    NOT NULL,  
    
    CONSTRAINT BranchPK PRIMARY KEY (Branch_ID)
    );

INSERT INTO Project1_Library_Branch
    SELECT Branch_ID, Branch_Name, Address    
    FROM project1_library_branch_load
    ;
--SELECT * FROM Project1_Library_Branch;
COMMIT;

--*************************************************
--*************************************************
--Create Book_Copies Table with Book_ID, ISBN, Branch_ID
--!!!!Will Need to figure out how to create a unique number for each copy 
--!!!! Could add up all the copies K of the ISBN and just number them ISBN || 1 to K 
--!!!! Or could do Branch || ISBN || 1 to K for each copy at each branch

--SELECT * FROM Project1_Book_Copies_Load;
--SELECT MAX(No_Of_Copies) from Project1_Book_Copies_Load;  --> 18 is the maximum number of copies of a single book at a single branch


--FIRST, create a temporary copies table that creates the maximum possible amount of books (up to 18) provided there is a copy at the branch
DROP TABLE Temp_Copies_Table;
CREATE TABLE Temp_Copies_Table AS (
    SELECT  Book_ID, Branch_ID, No_Of_Copies,
            Branch_ID || Book_ID || '01OF' ||No_OF_Copies AS Copy1, --Would have to update this each time you got a new book in real life
            Branch_ID || Book_ID || '02OF' ||No_OF_Copies AS Copy2,
            Branch_ID || Book_ID || '03OF' ||No_OF_Copies AS Copy3,
            Branch_ID || Book_ID || '04OF' ||No_OF_Copies AS Copy4,
            Branch_ID || Book_ID || '05OF' ||No_OF_Copies AS Copy5,
            Branch_ID || Book_ID || '06OF' ||No_OF_Copies AS Copy6,
            Branch_ID || Book_ID || '07OF' ||No_OF_Copies AS Copy7,
            Branch_ID || Book_ID || '08OF' ||No_OF_Copies AS Copy8,
            Branch_ID || Book_ID || '09OF' ||No_OF_Copies AS Copy9,
            Branch_ID || Book_ID || '10OF' ||No_OF_Copies AS Copy10,
            Branch_ID || Book_ID || '11OF' ||No_OF_Copies AS Copy11,
            Branch_ID || Book_ID || '12OF' ||No_OF_Copies AS Copy12,
            Branch_ID || Book_ID || '13OF' ||No_OF_Copies AS Copy13,
            Branch_ID || Book_ID || '14OF' ||No_OF_Copies AS Copy14,
            Branch_ID || Book_ID || '15OF' ||No_OF_Copies AS Copy15,
            Branch_ID || Book_ID || '16OF' ||No_OF_Copies AS Copy16,
            Branch_ID || Book_ID || '17OF' ||No_OF_Copies AS Copy17,
            Branch_ID || Book_ID || '18OF' ||No_OF_Copies AS Copy18
            
    FROM PROJECT1_Book_Copies_Load WHERE No_OF_Copies>0)  --IF you want to make this more efficient you can do three temp tables x=1 and x=2 (631 instances) x=3 (10+2+4+2+2+2+1+3+1+1 instances)
    ;
--SELECT * FROM Temp_Copies_Table;
--DESC Temp_Copies_Table;

--SECOND Create the Book_Copies Table 
DROP TABLE Project1_Book_Copies;
CREATE TABLE Project1_Book_Copies(
    Book_ID     VARCHAR2(20)    NOT NULL, 
    ISBN        VARCHAR2(10)    NOT NULL, 
    Branch_ID   NUMBER(2)       NOT NULL,
    
    CONSTRAINT Book_CopiesPK        PRIMARY KEY (Book_ID),
    CONSTRAINT Book_Copies_ISBN_FK  FOREIGN KEY (ISBN)
        REFERENCES Project1_Books(ISBN10),
    CONSTRAINT Book_Copies_BrID_FK  FOREIGN KEY (Branch_ID)
        REFERENCES Project1_Library_Branch(Branch_ID)
    );

--THIRD Insert each of the Book_ID, ISBN and Branch ID whenever there are at least X copies in the branch
INSERT INTO Project1_Book_Copies  
       SELECT Copy1, Book_ID, Branch_ID FROM Temp_Copies_Table ;
INSERT INTO Project1_Book_Copies  
       SELECT Copy2, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>1;
INSERT INTO Project1_Book_Copies  
       SELECT Copy3, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>2;
INSERT INTO Project1_Book_Copies  
       SELECT Copy4, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>3;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy5, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>4;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy6, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>5;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy7, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>6;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy8, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>7;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy9, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>8;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy10, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>9;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy11, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>10;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy12, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>11;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy13, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>12;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy14, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>13;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy15, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>14;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy16, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>15;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy17, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>16;       
INSERT INTO Project1_Book_Copies  
       SELECT Copy18, Book_ID, Branch_ID FROM Temp_Copies_Table WHERE No_Of_Copies>17;       
       

--SELECT * FROM Project1_Book_Copies ORDER BY ISBN, Book_ID; 

DROP TABLE Temp_Copies_Table;         --This should be at the end of this section, created in previous section

--*************************************************
--Create Borrower Table with Card_No, SSN,  FName, LName, Address, Phone
DROP TABLE Project1_Borrower;
CREATE TABLE Project1_Borrower (
    Card_No     VARCHAR2(10)    NOT NULL, 
    SSN         VARCHAR2(11)    NOT NULL UNIQUE, 
    FName       VARCHAR2(20)    NOT NULL, 
    LName       VARCHAR2(30)    NOT NULL, 
    Address     VARCHAR2(50)    NOT NULL,  --Going of Assumption that you must provide some sort of contact address
    Phone       VARCHAR2(14)    NOT NULL,  --Going of Assumption that you must provide some sort of contact #
    
    CONSTRAINT BorPK        PRIMARY KEY (Card_NO)
    );
--DESC Project1_Borrower;

INSERT INTO Project1_Borrower
    SELECT ID0000ID, SSN, First_Name, Last_Name, Address, Phone 
    FROM Project1_Borrowers_Load;

--SELECT * FROM Project1_Borrower;
--*************************************************
--Create Book_Loans Table with Loan_ID, Book_ID, Card_no, Date_Out, Due_Date, Date_in
--!!!! Will need to create SQL code to generate 
--          EXACTLY 400 books check-outs                                !!!! 
--          FOR EXACTLY 200 different borrowers 
--          AND Exactly 100 Different Books.  
--          Same borrower should not check out same book more than once !!!! 

DROP TABLE Project1_Book_Loans;
CREATE TABLE Project1_Book_Loans(
    Loan_ID     VarChar2(40)    NOT NULL,   -- Will need to generate this from the sequence and follow Rules
    Book_ID     VARCHAR2(20)    NOT NULL,   -- Length will depend on how Book_ID generated previously
    Card_no     VARCHAR2(10)    NOT NULL,   -- Pull from Borrower ID0000ID
    Date_Out    DATE            NOT NULL,   -- No rules given for date requirements
    Due_Date    DATE            NOT NULL,   -- No rules given for date requirements.   
    Date_in     DATE            NULL,       -- 50 should be after Due_Date, This will feed into the Fines Table Query 

    CONSTRAINT  Book_LoanPK      PRIMARY KEY (Loan_ID),
    CONSTRAINT  Book_LoanFK1     FOREIGN KEY (Book_ID)
        REFERENCES   PROJECT1_Book_Copies (Book_ID),
    CONSTRAINT  Book_LoanFK2     FOREIGN KEY (Card_No)
        REFERENCES   PROJECT1_Borrower (Card_No)
    );
    
INSERT INTO Project1_Book_Loans
  SELECT Card_No||Book_ID || Date_OUT AS Loan_ID,
        Book_ID, Card_No, Date_Out, Due_Date, Date_In
    FROM(
        SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, Lending_Period, Date_Out,
               Date_Out + 31 AS Due_Date,
               Date_Out + ROUND(DBMS_RANDOM.value(0,30),0) AS Date_IN 
            FROM(SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, Lending_Period,
               TO_DATE('01-OCT-2021') - (93 * Lending_Period) + ROUND(DBMS_RANDOM.value(0,30),0) AS Date_Out
                FROM(
                SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, ROW_NUMBER() OVER (PARTITION BY Book_ID ORDER BY Borrower_Rank) AS Lending_Period  
                    FROM
                    (SELECT * FROM(
                            SELECT Book_ID, Card_No, 
                                DENSE_RANK() OVER (ORDER BY BOOK_ID) as Book_Rank, 
                                ROW_NUMBER() OVER (PARTITION BY Book_ID  ORDER BY Card_No) as Borrower_Rank
                                FROM (SELECT * 
                                        FROM (SELECT * FROM (SELECT BK.book_id FROM Project1_Book_Copies BK ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=100) Book,
                                             (SELECT * FROM (SELECT BO.Card_No FROM Project1_Borrower BO ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=200) Borrower
                                        )
                            )
                            WHERE  Book_Rank = Borrower_Rank-1 
                                OR Book_Rank = Borrower_Rank 
                                OR Book_Rank = Borrower_Rank-101 
                                OR Book_Rank = Borrower_Rank-100 
                                OR (Book_Rank = 100 AND Borrower_Rank=1) 
                            ORDER By Book_ID,Borrower_Rank
                    )
                )
            )
    );
--Now, Update the Loans so that 50 loans are returned after their due date
UPDATE Project1_Book_Loans SET Date_In = DUE_DATE + ROUND(DBMS_RANDOM.value(1,30),0) WHERE rownum<51;
SELECT * FROM Project1_Book_Loans;

  
--*************************************************
--Create Fines Table with Loan_ID, Fine_Amt, Paid
--!!!! Will need to create SQL code to generate 
--          EXACTLY 50 fines records for 50 DIFFERENT Borrowers
--          FINES Should be Generated by books checked back in late.
DROP TABLE Project1_Fines;
CREATE TABLE Project1_Fines(
    Loan_ID     VARCHAR2(40) NOT NULL,  --Pull from Loan_ID in 
    Fine_Amt    NUMBER (4,2) NOT NULL,  --"Fine amount is $0.25 per day late
    PAID        VARCHAR2(6)  NOT NULL,  --Indicate if the Fine is paid (No specification in project guidelines)
   
    CONSTRAINT FinesPK PRIMARY KEY (Loan_ID)
    );

INSERT INTO Project1_FINES 
    SELECT  LOAN_ID, 
            (Date_IN - Due_Date)*.25,
            'PAID' 
    FROM Project1_Book_Loans WHERE Due_Date<Date_in;  --!!!! Will need to verify this once Book_Loans work and can randomly assign Paid or Not paid
SELECT * from Project1_FINES;

UPDATE Project1_Fines SET Paid = 'Unpaid' WHERE rownum<25;
*************************************************
--This section below successfuly returns ISBN, Title, and concat Author 
SELECT  BK.ISBN10 AS ISBN, 
        BK.Title, 
        LISTAGG(Auth.Name,', ') WITHIN GROUP (ORDER BY BK.ISBN10) AS Author
    FROM Project1_BOOKS BK 
    INNER JOIN  Project1_Book_Authors BKAuth ON BkAuth.ISBN = BK.ISBN10
    INNER JOIN  Project1_Authors Auth ON Auth.Author_ID = BKAuth.Author_ID
    WHERE   BK.ISBN10 IN 
                       (    SELECT ISBN10 AS SearchISBN From Project1_Books WHERE LOWER(title) LIKE LOWER('%451%') --Search In Book Titles
                        UNION
                            SELECT ISBN AS SearchISBN FROM Project1_Book_Authors 
                                WHERE Author_ID IN
                                            (SELECT Author_ID FROM Project1_Authors WHERE Lower(Name) LIKE '%451%') --Search in Author Names
                        UNION
                            SELECT ISBN10 AS SearchISBN FROM Project1_Books WHERE LOWER(ISBN10) LIKE LOWER('%451%') --Search in ISBN
                       )
    GROUP BY BK.ISBN10,Bk.Title
    ORDER BY BK.Title
;

*************************************************    
--Reports
--Report 1 Show Number of fines generated from each branch location
SELECT Branch_ID, count(Branch_ID) AS No_of_Fines
    FROM Project1_BORROWER 
    INNER JOIN(    
        SELECT Ln_ID, Crd_No, Book_Id, Branch_ID FROM Project1_Book_Copies 
            Inner JOIN (
                    SELECT 
                        B.Loan_ID AS Ln_ID,
                        B.Card_No AS Crd_No,
                        B.Book_ID AS Bk_ID
                        FROM Project1_Book_Loans B INNER JOIN Project1_Fines L ON B.Loan_ID=L.Loan_ID
            )
            ON Bk_ID = Book_ID
    )
    ON Crd_No = Card_No
   GROUP BY Branch_ID;
;

--Report 2 Display the First and Last Name, Card_No and Total # of checkouts, Sorted from high to low 
-- AND only consider users who have no unpaid fines
SELECT FName AS First, LName AS Last, --Count(BR.Card_No) AS No_Of_Checkouts
    --, Book_ID
    BR.Card_No, count (BR.Card_No) AS No_Of_Checkouts
    FROM Project1_Borrower BR
    INNER JOIN Project1_Book_Loans BL ON BL.Card_No = BR.Card_No
    GROUP BY BR.Card_No,LName,Fname
    HAVING BR.Card_NO 
            NOT IN 
            (SELECT Card_No FROM Project1_Book_Loans BL 
                INNER JOIN (
                    SELECT Loan_ID As Still_Bad FROM Project1_Fines Where Paid = 'Unpaid'
                    ) ON Still_Bad = BL.Loan_ID)
    ORDER BY Count(BR.Card_No) DESC
    ;

--Report 3 Show the most popular branch and number of checkouts for each area code based on the number of books checked out at each branch

SELECT Area_Code, Branch_ID AS Most_Popular_Branch, No_Of_Checkouts 
    FROM(
        SELECT Branch_ID, Count(Area_Code) AS No_Of_Checkouts, Area_Code ,rank() over (partition by area_code order by count(area_code)desc ) AS RANK From Project1_Book_Copies
            INNER JOIN( 
                SELECT to_number(Substr(phone,2,3)) AS AREA_CODE, Book_ID AS Bk_ID FROM Project1_BORROWER BR
                    INNER JOIN
                        Project1_Book_Loans BL ON BL.Card_No = BR.Card_No
                ) ON Bk_ID =Book_ID
            GROUP BY Area_Code,Branch_ID
                --HAVING Rank = 1
            ORDER BY Area_Code, Count(Area_Code) desc
        )
    WHERE Rank =1     
    ;
--******************************
--888888888888888888888888888888
--Code to try to get variable to work for Search Results

DEFINE searchvar = 'angel' varchar2 (100);
DEFINE searchlocation = NULL;

--This section below successfuly returns ISBN, Title, and concat Author using a search variable
SELECT  BK.ISBN10 AS ISBNSearch, 
        BK.Title, 
        --bkauth.author_id, 
        LISTAGG(Auth.Name,', ') WITHIN GROUP (ORDER BY BK.ISBN10) AS Author
    FROM Project1_BOOK BK 
    INNER JOIN  Project1_Book_Authors BKAuth ON BkAuth.ISBN = BK.ISBN10
    INNER JOIN  Project1_Authors Auth ON Auth.Author_ID = BKAuth.Author_ID
    WHERE   BK.ISBN10 IN ---- Search For Author name 
                    (SELECT ISBN 
                    FROM Project1_Book_Authors 
                    WHERE   Author_ID IN 
                                (SELECT Author_ID 
                                FROM Project1_Authors 
                                WHERE LOWER(NAME) LIKE ('%'||&searchvar||'%')--**SEARCH TERM**--
                                )
                    )
        OR  BK.ISBN10 IN  ---- Search For Title Name 
                   (SELECT ISBN10 
                    FROM Project1_Book
                    WHERE  LOWER(title) LIKE '%'||LOWER('&searchvar')||'%'--**SEARCH TERM**--
                    )
--        OR  BK.ISBN10 IN   ---- Search For ISBN10
--                   (SELECT ISBN10 
--                    FROM Project1_Book 
--                    WHERE LOWER(ISBN10) LIKE '%'||LOWER(&searchvar)||'%')--**SEARCH TERM**----THIS LINE OF CODE IS TAKING FOREVER- WILL NEED TO INDEX ISBN10 IN BOOK TABLE
    GROUP BY BK.ISBN10,Bk.Title
    ORDER BY BK.Title
;

Define @MYVAR = '%angel%' varchar2 (100);
--Declare @myVar varchar2(100);
--SET @myVar = 'angel';

Select * from Project1_book where lower(Title) like ('%' || lower(&searchvariable) || '%');
Select * from Project1_book where lower(Title) like lower(@myVar);
Select * from Project1_book where lower(Title) like ('%'||'angel'||'%');
Select * from Project1_book where lower(title) like lower('%angel%');

Desc Project1_book;


--Trying to return just the ISBN #s from each search
DEFINE searchvar3 := 'georgia' varchar2 (100);
Select searchvar3 from dual;
DEFINE searchvar4 := '%'+lower(&searchvar3)+'%' ;
DEFINE searchlocation = NULL;
SELECT  * FROM
    (SELECT ISBN 
            FROM Project1_Book_Authors 
            WHERE   Author_ID IN 
                        (SELECT Author_ID 
                        FROM Project1_Authors 
                        WHERE LOWER(NAME) like (&searchvar4)--**SEARCH TERM**--
                        )
            )
    
        OR  BK.ISBN10 IN  ---- Search For Title Name 
                   (SELECT ISBN10 
                    FROM Project1_Book
                    WHERE  LOWER(title) LIKE '%'||LOWER(&searchvar)||'%'--**SEARCH TERM**--
                    )
        OR  BK.ISBN10 IN   ---- Search For ISBN10
                   (SELECT ISBN10 
                    FROM Project1_Book 
                    WHERE LOWER(ISBN10) LIKE '%'||LOWER(&searchvar)||'%')--**SEARCH TERM**----THIS LINE OF CODE IS TAKING FOREVER- WILL NEED TO INDEX ISBN10 IN BOOK TABLE
    GROUP BY BK.ISBN10,Bk.Title
    ORDER BY BK.Title
;

--888888888888888888888888888888
--This is my redo work where I give up on Variables
--This section below successfuly returns ISBN, Title, and concat Author 
SELECT  BK.ISBN10 AS ISBN, 
        BK.Title, 
        LISTAGG(Auth.Name,', ') WITHIN GROUP (ORDER BY BK.ISBN10) AS Author
    FROM Project1_BOOK BK 
    INNER JOIN  Project1_Book_Authors BKAuth ON BkAuth.ISBN = BK.ISBN10
    INNER JOIN  Project1_Authors Auth ON Auth.Author_ID = BKAuth.Author_ID
    WHERE   BK.ISBN10 IN 
                       (    SELECT ISBN10 AS SearchISBN From Project1_Book WHERE LOWER(title) LIKE LOWER('%Connected%') --Search In Book Titles
                        UNION
                            SELECT ISBN AS SearchISBN FROM Project1_Book_Authors 
                                WHERE Author_ID IN
                                            (SELECT Author_ID FROM Project1_Authors WHERE Lower(Name) LIKE '%Connected%') --Search in Author Names
                        UNION
                            SELECT ISBN10 AS SearchISBN FROM Project1_Book WHERE LOWER(ISBN10) LIKE LOWER('%Connected%') --Search in ISBN
                       )
    GROUP BY BK.ISBN10,Bk.Title
    ORDER BY BK.Title
;

--Now, let's look at all the book coppies for these books
Select * FROM Project1_Book_Copies WHERE   ISBN IN 
                       (    SELECT ISBN10 AS SearchISBN From Project1_Book WHERE LOWER(title) LIKE LOWER('%Connected%') --Search In Book Titles
                        UNION
                            SELECT ISBN AS SearchISBN FROM Project1_Book_Authors 
                                WHERE Author_ID IN
                                            (SELECT Author_ID FROM Project1_Authors WHERE Lower(Name) LIKE '%Connected%') --Search in Author Names
                        UNION
                            SELECT ISBN10 AS SearchISBN FROM Project1_Book WHERE LOWER(ISBN10) LIKE LOWER('%Connected%') --Search in ISBN
                       );
--Need to create an unreturned book loan to check functionality
Select * From Project1_Borrower;
INSERT INTO Project1_Book_Loans
    VALUES('ID000070'||'5006092987101OF1'||'01202021', 
            '5006092987101OF1',
            'ID000070',
            '01-OCT-2021', 
            '31-OCT-2021', 
            NULL );
Select * From Project1_Book_Loans;   
    
update Project1_Book_Loans set Date_In='02-OCT-2021'
where Date_In IS NULL;    


   
    
--Now, let's check availibility of all the book coppies for these books
SELECT * From Project1_Book where ISBN10 IN (Select ISBN From Project1_Book_Copies WHERE Book_Id ='5006092987101OF1');
Select * From Project1_Book_Loans;

Select BKID, BKISBN, BKBranch--, BL.Due_Date 
    FROM (SELECT BC.Book_ID AS BKID, BC.ISBN AS BKISBN, BC.Branch_ID AS BKBranch FROM  Project1_Book_Copies BC WHERE   ISBN IN 
                       (    SELECT ISBN10 AS SearchISBN From Project1_Book WHERE LOWER(title) LIKE LOWER('%Brave%') --Search In Book Titles
                        UNION
                            SELECT ISBN AS SearchISBN FROM Project1_Book_Authors 
                                WHERE Author_ID IN
                                            (SELECT Author_ID FROM Project1_Authors WHERE Lower(Name) LIKE '%Brave%') --Search in Author Names
                        UNION
                            SELECT ISBN10 AS SearchISBN FROM Project1_Book WHERE LOWER(ISBN10) LIKE LOWER('%Brave%') --Search in ISBN
                       )
            )
WHERE BKID NOT IN (SELECT Book_ID FROM Project1_Book_Loans WHERE DATE_IN IS Null);            


--Now, let's just show the ISBN's at each branch
Select BKISBN AS ISBN, COUNT(BKISBN) As Num_Available, BKBranch as Branch_ID FROM
    (Select BKID, BKISBN, BKBranch--, BL.Due_Date 
        FROM (SELECT BC.Book_ID AS BKID, BC.ISBN AS BKISBN, BC.Branch_ID AS BKBranch FROM  Project1_Book_Copies BC WHERE   ISBN IN 
                           (    SELECT ISBN10 AS SearchISBN From Project1_Book WHERE LOWER(title) LIKE LOWER('%Brave%') --Search In Book Titles
                            UNION
                                SELECT ISBN AS SearchISBN FROM Project1_Book_Authors 
                                    WHERE Author_ID IN
                                                (SELECT Author_ID FROM Project1_Authors WHERE Lower(Name) LIKE '%Brave%') --Search in Author Names
                            UNION
                                SELECT ISBN10 AS SearchISBN FROM Project1_Book WHERE LOWER(ISBN10) LIKE LOWER('%Brave%') --Search in ISBN
                           )
                )
    WHERE BKID NOT IN (SELECT Book_ID FROM Project1_Book_Loans WHERE DATE_IN IS Null))            
Group By BKISBN, BKBranch;




--Now, let's show an aggregate availability by branch for each ISBN
SELECT ISBN, LISTAGG(Branch_ID,', ') WITHIN GROUP (ORDER BY ISBN) AS Currently_Available_At
    FROM
        (Select BKISBN AS ISBN, COUNT(BKISBN) As Num_Available, BKBranch as Branch_ID FROM
            (Select BKID, BKISBN, BKBranch--, BL.Due_Date 
                FROM (SELECT BC.Book_ID AS BKID, BC.ISBN AS BKISBN, BC.Branch_ID AS BKBranch FROM  Project1_Book_Copies BC WHERE   ISBN IN 
                                   (    SELECT ISBN10 AS SearchISBN From Project1_Book WHERE LOWER(title) LIKE LOWER('%Brave%') --Search In Book Titles
                                    UNION
                                        SELECT ISBN AS SearchISBN FROM Project1_Book_Authors 
                                            WHERE Author_ID IN
                                                        (SELECT Author_ID FROM Project1_Authors WHERE Lower(Name) LIKE '%Brave%') --Search in Author Names
                                    UNION
                                        SELECT ISBN10 AS SearchISBN FROM Project1_Book WHERE LOWER(ISBN10) LIKE LOWER('%Brave%') --Search in ISBN
                                   )
                        )
            WHERE BKID NOT IN (SELECT Book_ID FROM Project1_Book_Loans WHERE DATE_IN IS Null))            
        Group By BKISBN, BKBranch)
    GROUP BY ISBN
;



--******888888888888888888888888*******
--******888888888888888888888888*******
--******888888888888888888888888*******
--THIS IS MY ORIGINAL ATTEMPT AT CREATING THE BORROWER, BOOKS AND LOANS
--FIRST, Generate 200 Borrowers and 100 Books 
DROP TABLE Temp_100_Books;
CREATE TABLE Temp_100_Books(
    Book_ID VARCHAR2(20),RowNumber integer);
DESC Temp_100_Books;

DROP TABLE Temp_200_Borrowers;
CREATE TABLE Temp_200_Borrowers(
    Card_No VARCHAR2(8),RowNumber integer);
DESC Temp_100_Books;

--Select 100 books (ensure no duplicates to protect against same book title being checed out twice)
INSERT INTO Temp_100_Books 
    Select Book_ID, RANK() OVER (ORDER BY Book_ID) FROM Project1_Book_Copies
    WHERE ISBN IN (
        --Select 100 books with just 1 copy of the book
        Select ISBN FROM
        (SELECT ISBN, Count(ISBN) --,Rank() over (IMDB) as IMDB_Rank
            From Project1_Book_Copies
            Group By ISBN
            Having count(ISBN)=1
            ORDER BY ISBN
            )
        WHERE RowNum < 101)
    ;      
Select * From Temp_100_Books;

--Select 200 borrowers    
INSERT INTO Temp_200_Borrowers
    Select Card_No, RANK() OVER (ORDER BY Card_No) FROM Project1_Borrower WHERE ROWNUM < 201;
SELECT * From Temp_200_Borrowers;

--SECOND, Assign 100 bookloans to the first 100 borrowers (Out and In On time) Month of April
INSERT INTO Project1_Book_Loans
    Select 
        Card_No||Book_ID||'01042021', 
        book_id,
        card_no, 
        '01-APR-2021', 
        '01-MAY-2021', 
        '08-APR-2021' 
    From Temp_200_Borrowers Bor Inner Join Temp_100_Books Bk ON BK.rownumber=Bor.rownumber;
--Select * FROM Book_Loans;

--THIRD, Assign 100 bookloans to the second 100 borrowers ( Out and In On time) Month of May
INSERT INTO Project1_Book_Loans
    Select 
        Card_No||Book_ID||'01042021', 
        book_id,
        card_no, 
        '01-MAY-2021', 
        '01-JUN-2021', 
        '08-MAY-2021' 
    From Temp_200_Borrowers Bor Inner Join Temp_100_Books Bk ON BK.rownumber+100=Bor.rownumber;
--Select * FROM Book_Loans;

--FOURTH, Assign 100 bookloans to the first 100+1 (exclude 1st borrower) borrowers (Out and In on time) Month of June
INSERT INTO Project1_Book_Loans
    Select 
        Card_No||Book_ID||'01042021', 
        book_id,
        card_no, 
        '01-JUN-2021', 
        '01-JUL-2021', 
        '08-JUN-2021' 
    From Temp_200_Borrowers Bor Inner Join Temp_100_Books Bk ON BK.rownumber+1=Bor.rownumber;
--Select * FROM Book_Loans;

--FIFTH, Assign 50 bookloans to the last 50 borrowers (Out and In on time) Month of July
INSERT INTO Project1_Book_Loans
    Select 
        Card_No||Book_ID||'01042021', 
        book_id,
        card_no, 
        '01-JUL-2021', 
        '01-AUG-2021', 
        '08-JUL-2021' 
    From Temp_200_Borrowers Bor Inner Join Temp_100_Books Bk ON BK.rownumber+150 =Bor.rownumber;
--Select * FROM Book_Loans;

--SIXTH, Assign the last 50 books to bookloans for the first 50 borrowers (DATE IN AFTER DUE DATE) MOnth of August with Random Date In calculation after due date
INSERT INTO Project1_Book_Loans
    Select 
        Card_No||Book_ID||'01042021', 
        book_id,
        card_no, 
        '01-Aug-2021', 
        '01-SEP-2021', 
        '08-SEP-2021' 
    
    From Temp_200_Borrowers Bor Inner Join Temp_100_Books Bk ON BK.rownumber-50 =Bor.rownumber;
--Select * FROM Book_Loans;

--SELECT * FROM Book_Loans Order By Card_No, Book_Id;
--SELECT Card_No, Date_In - Due_Date FROM Book_Loans Order By Card_No, Book_Id;

--SELECT Card_No, Count (Distinct(Book_ID)), Count(Book_ID) FROM Book_Loans Group By Card_NO;

--Select * From Book_Loans order by Due_Date;

--******888888888888888888888888*******
--******888888888888888888888888*******
--******888888888888888888888888*******
--HERE IS MY SECOND ATTEMPT AT CREATING BORROWERS, BOOKS AND LOANS USING "RECIPES"

SELECT * FROM (SELECT BK.book_id FROM Project1_Book_Copies BK ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=100;
SELECT * FROM (SELECT BO.Card_No FROM Project1_Borrower BO ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=200;

SELECT Book.*,Borrower.*
    FROM (SELECT * FROM (SELECT BK.book_id FROM Project1_Book_Copies BK ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=100) Book,
         (SELECT * FROM (SELECT BO.Card_No FROM Project1_Borrower BO ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=200) Borrower
    ;


SELECT Book_ID, Card_No, 
    DENSE_RANK() OVER (ORDER BY BOOK_ID) as Book_Rank, 
    ROW_NUMBER() OVER (PARTITION BY Book_ID  ORDER BY Card_No) as Borrower_Rank
    FROM (SELECT * 
            FROM (SELECT * FROM (SELECT BK.book_id FROM Project1_Book_Copies BK ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=100) Book,
                 (SELECT * FROM (SELECT BO.Card_No FROM Project1_Borrower BO ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=200) Borrower
            );

SELECT * FROM(
    SELECT Book_ID, Card_No, 
        DENSE_RANK() OVER (ORDER BY BOOK_ID) as Book_Rank, 
        ROW_NUMBER() OVER (PARTITION BY Book_ID  ORDER BY Card_No) as Borrower_Rank
        FROM (SELECT * 
                FROM (SELECT * FROM (SELECT BK.book_id FROM Project1_Book_Copies BK ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=100) Book,
                     (SELECT * FROM (SELECT BO.Card_No FROM Project1_Borrower BO ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=200) Borrower
                )
    )
    WHERE Book_Rank = Borrower_Rank-1 
        OR Book_Rank = Borrower_Rank 
        OR Book_Rank = Borrower_Rank-101 
        OR Book_Rank=Borrower_Rank-100 
        OR (Book_Rank = 100 AND Borrower_Rank=1) 
    ORDER By Book_ID,Borrower_Rank
    ;

SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, ROW_NUMBER() OVER (PARTITION BY Book_ID ORDER BY Borrower_Rank) AS Lending_Period  
    FROM
    (SELECT * FROM(
            SELECT Book_ID, Card_No, 
                DENSE_RANK() OVER (ORDER BY BOOK_ID) as Book_Rank, 
                ROW_NUMBER() OVER (PARTITION BY Book_ID  ORDER BY Card_No) as Borrower_Rank
                FROM (SELECT * 
                        FROM (SELECT * FROM (SELECT BK.book_id FROM Project1_Book_Copies BK ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=100) Book,
                             (SELECT * FROM (SELECT BO.Card_No FROM Project1_Borrower BO ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=200) Borrower
                        )
            )
            WHERE Book_Rank = Borrower_Rank-1 
                OR Book_Rank = Borrower_Rank 
                OR Book_Rank = Borrower_Rank-101 
                OR Book_Rank=Borrower_Rank-100 
                OR (Book_Rank = 100 AND Borrower_Rank=1) 
            ORDER By Book_ID,Borrower_Rank
    );    
    
SELECT Date('01-OCT-2021') FROM Dual;
select CAST('DEC-12-2021' AS DATE) from dual;
select TO_DATE('DEC-12-2021','MON-DD-YYYY') from dual;
select TO_DATE('DEC-12-2021 23:05:02','MON-DD-YYYY HH24:MI:SS') from dual;

SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, Lending_Period,
       TO_DATE('01-OCT-2021') - (62 * Lending_Period) + ROUND(DBMS_RANDOM.value(0,30),0) AS Date_Out
    FROM(
    SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, ROW_NUMBER() OVER (PARTITION BY Book_ID ORDER BY Borrower_Rank) AS Lending_Period  
        FROM
        (SELECT * FROM(
                SELECT Book_ID, Card_No, 
                    DENSE_RANK() OVER (ORDER BY BOOK_ID) as Book_Rank, 
                    ROW_NUMBER() OVER (PARTITION BY Book_ID  ORDER BY Card_No) as Borrower_Rank
                    FROM (SELECT * 
                            FROM (SELECT * FROM (SELECT BK.book_id FROM Project1_Book_Copies BK ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=100) Book,
                                 (SELECT * FROM (SELECT BO.Card_No FROM Project1_Borrower BO ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=200) Borrower
                            )
                )
                WHERE Book_Rank = Borrower_Rank-1 
                    OR Book_Rank = Borrower_Rank 
                    OR Book_Rank = Borrower_Rank-101 
                    OR Book_Rank=Borrower_Rank-100 
                    OR (Book_Rank = 100 AND Borrower_Rank=1) 
                ORDER By Book_ID,Borrower_Rank
        )
    );    
    
--THIS CODE BELOW CREATES EVERYTHING EXCEPT FOR OVERDUE TURN INS    
SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, Lending_Period, Date_Out,
       Date_Out + 31 AS Due_Date,
       Date_Out + ROUND(DBMS_RANDOM.value(0,30),0) AS Date_IN 
    FROM(SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, Lending_Period,
       TO_DATE('01-OCT-2021') - (62 * Lending_Period) + ROUND(DBMS_RANDOM.value(0,30),0) AS Date_Out
        FROM(
        SELECT Book_ID, Card_No,Book_Rank,Borrower_Rank, ROW_NUMBER() OVER (PARTITION BY Book_ID ORDER BY Borrower_Rank) AS Lending_Period  
            FROM
            (SELECT * FROM(
                    SELECT Book_ID, Card_No, 
                        DENSE_RANK() OVER (ORDER BY BOOK_ID) as Book_Rank, 
                        ROW_NUMBER() OVER (PARTITION BY Book_ID  ORDER BY Card_No) as Borrower_Rank
                        FROM (SELECT * 
                                FROM (SELECT * FROM (SELECT BK.book_id FROM Project1_Book_Copies BK ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=100) Book,
                                     (SELECT * FROM (SELECT BO.Card_No FROM Project1_Borrower BO ORDER BY DBMS_RANDOM.RANDOM) WHERE rownum<=200) Borrower
                                )
                    )
                    WHERE Book_Rank = Borrower_Rank-1 
                        OR Book_Rank = Borrower_Rank 
                        OR Book_Rank = Borrower_Rank-101 
                        OR Book_Rank=Borrower_Rank-100 
                        OR (Book_Rank = 100 AND Borrower_Rank=1) 
                    ORDER By Book_ID,Borrower_Rank
            )
        )
    );        
--******888888888888888888888888*******
--******888888888888888888888888*******
--******888888888888888888888888*******
SELECT * FROM(
select a.*,d.*, DENSE_RANK() OVER(order by card_no) as bor_rank,
ROW_NUMBER() OVER(partition by card_no order by card_no,book_id) as borbook_rank
FROM
(SELECT *
FROM (
select distinct a.card_no
from project1_borrower a
ORDER BY DBMS_RANDOM.RANDOM)
where rownum<201) a,
(SELECT *
FROM (
select distinct d.book_id book_id
from project1_book_copies d
ORDER BY DBMS_RANDOM.RANDOM)
where rownum<101) d)
WHERE (bor_rank) = borbook_rank-1 or (bor_rank) = borbook_rank or (bor_rank=200 and borbook_rank=1);
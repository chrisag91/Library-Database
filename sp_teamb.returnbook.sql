


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Chris G.
-- Create date: 07/08/2023
-- Description:	--Created a stored procedure to return a book back into the database making sure to update each table accordingly--
-- =============================================

ALTER PROCEDURE TeamB.ReturnBook
        
		@MemberID varchar(99)
	   ,@ISBN varchar(99)
	   ,@Title varchar(99)
	   ,@DateBorrowed date
	   ,@DueDate date
		
AS
      BEGIN
SET NOCOUNT ON
IF NOT EXISTS (SELECT * FROM TeamB.BorrowedBooks WHERE MemberID=@MemberID)
		   SELECT 'Book returned successfully!' AS [Returned Books]
		   ELSE
		   SELECT 'This book has already been returned!' AS [Returned Book History]
		   
IF NOT EXISTS (SELECT * FROM TeamB.BorrowedBooks WHERE MemberID=@MemberID)
BEGIN
INSERT INTO TeamB.BorrowedBooks(MemberID, ISBN, Title, DateBorrowed, DueDate)
VALUES(@MemberID, @ISBN, @Title, @DateBorrowed, @DueDate)

	     UPDATE BorrowedBooks
         SET DateReturned = GETDATE()
         WHERE MemberID = @MemberID

		 UPDATE Members
		 SET CurrentlyBorrowed = CurrentlyBorrowed - 1
		 WHERE MemberID = @MemberID AND CurrentlyBorrowed >=1

		 UPDATE TeamB.Books 
		 SET Available = 'Yes' WHERE ISBN = @ISBN
    
      END
END

	  
--This transaction calls the stored procedure to see if the database returns a book successfully and displays a message--

 BEGIN TRANSACTION

  SELECT *
  FROM TeamB.BorrowedBooks

  SELECT *
  FROM TeamB.Members

  SELECT *
  FROM TeamB.Books

  EXEC TeamB.ReturnBook 110, 9780385474542, 'Things Fall Apart', '07-10-2023', '07-20-2023'
 
  SELECT *
  FROM TeamB.BorrowedBooks

  SELECT *
  FROM TeamB.Members

  SELECT *
  FROM TeamB.Books

  ROLLBACK TRANSACTION
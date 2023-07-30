


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Chris G.
-- Create date: 07/05/2023
-- Description:	--Created a stored procedure to issue a book to a member while 
--to make sure the same book isn't issued to the same member twice--
-- =============================================

CREATE PROCEDURE TeamB.IssueBook
         @ISBN varchar(99) 
		,@MemberID varchar(99)
		,@Title varchar(99)
AS
      BEGIN
IF EXISTS (SELECT * FROM TeamB.BorrowedBooks WHERE ISBN=@ISBN AND MemberID=@MemberID AND Title=@Title)           SELECT 'The member has already borrowed this book!' AS [Member Borrow History]
		   ELSE
		   SELECT 'Book issued successfully' AS [Issued Book]



IF EXISTS (SELECT * FROM TeamB.BorrowedBooks WHERE ISBN=@ISBN AND MemberID=@MemberID AND Title=@Title)
BEGIN
INSERT INTO TeamB.BorrowedBooks(ISBN, MemberID, Title)
VALUES(@ISBN, @MemberID, @Title)
 
        UPDATE BorrowedBooks        SET DateBorrowed = GETDATE()        WHERE MemberID = @MemberID AND ISBN = @ISBN AND Title = @Title		UPDATE BorrowedBooks		SET DueDate = DATEADD(DAYOFYEAR, + 7, DateBorrowed)		WHERE MemberID = @MemberID AND ISBN = @ISBN AND Title = @Title				UPDATE Members		SET CurrentlyBorrowed = CurrentlyBorrowed + 1		WHERE MemberID = @MemberID	    	    UPDATE Members 		SET DateIssued = GETDATE()        WHERE MemberID = @MemberID		UPDATE Members		SET Title = @Title		WHERE MemberID = @MemberID		UPDATE Members		SET ISBN = @ISBN		WHERE MemberID = @MemberID		UPDATE Members		SET DueDate = DATEADD(DAYOFYEAR, +7, DateIssued)		WHERE MemberID = @MemberID 				UPDATE Members		SET IssuedBooks = IssuedBooks + 1		WHERE MemberID = @MemberID         UPDATE Books 
		SET Available = 'No' 
		WHERE ISBN = @ISBN AND Title = @Title
END
	 END


	--The transaction calls the stored procedure to issue a book to a member while reducing redundancy by making sure the book is only issued once to the member--

 BEGIN TRANSACTION
  SELECT *
  FROM TeamB.BorrowedBooks

  EXEC TeamB.IssueBook 9780385474542, 110, 'Things Fall Apart'

 SELECT *
  FROM TeamB.BorrowedBooks
  ROLLBACK TRANSACTION
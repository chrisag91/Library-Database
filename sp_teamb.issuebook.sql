


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
IF EXISTS (SELECT * FROM TeamB.BorrowedBooks WHERE ISBN=@ISBN AND MemberID=@MemberID AND Title=@Title)
		   ELSE
		   SELECT 'Book issued successfully' AS [Issued Book]



IF EXISTS (SELECT * FROM TeamB.BorrowedBooks WHERE ISBN=@ISBN AND MemberID=@MemberID AND Title=@Title)
BEGIN
INSERT INTO TeamB.BorrowedBooks(ISBN, MemberID, Title)
VALUES(@ISBN, @MemberID, @Title)
 
        UPDATE BorrowedBooks
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
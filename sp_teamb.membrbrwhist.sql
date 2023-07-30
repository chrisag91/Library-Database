 
 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Chris G.
-- Create date: 07/08/2023
-- Description:	---A recursive CTE is implemented to view the complete borrowing history of a member with dates borrowed and returned--
 ------------------An anchor member is used to initialize the  recursive CTE, which is the first part of the query and an inner join 
 ------------------used to bring back only the record where it matches
-- =============================================

CREATE PROCEDURE TeamB.MemberBorrowHist
AS BEGIN
SET NOCOUNT ON
;WITH MemberBorrowHistory AS
			(SELECT M.MemberID 
            ,M.FirstName       
			,M.LastName
			,M.IssuedBooks
			,BB.Title
			,BB.DateBorrowed
			,BB.DueDate

  FROM TeamB.Members AS M
  JOIN TeamB.BorrowedBooks AS BB  
  ON M.MemberID = BB.MemberID
  UNION ALL
  SELECT *  
  FROM MemberBorrowHistory 
)

SELECT *  
FROM MemberBorrowHistory
WHERE MemberID = 111
OPTION (MAXRECURSION 0)  --this allows recursion to exhaust past 100 before statement completion
END

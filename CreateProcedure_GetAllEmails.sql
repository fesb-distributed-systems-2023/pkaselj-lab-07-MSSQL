USE [EasyMailDB]
GO
/****** Object:  StoredProcedure [dbo].[GetAllEmails]    Script Date: 1/22/2024 7:44:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Petar Kaselj
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[GetAllEmails] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		Emails.ID,
		SEN.EmailAddress AS Sender,
		[Subject],
		Body,
		[Timestamp],
		REC.EmailAddress
	FROM
		Emails
	INNER JOIN
		Users AS SEN
	ON
		Emails.SenderID = SEN.ID
	INNER JOIN
		EmailReceiverMap
	ON
		EmailReceiverMap.EmailID = Emails.ID
	INNER JOIN
		Users AS REC
	ON
		EmailReceiverMap.ReceiverID = REC.ID;
END

USE [EasyMailDB]
GO
/****** Object:  StoredProcedure [dbo].[CreateEmail]    Script Date: 1/22/2024 7:44:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Petar Kaselj
-- Create date: 
-- Description:	Create an email
-- =============================================
ALTER PROCEDURE [dbo].[CreateEmail] 
	-- Add the parameters for the stored procedure here
	@Subject VARCHAR(MAX),
	@Body VARCHAR(MAX),
	@Timestamp_ VARCHAR(MAX),
	@Sender VARCHAR(MAX),
	@ReceiverList VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



BEGIN TRANSACTION
BEGIN TRY
	---- Add Sender into Users table if they don't exist and save Sender's ID
	DECLARE @SenderID INT;

	SELECT TOP (1) @SenderID = ID FROM dbo.Users WHERE EmailAddress = @Sender;
	IF @SenderID IS NULL
	BEGIN
		INSERT INTO dbo.Users(EmailAddress) VALUES (@Sender);
		SET @SenderID = SCOPE_IDENTITY();
		-- SELECT TOP (1) @SenderID = ID FROM dbo.Users WHERE EmailAddress = @Sender;
	END

	---- Exctract a table of receivers from @ReceiverList which is a string of receivers separated by ';'
	DECLARE @ReceiverTable TABLE (
		ID INT,
		EmailAddress VARCHAR(100)
	);

	INSERT INTO @ReceiverTable(EmailAddress) SELECT Value FROM STRING_SPLIT(@ReceiverList, ';');


	-- Get all receiver IDs from Users table. Insert if necessary
	UPDATE
		@ReceiverTable
	SET
		ID = USR.ID
	FROM
		@ReceiverTable RT
	INNER JOIN
		Users USR
	ON
		RT.EmailAddress = USR.EmailAddress;

	DECLARE @NonExistentReceivers TABLE (
		ID INT,
		EmailAddress VARCHAR(100)
	);

	INSERT INTO @NonExistentReceivers(EmailAddress) SELECT EmailAddress FROM @ReceiverTable WHERE ID IS NULL;
	INSERT INTO Users(EmailAddress) SELECT EmailAddress FROM @NonExistentReceivers;

	UPDATE
		@ReceiverTable
	SET
		ID = USR.ID
	FROM
		@ReceiverTable RT
	INNER JOIN
		Users USR
	ON
		RT.EmailAddress = USR.EmailAddress;

	-- Insert the email

	INSERT INTO Emails([Subject], Body, [Timestamp], SenderID) VALUES (@Subject, @Body, @Timestamp_, @SenderID);
	DECLARE @EmailID INT = SCOPE_IDENTITY();

	INSERT INTO EmailReceiverMap(EmailID, ReceiverID) SELECT @EmailID, ID FROM @ReceiverTable;

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS e;
	ROLLBACK TRANSACTION
END CATCH
END

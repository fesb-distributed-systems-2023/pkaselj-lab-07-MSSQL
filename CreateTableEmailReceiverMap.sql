USE [EasyMailDB]
GO

/****** Object:  Table [dbo].[EmailReceiverMap]    Script Date: 1/22/2024 7:44:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EmailReceiverMap](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmailID] [int] NOT NULL,
	[ReceiverID] [int] NOT NULL,
 CONSTRAINT [PK_EmailReceiverMap] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EmailReceiverMap]  WITH CHECK ADD  CONSTRAINT [FK_EmailReceiverMap_Emails] FOREIGN KEY([EmailID])
REFERENCES [dbo].[Emails] ([ID])
GO

ALTER TABLE [dbo].[EmailReceiverMap] CHECK CONSTRAINT [FK_EmailReceiverMap_Emails]
GO

ALTER TABLE [dbo].[EmailReceiverMap]  WITH CHECK ADD  CONSTRAINT [FK_EmailReceiverMap_Users] FOREIGN KEY([ReceiverID])
REFERENCES [dbo].[Users] ([ID])
GO

ALTER TABLE [dbo].[EmailReceiverMap] CHECK CONSTRAINT [FK_EmailReceiverMap_Users]
GO



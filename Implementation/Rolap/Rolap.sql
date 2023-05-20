DROP DATABASE Kickstarter
GO
CREATE DATABASE Kickstarter
GO
ALTER DATABASE Kickstarter
SET RECOVERY SIMPLE
GO

USE Kickstarter
;

-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
CREATE SCHEMA Kickstarter
GO


/* Drop table Kickstarter.DimLocation */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.DimLocation') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.DimLocation
;

/* Create table Kickstarter.DimLocation */
CREATE TABLE Kickstarter.DimLocation(
	[Country_id]  int NOT NULL
,	[Country_name] varchar (255) NOT NULL
, CONSTRAINT [PK_Kickstarter.DimLocation] PRIMARY KEY CLUSTERED 
( [Country_id] )
) ON [PRIMARY]
;
SET IDENTITY_INSERT Kickstarter.DimLocation ON
;
INSERT INTO Kickstarter.DimLocation (Country_id, Country_name)
VALUES ('1','Germany')
;
SET IDENTITY_INSERT Kickstarter.DimLocation OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[Location]'))
DROP VIEW [Kickstarter].[Location]
GO
CREATE VIEW [Kickstarter].[Location] AS 
SELECT [Country_id] AS [Country_id]
,	[Country_name] AS [Country_name]
FROM Kickstarter.DimLocation
GO



/* Drop table Kickstarter.DimProject */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.DimProject') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.DimProject
;

/* Create table Kickstarter.DimProject */
CREATE TABLE Kickstarter.DimProject(
	[Project_id]  int NOT NULL
,	[Project_name] varchar (255) NOT NULL
,	[Project_blurb] varchar (255) NOT NULL
,	[Project_state] varchar (255) NOT NULL
, CONSTRAINT [PK_Kickstarter.DimProject] PRIMARY KEY CLUSTERED 
( [Project_id] )
) ON [PRIMARY]
;


/* Drop table Kickstarter.DimGenericDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.DimGenericDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.DimGenericDate
;

/* Create table Kickstarter.DimGenericDate */
CREATE TABLE Kickstarter.DimGenericDate(
	[Date]  date NOT NULL
,	[Day_off_year] varchar (255) NOT NULL
,	[Month] int NOT NULL
,	[Year] int NOT NULL
,	[Quarter] int NOT NULL
,	[Month_name] varchar NOT NULL
,	[Day_off_week_name] varchar NOT NULL
,	[Day_off_week] int NOT NULL
,	[Day_off_month] int NOT NULL
,	[Holiday_description] varchar (255) NOT NULL
,	[Is_a_holiday] varchar (255) NOT NULL 
, CONSTRAINT [PK_Kickstarter.DimGenericDate] PRIMARY KEY CLUSTERED 
( [Date] )
) ON [PRIMARY]
;


/* Drop table Kickstarter.FactProject_id_pledged */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.FactProject_id_pledged') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.Project_id_pledged
;

/* Create table Kickstarter.Project_id_pledged */
CREATE TABLE Kickstarter.FactProject_id_pledged (
   [Country_id]  int NOT NULL
,  [Project_id]  int NOT NULL
,  [Date]  date NOT NULL
,  [Goal]  int   NOT NULL
,  [Backers_Count] int NOT NULL
,  [Project_count] int NOT NULL
CONSTRAINT CompositeKey PRIMARY KEY ([Country_id], [Project_id], [Date])
)
;



ALTER TABLE Kickstarter.FactProject_id_pledged ADD CONSTRAINT
   FK_Kickstarter_FactProject_id_pledged_Country_id FOREIGN KEY
   (
   Country_id
   ) REFERENCES Kickstarter.DimLocation
   (Country_id)
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;



ALTER TABLE Kickstarter.FactProject_id_pledged ADD CONSTRAINT
   FK_Kickstarter_FactProject_id_pledged_Project_id FOREIGN KEY
   (
   Project_id
   ) REFERENCES Kickstarter.DimProject
   (Project_id)
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;



ALTER TABLE Kickstarter.FactProject_id_pledged ADD CONSTRAINT
   FK_Kickstarter_FactProject_id_pledged_Date FOREIGN KEY
   (
   Date
   ) REFERENCES Kickstarter.DimGenericDate
   (Date)
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 


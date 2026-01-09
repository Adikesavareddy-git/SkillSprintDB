CREATE DATABASE SkillSprintDB;
USE SkillSprintDB;

CREATE TABLE Users (
    UserID INT IDENTITY PRIMARY KEY,
    Name VARCHAR(100),
    Profession VARCHAR(50),
    Country VARCHAR(50),
    SignupDate DATE
);

CREATE TABLE Skills (
    SkillID INT IDENTITY PRIMARY KEY,
    SkillName VARCHAR(50),
    Category VARCHAR(50)
);
CREATE TABLE LearningSessions (
    SessionID INT IDENTITY PRIMARY KEY,
    UserID INT,
    SkillID INT,
    SessionDate DATE,
    MinutesSpent INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

CREATE TABLE ProductivityStreaks (
    StreakID INT IDENTITY PRIMARY KEY,
    UserID INT,
    StartDate DATE,
    EndDate DATE,
    TotalDays INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

INSERT INTO Users VALUES
('Amit Sharma', 'Data Analyst', 'India', '2024-01-10'),
('Neha Verma', 'Student', 'India', '2024-02-05'),
('John Miller', 'Software Engineer', 'USA', '2024-01-25'),
('Sara Khan', 'Business Analyst', 'UAE', '2024-03-01'),
('Rahul Mehta', 'Power BI Developer', 'India', '2024-02-20');

INSERT INTO Skills VALUES
('SQL', 'Data'),
('Power BI', 'Data'),
('Python', 'Programming'),
('Excel', 'Data'),
('Statistics', 'Math');

INSERT INTO LearningSessions VALUES
(1, 1, '2024-06-01', 90),
(1, 2, '2024-06-02', 120),
(2, 1, '2024-06-01', 60),
(3, 3, '2024-06-03', 150),
(4, 2, '2024-06-04', 80),
(5, 1, '2024-06-05', 110),
(5, 4, '2024-06-06', 70),
(1, 5, '2024-06-07', 100);

INSERT INTO ProductivityStreaks VALUES
(1, '2024-06-01', '2024-06-10', 10),
(2, '2024-06-03', '2024-06-08', 6),
(3, '2024-06-01', '2024-06-12', 12);

--Top learners by total study time

SELECT 
    u.Name,
    SUM(l.MinutesSpent) AS TotalMinutes
FROM Users u
JOIN LearningSessions l ON u.UserID = l.UserID
GROUP BY u.Name
ORDER BY TotalMinutes DESC;
 
 --Most learned skill
 SELECT TOP 1
    s.SkillName,
    SUM(l.MinutesSpent) AS TotalMinutes
FROM LearningSessions l
JOIN Skills s ON l.SkillID = s.SkillID
GROUP BY s.SkillName
ORDER BY TotalMinutes DESC;

--Users with productivity streak ≥ 7 days
SELECT 
    u.Name,
    p.TotalDays
FROM ProductivityStreaks p
JOIN Users u ON p.UserID = u.UserID
WHERE p.TotalDays >= 7;

--Average learning time per skill category
SELECT
    s.Category,
    AVG(l.MinutesSpent) AS AvgMinutes
FROM LearningSessions l
JOIN Skills s ON l.SkillID = s.SkillID
GROUP BY s.Category;

--Rank users by consistency
SELECT
    u.Name,
    p.TotalDays,
    RANK() OVER (ORDER BY p.TotalDays DESC) AS ConsistencyRank
FROM ProductivityStreaks p
JOIN Users u ON p.UserID = u.UserID;


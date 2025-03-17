-- This should be a slightly modified version of inserts.sql
-- from the previous part (see instructions in the canvas page of the assignment) 

INSERT INTO Students VALUES ('1111111111','N1','ls1','Prog1');
INSERT INTO Students VALUES ('2222222222','N2','ls2','Prog1');
INSERT INTO Students VALUES ('3333333333','N3','ls3','Prog2');
INSERT INTO Students VALUES ('4444444444','N4','ls4','Prog1');
INSERT INTO Students VALUES ('5555555555','Nx','ls5','Prog2');
INSERT INTO Students VALUES ('6666666666','Nx','ls6','Prog2');

INSERT INTO Departments VALUES ('CS','Computer Science');
INSERT INTO Departments VALUES ('DS','Data Science');
INSERT INTO Departments VALUES ('CE','Civil Engineering');
INSERT INTO Departments VALUES ('EE',' Electrical Engineering');

INSERT INTO Programs VALUES ('P1','Prog1');
INSERT INTO Programs VALUES ('P2','Prog2');

INSERT INTO Collaboration VALUES ('CS','Prog1');
INSERT INTO Collaboration VALUES ('DS','Prog1');
INSERT INTO Collaboration VALUES ('DS','Prog2');

INSERT INTO Branches VALUES ('B1','Prog1');
INSERT INTO Branches VALUES ('B2','Prog1');
INSERT INTO Branches VALUES ('B1','Prog2');

INSERT INTO Courses VALUES ('CCC111','C1',22.5,'CS');
INSERT INTO Courses VALUES ('CCC222','C2',20,'CS');
INSERT INTO Courses VALUES ('CCC333','C3',30,'CS');
INSERT INTO Courses VALUES ('CCC444','C4',60,'DS');
INSERT INTO Courses VALUES ('CCC555','C5',50,'CE');

INSERT INTO Prerequisites VALUES ('CCC444','CCC111');
INSERT INTO Prerequisites VALUES ('CCC444','CCC222');

INSERT INTO LimitedCourses VALUES ('CCC222',1);
INSERT INTO LimitedCourses VALUES ('CCC333',2);

INSERT INTO StudentBranches VALUES ('2222222222','B1','Prog1');
INSERT INTO StudentBranches VALUES ('3333333333','B1','Prog2');
INSERT INTO StudentBranches VALUES ('4444444444','B1','Prog1');
INSERT INTO StudentBranches VALUES ('5555555555','B1','Prog2');

INSERT INTO Classifications VALUES ('math');
INSERT INTO Classifications VALUES ('research');
INSERT INTO Classifications VALUES ('seminar');

INSERT INTO Classified VALUES ('CCC333','math');
INSERT INTO Classified VALUES ('CCC444','math');
INSERT INTO Classified VALUES ('CCC444','research');
INSERT INTO Classified VALUES ('CCC444','seminar');

INSERT INTO MandatoryProgram VALUES ('CCC111','Prog1');

INSERT INTO MandatoryBranch VALUES ('CCC333', 'B1', 'Prog1');
INSERT INTO MandatoryBranch VALUES ('CCC444', 'B1', 'Prog2');

INSERT INTO RecommendedBranch VALUES ('CCC222', 'B1', 'Prog1');
INSERT INTO RecommendedBranch VALUES ('CCC333', 'B1', 'Prog2');

--INSERT INTO WaitingList VALUES('3333333333','CCC222',1);
--INSERT INTO WaitingList VALUES('5555555555','CCC333',1);
--INSERT INTO WaitingList VALUES('6666666666','CCC333',2);

INSERT INTO Taken VALUES ('2222222222','CCC111','U');
INSERT INTO Taken VALUES ('2222222222','CCC222','U');
INSERT INTO Taken VALUES ('2222222222','CCC444','U');
INSERT INTO Taken VALUES ('3333333333','CCC111','U');
INSERT INTO Taken VALUES ('4444444444','CCC111','5');
INSERT INTO Taken VALUES ('4444444444','CCC222','5');
INSERT INTO Taken VALUES ('4444444444','CCC333','5');
INSERT INTO Taken VALUES ('4444444444','CCC444','5');
INSERT INTO Taken VALUES ('5555555555','CCC111','5');
INSERT INTO Taken VALUES ('5555555555','CCC222','4');
INSERT INTO Taken VALUES ('6666666666','CCC111','3');


INSERT INTO Registered VALUES ('1111111111','CCC333');
INSERT INTO Registered VALUES ('2222222222','CCC333');
INSERT INTO Registered VALUES ('3333333333','CCC333');

--INSERT INTO Registered VALUES ('1111111111','CCC111');
--INSERT INTO Registered VALUES ('1111111111','CCC222');
--INSERT INTO Registered VALUES ('1111111111','CCC555');
--INSERT INTO Registrations VALUES ('4444444444','CCC444');
--INSERT INTO Registrations VALUES ('5555555555','CCC333');
--INSERT INTO Registrations VALUES ('2222222222','CCC444');

--DELETE FROM Registrations WHERE student='1111111111' AND course = 'x'; DELETE FROM Registered WHERE'a'='a';
--SELECT * FROM Registered;
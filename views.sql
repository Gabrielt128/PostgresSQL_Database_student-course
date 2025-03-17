-- This should be your views.sql file from part 2
-- This will likely be an exact copy of views.sql from part 1
-- (unless you have changed names in the database)

CREATE VIEW BasicInformation AS (
    SELECT idnr, name, login, Students.program, branch
    FROM Students LEFT OUTER JOIN StudentBranches
    ON idnr = student);

CREATE VIEW FinishedCourses AS (
    SELECT student, course, Courses.name AS coursename, grade, credits
    FROM Taken LEFT OUTER JOIN Courses
    ON Taken.course = Courses.code);

CREATE VIEW Registrations AS (
    (SELECT student, course, 'registered' AS status 
    FROM Registered)
    UNION
    (SELECT student, course, 'waiting' AS status 
    FROM WaitingList));

-- Helper views for PathToGraduation

CREATE VIEW PassedCourses AS (
    SELECT student, course, credits
    FROM FinishedCourses
    WHERE grade != 'U'
    );

CREATE VIEW UnreadMandatory AS (
    WITH
    MandatoryCourses AS ((SELECT student, course
    FROM StudentBranches AS StuBra LEFT OUTER JOIN MandatoryBranch AS ManBra
    ON StuBra.branch = ManBra.branch AND StuBra.program = ManBra.program)
    UNION
    (SELECT idnr, course
    FROM MandatoryProgram JOIN Students
    ON Students.program = MandatoryProgram.program))
    
    SELECT student, course
    FROM MandatoryCourses
    WHERE NOT EXISTS
    (SELECT *  
        FROM  PassedCourses
        WHERE MandatoryCourses.course = PassedCourses.course
            AND MandatoryCourses.student = PassedCourses.student)
    );

CREATE VIEW MathCredits AS (
WITH mathCredits AS(
  SELECT Courses.code, credits
  FROM Courses RIGHT OUTER JOIN Classified
  ON Courses.code = Classified.course
  WHERE Classified.classification = 'math'
  )
SELECT student, SUM(PassedCourses.credits) AS mathcredits
FROM mathCredits RIGHT OUTER JOIN PassedCourses
ON PassedCourses.course = mathCredits.code
WHERE PassedCourses.course = mathCredits.code
GROUP BY student);

CREATE VIEW SeminarCredits AS (
WITH seminarCredits AS(
  SELECT Courses.code, credits
  FROM Courses RIGHT OUTER JOIN Classified
  ON Courses.code = Classified.course
  WHERE Classified.classification = 'seminar'
  )
SELECT student, COUNT(PassedCourses.credits) AS seminarcourses
FROM seminarCredits RIGHT OUTER JOIN PassedCourses
ON PassedCourses.course = seminarCredits.code
WHERE PassedCourses.course = seminarCredits.code
GROUP BY student);

CREATE VIEW RecommendedCourses AS (
WITH
RecommendedProgram AS (
    SELECT student, RecommendedBranch.branch, RecommendedBranch.program, course
    From RecommendedBranch LEFT OUTER JOIN StudentBranches
    ON RecommendedBranch.program = StudentBranches.program 
    AND RecommendedBranch.branch = StudentBranches.branch)

    SELECT RecommendedProgram.student, credits
    FROM RecommendedProgram LEFT OUTER JOIN PassedCourses
    ON RecommendedProgram.student = PassedCourses.student
    AND RecommendedProgram.course = PassedCourses.course
    WHERE EXISTS
    (SELECT *  
        FROM  PassedCourses
        WHERE RecommendedProgram.course = PassedCourses.course
        AND RecommendedProgram.student = PassedCourses.student)
    );

-- PathToGraduation
-- Dificult VIEW

CREATE VIEW PathToGraduation AS (
WITH 
totalCredits(student, totalcredits) AS (
    SELECT student, SUM(credits)
    FROM PassedCourses
    GROUP BY student
    ),
mandatoryLeft(student, mandatoryleft) AS (
    SELECT student, COUNT(course) 
    FROM UnreadMandatory
    GROUP BY student),

mathCredits(student, mathcredits) AS (
    SELECT student, mathcredits 
    FROM MathCredits),

seminarCourses(student, seminarcourses) AS (
    SELECT student, seminarcourses 
    FROM SeminarCredits), 

recommendedCourses(student, recomendedcredits) AS (
    SELECT student, credits 
    FROM RecommendedCourses
)

SELECT Students.idnr AS student, COALESCE(totalcredits,0) AS totalcredits, 
COALESCE(mandatoryleft,0) AS mandatoryleft, COALESCE(mathcredits,0) AS mathcredits,
COALESCE(seminarcourses,0) AS seminarcourses, 
COALESCE((mathcredits >= 20 AND recomendedcredits >= 10 
AND seminarcourses >= 1 AND COALESCE(mandatoryleft,0) = 0),'f') AS qualified

FROM Students 
LEFT OUTER JOIN totalCredits 
ON Students.idnr = totalCredits.student
LEFT OUTER JOIN mandatoryLeft
ON Students.idnr = mandatoryLeft.student
LEFT OUTER JOIN mathCredits
ON Students.idnr = mathCredits.student
LEFT OUTER JOIN seminarCourses
ON Students.idnr = seminarCourses.student
LEFT OUTER JOIN recommendedCourses
ON Students.idnr = recommendedCourses.student);

--FOR PART4 check of unreg actually deleted anything
CREATE MATERIALIZED VIEW UnregOfStudents AS ( 
    (SELECT *  FROM Registrations));
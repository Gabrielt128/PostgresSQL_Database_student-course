-- This should be your tables file from part 2
-- This will be based on tables.sql from part 1,
-- extended and corrected to match your final schema.

CREATE TABLE Students (
  idnr TEXT PRIMARY KEY
  CHECK (idnr SIMILAR TO '[0-9]{10}'),
  name TEXT NOT NULL,
  --CHECK (name LIKE '% %'),
  login TEXT NOT NULL,
  program TEXT NOT NULL,
  UNIQUE(login),
  UNIQUE(idnr, program));
  --PRIMARY KEY (student, course));

--Departments(_code_, name)
--Unique name

CREATE TABLE Departments (
  code TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE);

--Programs(code, _name_)
CREATE TABLE Programs (
  code TEXT NOT NULL,
  name TEXT PRIMARY KEY);

--Collaboration(_department_, _program_)
--	department → Departments.code
--	program → Programs.name
CREATE TABLE Collaboration (
  code TEXT REFERENCES Departments,
  name TEXT REFERENCES Programs,
  PRIMARY KEY (code, name));

CREATE TABLE Branches (
  name TEXT,
  program TEXT REFERENCES Programs,
  PRIMARY KEY (name, program));

CREATE TABLE Courses (
  code TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  credits REAL NOT NULL, 
  department TEXT NOT NULL
);

CREATE TABLE LimitedCourses(
  code TEXT REFERENCES Courses(code),
  capacity INT NOT NULL,
  PRIMARY KEY(code)
);

CREATE TABLE StudentBranches(
  student TEXT PRIMARY KEY,-- REFERENCES Students(idnr),
  branch TEXT NOT NULL, -- REFERENCES Branches (name),
  program TEXT NOT NULL,-- REFERENCES Students (program),
  FOREIGN KEY (student, program) REFERENCES Students(idnr, program),
  FOREIGN KEY (branch, program) REFERENCES Branches(name, program));

CREATE TABLE Classifications(
  name TEXT PRIMARY KEY
);

CREATE TABLE Classified(
  course TEXT REFERENCES Courses(code),
  classification TEXT REFERENCES Classifications(name),
  PRIMARY KEY (course, classification));

--MandatoryProgram(course*, program*) 
--  course → Courses.code
CREATE TABLE MandatoryProgram (
  course TEXT NOT NULL,
  program TEXT NOT NULL,
  FOREIGN KEY (course) REFERENCES Courses,
  PRIMARY KEY (course, program));
 
 
--MandatoryBranch(course*, branch*, program*) 
--    course → Courses.code 
--    (branch, program) → Branches.(name, program) 
CREATE TABLE MandatoryBranch (
  course TEXT NOT NULL,
  branch TEXT,
  program TEXT NOT NULL,
  FOREIGN KEY (course) REFERENCES Courses,
  FOREIGN KEY (branch, program) REFERENCES Branches,
  PRIMARY KEY (course, branch, program));

--RecommendedBranch(course*, branch*, program*) 
--    course → Courses.code 
--    (branch, program) → Branches.(name, program) 
 
CREATE TABLE RecommendedBranch (
  course TEXT NOT NULL,
  branch TEXT,
  program TEXT NOT NULL,
  FOREIGN KEY (course) REFERENCES Courses,
  FOREIGN KEY (branch, program) REFERENCES Branches,
  PRIMARY KEY (course, branch, program));

--Registered(student*, course*) 
--    student → Students.idnr 
--    course → Courses.code 

CREATE TABLE Registered (
  student TEXT NOT NULL,
  course TEXT NOT NULL,
  FOREIGN KEY (student) REFERENCES Students,
  FOREIGN KEY (course) REFERENCES Courses,
  PRIMARY KEY (student, course));

--Taken(student, course, grade) 
--    student → Students.idnr 
--    course → Courses.code 
CREATE TABLE Taken (
  student TEXT NOT NULL,
  course TEXT NOT NULL,
  grade CHAR(1) NOT NULL,
  CONSTRAINT okgrade CHECK (grade IN ('U','3','4','5')), 
  FOREIGN KEY (student) REFERENCES Students,
  FOREIGN KEY (course) REFERENCES Courses,
  PRIMARY KEY (student, course));


--Prerequisites(_course_, _requirement_)
--	course→ Courses.code
--	needed→ Courses.code

CREATE TABLE Prerequisites (
  course TEXT REFERENCES Courses,
  requirement TEXT REFERENCES Courses,
  PRIMARY KEY (course, requirement));

-- position is the absolute position (an integer) 
--WaitingList(student, course, position) 
--    student → Students.idnr 
--    course → Limitedcourses.code
CREATE TABLE WaitingList (
  student TEXT NOT NULL,
  course TEXT NOT NULL,
  position INT NOT NULL,
  CONSTRAINT position CHECK (position >=0),
  FOREIGN KEY (student) REFERENCES Students(idnr),
  FOREIGN KEY (course) REFERENCES Limitedcourses(code),
  UNIQUE(course, position), 
  PRIMARY KEY(student, course));
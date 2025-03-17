-- This should be your trigger file for part 3

-- Registration trigger

--Be sure to check that the student may actually 
--register for the course before adding him/her to the course or the waiting list, if it may not you should raise an error 


-- NOW put the student in a waiting list if the course is full
CREATE FUNCTION CourseRegistration()
RETURNS TRIGGER AS $$
DECLARE

BEGIN
    IF EXISTS (SELECT * FROM Registrations WHERE student = NEW.student AND course = NEW.course) THEN 
        RAISE EXCEPTION 'Failure: Already registered or in waiting list';

    ELSIF EXISTS(SELECT * FROM Taken WHERE student = NEW.student AND course = NEW.course AND grade IN ('3','4','5')) THEN 
        RAISE EXCEPTION 'Failure: Student has passed course';

    ELSIF EXISTS(
        (SELECT requirement FROM Prerequisites WHERE course = NEW.course)  
        EXCEPT 
        (SELECT Taken.course 
        FROM Prerequisites JOIN Taken
        ON Prerequisites.requirement = Taken.course
        WHERE NEW.course = Prerequisites.course AND NEW.student = Taken.student AND grade <> 'U')) THEN 
            RAISE EXCEPTION 'Failure: Student has not passed all the prerequisite courses';

    ELSIF((SELECT capacity FROM LimitedCourses WHERE code = NEW.course) <= 
        (SELECT COUNT(student) FROM Registered WHERE course = NEW.course)) THEN 
            INSERT INTO WaitingList VALUES (NEW.student, NEW.course, COALESCE((1+(SELECT MAX(position) FROM WaitingList WHERE NEW.course = course)), 1));

    ELSE
        INSERT INTO Registered VALUES (NEW.student, NEW.course);
    END IF;
REFRESH MATERIALIZED VIEW UnregOfStudents;    
RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER reg_of_students
INSTEAD OF INSERT ON Registrations
FOR EACH ROW
EXECUTE FUNCTION CourseRegistration();


CREATE FUNCTION CourseUnregistartion()
RETURNS TRIGGER AS $$
DECLARE
pos INT;

BEGIN
    IF EXISTS(SELECT student FROM Registered WHERE student = OLD.student AND course = OLD.course) THEN  
        DELETE FROM Registered WHERE student=OLD.student AND course=OLD.course;

        IF EXISTS (SELECT * FROM LimitedCourses WHERE code = OLD.course) THEN
                
            IF (((SELECT capacity FROM LimitedCourses WHERE code = OLD.course) - (SELECT COUNT(student) FROM Registered WHERE course=OLD.course)) >= 1 
            AND (SELECT COUNT(student) FROM WaitingList WHERE course = OLD.course) > 0) THEN
                INSERT INTO Registered VALUES ((SELECT student FROM WaitingList WHERE course = OLD.course AND position=1), OLD.course);
                DELETE FROM WaitingList WHERE student=(SELECT student FROM WaitingList WHERE course = OLD.course AND position=1) AND course=OLD.course;

                -- update position    
                UPDATE WaitingList
                SET position = position - 1
                WHERE course=OLD.course;
            END IF;

        END IF;

    ELSIF EXISTS (SELECT student FROM WaitingList WHERE student = OLD.student AND course = OLD.course)
        THEN pos = (SELECT position FROM WaitingList WHERE student = OLD.student AND course = OLD.course);
        DELETE FROM WaitingList WHERE student=OLD.student AND course=OLD.course;
        
        -- update position
        UPDATE WaitingList
        SET position = position - 1
        WHERE position > pos AND course=OLD.course; 

    --ELSE
    --    RAISE EXCEPTION 'Failure: Student is not registered or waiting in the selected course';
    
    END IF;
RETURN OLD;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER unreg_of_students
INSTEAD OF DELETE ON Registrations
FOR EACH ROW
EXECUTE FUNCTION CourseUnregistartion();

--CREATE FUNCTION not_registered()
--RETURNS TRIGGER AS $$
/*
BEGIN
    IF NOT EXISTS((SELECT * FROM UnregOfStudents)
    EXCEPT 
    (SELECT * FROM Registrations)) THEN  
        RAISE EXCEPTION 'Failure: Not registered or in waiting list';
    END IF;
REFRESH MATERIALIZED VIEW UnregOfStudents;
RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER check_for_no_unreg_of_students
AFTER DELETE ON Registrations
FOR EACH STATEMENT
EXECUTE FUNCTION not_registered();
*/
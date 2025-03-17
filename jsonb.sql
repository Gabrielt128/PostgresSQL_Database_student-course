SELECT jsonb_build_object(
                    'student', s.idnr
                    ,'name', s.name
                    ,'login', s.login
                    ,'branch', s.branch
                    ,'finished', jsonb_agg(COALESCE((jsonb_build_array(
                                        'course', d.coursename
                                        ,'code', d.course
                                        ,'credits', d.credits
                                        ,'grade', d.grade
                                        ) :: TEXT
                                        FROM FinishedCourses AS d
                                        WHERE d.student = '4444444444'),'[]')) --AS finished
                    ,'registered', jsonb_agg(COALESCE((SELECT jsonb_build_array(
                                        'course', c.name
                                        ,'code', f.course
                                        ,'status', f.status
                                        ,'position', w.position
                                        ) :: TEXT
                                        FROM Registrations AS f
                                        JOIN Courses AS c
                                        ON f.course = c.code
                                        LEFT JOIN WaitingList as w
                                        ON f.student = w.student
                                        WHERE f.student = '4444444444'),'[]'))
                    ,'seminarCourses', p.seminarcourses
                    ,'mathCredits', p.mathcredits
                    ,'totalCredits', p.totalcredits
                    ,'canGraduate', p.qualified
                ) :: TEXT
                FROM BasicInformation AS s
                LEFT JOIN PathToGraduation AS p
                ON s.idnr = p.student
                WHERE s.idnr = '4444444444';
 
-- --FinishedCourses
-- SELECT jsonb_build_array(
--                     'course', d.coursename
--                     ,'code', d.course
--                     ,'credits', d.credits
--                     ,'grade', d.grade
--                 ) :: TEXT
--                 FROM FinishedCourses AS d
--                 WHERE d.student = '4444444444';

-- --registered student, course, 'registered' AS status
-- SELECT jsonb_build_array(
--                     'course', c.name
--                     ,'code', f.course
--                     ,'status', f.status
--                     ,'position', w.position
--                 ) :: TEXT
--                 FROM Registrations AS f
--                 JOIN Courses AS c
--                 ON f.course = c.code
--                 LEFT JOIN WaitingList as w
--                 ON f.student = w.student
--                 WHERE f.student = '4444444444';

-- --SELECT josn_agg(a,b,c)
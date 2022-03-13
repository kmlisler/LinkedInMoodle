
SELECT name, description FROM tbl_group

SELECT branch FROM tbl_teacher

SELECT name FROM tbl_faculty


SELECT fname , lname, bday FROM tbl_person
WHERE bday >
(SELECT bday FROM tbl_personWHERE fname='Ege' AND lname='Kubilay')



SELECT name 
FROM tbl_course C 
INNER JOIN tbl_enrolls E ON C.course_id = E.course_id 
WHERE student_id = 1;

SELECT fname 
FROM tbl_person
WHERE address_id =
(SELECT address_id 
FROM tbl_address
WHERE Country='Turkey' AND (City='Ankara' OR City='Bursa'))

SELECT gpa, fname, lname 
FROM tbl_person 
INNER JOIN tbl_student ON person_id = student_id

SELECT country, city ,street, name
FROM tbl_department D
INNER JOIN tbl_address A ON D.address_id = A.address_id

SELECT D.name , C.name
FROM tbl_course C
INNER JOIN tbl_department D ON dep_id = dept_id



SELECT grade 
FROM tbl_project P  
INNER JOIN  tbl_course C ON P.course_id = C.course_id 
INNER JOIN tbl_enrolls E ON P.course_id = E.course_id 
WHERE student_id =1

SELECT fname, lname , W.grade 
FROM tbl_person P
INNER JOIN tbl_student ON student_id = person_id
INNER JOIN tbl_works_on W ON W.student_id = P.person_id

SELECT fname, lname, context
FROM tbl_person

INNER JOIN tbl_references
ON referenced_person_id =person_id
INNER JOIN tbl_student ON student_id = person_id
WHERE gpa>3.0


SELECT fname, lname
FROM tbl_person
WHERE EXISTS( 
SELECT * FROM tbl_educates_in EI 
INNER JOIN tbl_person P ON EI.person_id = P.person_id
INNER JOIN tbl_graduate_level G ON EI.grad_id = G.grad_id 
WHERE name= 'Associate Degree' )

SELECT fname,lname
FROM tbl_person
WHERE person_id=
 (SELECT teacher_id FROM tbl_teacher 
WHERE dept_id=  (SELECT dept_id
FROM tbl_department WHERE name = 'Computer Science' ))

SELECT fname, lname ,E.grade 
FROM tbl_enrolls E 
INNER JOIN tbl_student S ON E.student_id = S.student_id 
INNER JOIN tbl_person  ON person_id = S.student_id 
INNER JOIN tbl_course C on E.course_id = C.course_id 
INNER JOIN tbl_teaches T ON T.course_id = C.course_id 
WHERE teacher_id=7 AND E.semester='winter 2019-2020' AND E.semester = T.semester;

SELECT fname, lname FROM tbl_person 
WHERE person_id IN
(SELECT student_id FROM tbl_student 
UNION 
SELECT member_id FROM tbl_member)

SELECT fname, lname, branch, name
FROM tbl_teacher T
INNER JOIN tbl_person ON teacher_id = person_id
INNER JOIN tbl_department D ON T.dept_id = D.dept_id

SELECT C.name 
FROM tbl_course C 
INNER JOIN tbl_department D ON C.dep_id = D.dept_id 
INNER JOIN tbl_teaches T ON T.course_id = C.course_id 
WHERE teacher_id = 7 AND semester='winter 2019-2020';

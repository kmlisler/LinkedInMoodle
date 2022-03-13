CREATE  TABLE tbl_skill (
skill_id SERIAL PRIMARY KEY,
name TEXT NOT NULL UNIQUE,
category TEXT NOT NULL,
CHECK(category IN ('Software', 'FineArts', 'Science','Sports'))
);
Create TABLE tbl_address(
address_id SERIAL PRIMARY KEY,
country TEXT NOT NULL,
city TEXT NOT NULL,
street TEXT NOT NULL,
UNIQUE(country, city, street)
);
CREATE TABLE tbl_organization(
org_id SERIAL PRIMARY KEY,
name TEXT NOT NULL UNIQUE,
phone VARCHAR(11) NOT NULL,
mail TEXT NOT NULL UNIQUE,
type VARCHAR(3) NOT NULL,
CHECK( type IN ('CMP','UNI'))
);

CREATE FUNCTION get_type(data_id INT)
RETURNS VARCHAR(3)
AS $$
BEGIN
RETURN (SELECT type FROM tbl_organization WHERE org_id = data_id);
END; $$
LANGUAGE PLPGSQL;

CREATE FUNCTION assert_is_teacher(data_id INT)
RETURNS VARCHAR(5)
AS $$
BEGIN
IF ( SELECT EXISTS (SELECT 1 FROM tbl_teacher WHERE teacher_id = data_id)) THEN
RETURN 'True';
ELSE
RETURN 'False';
END IF;
END; $$
LANGUAGE PLPGSQL;

CREATE FUNCTION assert_is_student(data_id INT)
RETURNS VARCHAR(5)
AS $$
BEGIN
IF ( SELECT EXISTS (SELECT 1 FROM tbl_student WHERE student_id = data_id)) THEN
RETURN 'True';
ELSE
RETURN 'False';
END IF;
END; $$
LANGUAGE PLPGSQL;

CREATE FUNCTION assert_is_member(data_id INT)
RETURNS VARCHAR(5)
AS $$
BEGIN
IF ( SELECT EXISTS (SELECT 1 FROM tbl_member WHERE member_id = data_id)) THEN
RETURN 'True';
ELSE
RETURN 'False';
END IF;
END; $$
LANGUAGE PLPGSQL;
CREATE TABLE tbl_office(
office_id SERIAL PRIMARY KEY,
name TEXT NOT NULL,
org_id INTEGER NOT NULL REFERENCES tbl_organization(org_id) ON DELETE CASCADE,
address_id INTEGER NOT NULL REFERENCES tbl_address(address_id) ON DELETE CASCADE,
CHECK( 'CMP' = get_type(org_id)),
UNIQUE(org_id ,name, address_id)
);
CREATE TABLE tbl_job_offer(
offer_id SERIAL PRIMARY KEY,
job_title TEXT NOT NULL,
description TEXT NOT NULL,
address_id INTEGER NOT NULL REFERENCES tbl_address(address_id) ON DELETE CASCADE,
office_id INT NOT NULL REFERENCES tbl_office(office_id) ON DELETE CASCADE,
UNIQUE (job_title, address_id, office_id)
);
CREATE TABLE tbl_faculty(
faculty_id SERIAL PRIMARY KEY,
name TEXT NOT NULL,
org_id INTEGER NOT NULL REFERENCES tbl_organization(org_id) ON DELETE CASCADE,
CHECK( 'UNI' = get_type(org_id)),
UNIQUE (org_id , name)
);
CREATE TABLE tbl_department(
dept_id SERIAL PRIMARY KEY,
name TEXT NOT NULL,
faculty_id INT NOT NULL REFERENCES tbl_faculty(faculty_id) ON DELETE CASCADE,
address_id INTEGER NOT NULL REFERENCES tbl_address(address_id) ON DELETE CASCADE,
UNIQUE (dept_id , name)
);
CREATE TABLE tbl_graduate_level(
grad_id SERIAL PRIMARY KEY,
name TEXT NOT NULL,
dept_id INT NOT NULL REFERENCES tbl_department(dept_id) ON DELETE CASCADE,
UNIQUE (grad_id , name)
);
CREATE TABLE tbl_person(
person_id SERIAL PRIMARY KEY,
fname TEXT NOT NULL,
lname TEXT NOT NULL,
phone VARCHAR(11),
mail TEXT NOT NULL UNIQUE,
bday DATE NOT NULL,
address_id INTEGER NOT NULL REFERENCES tbl_address(address_id) ON DELETE CASCADE
);
CREATE TABLE tbl_teacher(
teacher_id INT NOT NULL UNIQUE REFERENCES tbl_person(person_id) ON DELETE CASCADE,
branch TEXT,
dept_id INT NOT NULL REFERENCES tbl_department(dept_id) ON DELETE CASCADE
);
CREATE TABLE tbl_student(
student_id INT NOT NULL UNIQUE REFERENCES tbl_person(person_id) ON DELETE CASCADE,
gpa FLOAT,
grade varchar(1) NOT NULL,
CHECK( grade IN ('1', '2', '3', '4')),
CHECK( gpa = null OR  ( 0<= gpa AND gpa <= 4.0) )
);
CREATE TABLE tbl_member(
member_id INT UNIQUE REFERENCES tbl_person(person_id) ON DELETE CASCADE,
password TEXT NOT NULL,
CHECK( char_length(password)>=8 )
);
CREATE TABLE tbl_file(
file_id SERIAL PRIMARY KEY,
name TEXT NOT NULL,
privacy  BOOLEAN DEFAULT TRUE,
person_id INTEGER NOT NULL REFERENCES tbl_person(person_id) ON DELETE CASCADE,
CHECK( 'True' = assert_is_student(person_id) OR 'True' = assert_is_teacher(person_id)),
UNIQUE(person_id, name)
);
CREATE TABLE tbl_course(
course_id SERIAL PRIMARY KEY,
name TEXT NOT NULL,
code TEXT NOT NULL,
credit INTEGER NOT NULL,
dept_id INT NOT NULL REFERENCES tbl_department(dept_id) ON DELETE CASCADE,
CHECK(0<credit AND credit<9)
);
CREATE TABLE tbl_project(
project_id SERIAL PRIMARY KEY,
title TEXT NOT NULL,
description TEXT NOT NULL,
course_id INTEGER NOT NULL REFERENCES tbl_course(course_id) ON DELETE CASCADE,
UNIQUE(course_id , title)
);
CREATE TABLE tbl_group(
group_id SERIAL PRIMARY KEY,
name TEXT NOT NULL UNIQUE,
description TEXT NOT NULL,
member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE
);
CREATE TABLE tbl_educates_in(
start_date DATE NOT NULL,
end_date DATE,
gpa FLOAT,
grad_id INT NOT NULL REFERENCES tbl_graduate_level(grad_id) ON DELETE CASCADE,
person_id INT NOT NULL REFERENCES tbl_person(person_id) ON DELETE CASCADE,
CHECK(gpa = null OR ( 0<= gpa AND gpa <= 4.0)),
CHECK( start_date < end_date ),
UNIQUE(grad_id , person_id)
);
CREATE TABLE tbl_references(
teacher_id INTEGER NOT NULL REFERENCES tbl_teacher(teacher_id) ON DELETE CASCADE,
referenced_person_id INTEGER NOT NULL REFERENCES tbl_person(person_id) ON DELETE CASCADE,
date DATE NOT NULL,
context TEXT NOT NULL,
CHECK(teacher_id != referenced_person_id),
UNIQUE(teacher_id ,referenced_person_id, date)
);
CREATE TABLE tbl_knows(
person_id INT REFERENCES tbl_person(person_id) ON DELETE CASCADE,
skill_id INT REFERENCES tbl_skill(skill_id) ON DELETE CASCADE,
UNIQUE(person_id , skill_id)
);

CREATE TABLE tbl_teaches(
teacher_id INTEGER NOT NULL REFERENCES tbl_teacher(teacher_id) ON DELETE CASCADE, 
course_id INTEGER NOT NULL REFERENCES tbl_course(course_id)  ON DELETE CASCADE,
semester TEXT NOT NULL,
UNIQUE(teacher_id, course_id, semester)
);
CREATE TABLE tbl_messages(
from_person_id INT NOT NULL REFERENCES tbl_person(person_id),
to_person_id INT NOT NULL REFERENCES tbl_person(person_id),
title TEXT,
context TEXT,
date DATE NOT NULL,
CHECK( ('True' = assert_is_student(to_person_id) OR 'True' = assert_is_teacher(from_person_id)) OR
( ('True' = assert_is_student(from_person_id) OR 'True' = assert_is_teacher(to_person_id))),
CHECK(from_person_id != tpo_person_id)
);
CREATE TABLE tbl_works_on(
student_id INTEGER NOT NULL REFERENCES tbl_student(student_id)  ON DELETE CASCADE,
project_id INTEGER NOT NULL REFERENCES tbl_project(project_id)  ON DELETE CASCADE,
grade INT,
semester TEXT NOT NULL,
UNIQUE(student_id, project_id, semester),
CHECK( grade = null OR ( 0<= grade AND grade<= 100))
);

CREATE TABLE tbl_recommends(
member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE,
recommended_member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE,
date DATE NOT NULL,
context TEXT NOT NULL,
CHECK(member_id != recommended_member_id),
UNIQUE(member_id, recommended_member_id, context )
);

CREATE TABLE tbl_follows(
member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE,
org_id INTEGER NOT NULL REFERENCES tbl_organization(org_id) ON DELETE CASCADE,
CHECK( 'CMP' = get_type(org_id)),
UNIQUE(member_id , org_id)
);

CREATE TABLE tbl_enrolls(
student_id INT NOT NULL REFERENCES tbl_student(student_id) ON DELETE CASCADE,
course_id INT NOT NULL REFERENCES tbl_course(course_id) ON DELETE CASCADE,
semester TEXT NOT NULL,
grade FLOAT,
CHECK (grade = null OR ( 0<= grade AND grade <= 4.0)),
UNIQUE(student_id, course_id ,semester)
);


CREATE TABLE tbl_works_for(
member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE,
start_date DATE NOT NULL,
end_date DATE,
job_title TEXT NOT NULL,
office_id INT NOT NULL REFERENCES tbl_office(office_id) ON DELETE CASCADE,
CHECK( start_date < end_date )
);

CREATE TABLE tbl_applies(
member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE,
date DATE NOT NULL,
status TEXT DEFAULT 'NOTEXAMINED',
offer_id INT NOT NULL REFERENCES tbl_job_offer(offer_id) ON DELETE CASCADE,
CHECK(status IN ('NOTEXAMINED', 'REJECTED', 'ACCEPTED')),
UNIQUE(offer_id , member_id)
);

CREATE TABLE tbl_joins(
member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE,
group_id INTEGER NOT NULL REFERENCES tbl_group(group_id) ON DELETE CASCADE,
UNIQUE(member_id, group_id)
);

CREATE TABLE tbl_connects(
member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE,
connected_member_id INTEGER NOT NULL REFERENCES tbl_member(member_id) ON DELETE CASCADE,
CHECK(member_id != connected_member_id),
UNIQUE(member_id,connected_member_id )
);


CREATE OR REPLACE PROCEDURE add_person_student(
	firstname text,
	lastname text,
	phone varchar(11),
	email text,
	bday DATE,
	address_id INT,
	gpa FLOAT,
	grade varchar(1))
LANGUAGE 'plpgsql'

AS $$
BEGIN

   WITH new_student as (
            INSERT INTO public.tbl_person(fname, lname, phone, mail, bday, address_id)
            VALUES ( firstname, lastname, phone, email, bday, address_id) returning person_id )
            INSERT INTO tbl_student(student_id, gpa, grade) SELECT person_id,gpa, grade FROM new_student ;
    COMMIT;
END;
$$;

CREATE OR REPLACE PROCEDURE add_person_member(
	firstname text,
	lastname text,
	phone varchar(11),
	email text,
	bday DATE,
	address_id INT,
	password TEXT)
LANGUAGE 'plpgsql'

AS $$
BEGIN

   WITH new_member as (
           INSERT INTO public.tbl_person(fname, lname, phone, mail, bday, address_id)
            VALUES ( firstname, lastname, phone, email, bday, address_id) returning person_id )
            INSERT INTO tbl_member(member_id, password) SELECT person_id ,password FROM new_member;
    COMMIT;
END;
$$;

CREATE OR REPLACE PROCEDURE add_person_teacher(
	firstname text,
	lastname text,
	phone varchar(11),
	email text,
	bday DATE,
	address_id INT,
	branch TEXT,
	dept_id)
LANGUAGE 'plpgsql'

AS $$
BEGIN

   WITH new_teacher as (
          INSERT INTO public.tbl_person(fname, lname, phone, mail, bday, address_id)
            VALUES ( firstname, lastname, phone, email, bday, address_id) returning person_id )
            INSERT INTO tbl_teacher(teacher_id, branch, dept_id) SELECT person_id , branch , dept_id FROM new_teacher ;
 
    COMMIT;
END;
$$;

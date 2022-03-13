INSERT INTO public.tbl_skill(
	 name, category)
	VALUES ( '3D art skills', 'FineArts'),
		( 'Quantum Phsyics knowledge', 'Science'),
		( 'Python knowledge', 'Software');

INSERT INTO public.tbl_address(
	 country, city, street)
	VALUES ( 'Turkey', 'Istanbul', 'Cumhuriyet Street'),
		( 'Turkey', 'Bursa', 'Zafer Street'),
		( 'Turkey', 'Izmir', 'Sencer Street'),
		( 'Turkey', 'Izmir', 'Ataturk Street');

INSERT INTO public.tbl_organization(
	 name, phone, mail, type)
	VALUES ( 'Ege Üniversitesi', 2323881032, 'webadmin@ege.edu.tr', 'UNI'),
		('9 Eylül Üniversitesi', 2324121212, 'egitim@deu.edu.tr', 'UNI'),
		('Ege Profil', 2323989898, 'info@egeprofil.com.tr', 'CMP'),
		('İzmir Yazilim', 2323453190, 'info@izmiryazilim.com.tr', 'CMP');

INSERT INTO public.tbl_office(
	 name, org_id, address_id)
	VALUES ('IT', 3,2),
		('Frontend', 4,1),
		('R&D', 3,2);

INSERT INTO public.tbl_job_offer(
	 job_title, description, address_id, office_id)
	VALUES ( 'Frontend Developer', 'Frontend developer for developing demanding webpages',1	,2),
		('IT technician', 'IT technician to maintain the computer networks and providing tech support', 2, 1),
		('R&D Leader', 'R&D Leader to steer a engineer team to develop new products', 2, 3);

INSERT INTO public.tbl_faculty(
	 name, org_id)
	VALUES ( 'Engineering',1),
		('Science',1),
		('Fine Arts',2),
		('Pharmacy',2);

INSERT INTO public.tbl_department(
	 name, faculty_id, address_id)
	VALUES ( 'Computer Science'		,1	,3),
		('Biochemistry'			,2	,4),
		('Statue'			,3	,3),
		('Pharmaseutical Technologies'	,4	,4);

INSERT INTO public.tbl_graduate_level(
	 name, dept_id)
	VALUES ( 'Bachelors Degree'	,1),
		('Associate Degree'	,2),
		('Masters Degree'	,3),
		('Doctoral degree'	,4);



CALL add_person_student('Deniz',	'Yurekdeler',	'05544413061',	'dyurekdeler@gmail.com'	,	'1997-07-03',	1, 3.6, '4')
CALL add_person_student('Cem',		'Corbacioglu',	'05544413061',	'cemcorbacioglu@gmail.com',	'1995-01-06',	2, 3.5 , '4')
CALL add_person_student('Aybars',	'Kokce'	,	'05544413061',	'akokce@hotmail.com',		'1993-11-09',	3, 1.9, '3' )
CALL add_person_member('Ege',		'Kubilay',	'05544413061',	'ekubilay@gmail.com',		'1990-02-05',	3, '12345678')
CALL add_person_member('Melisa',	'Erdem'	,	'05544413061',	'merdem@aol.com',		'1985-01-02',	2, '12345678')
CALL add_person_member('Hakan',	'Atilgan',	'05544413061' ,	'hatilgan@hotmail.com'	,	'1992-11-10',	3,'12345678')
CALL add_person_teacher('Ahmet',	'Atakus',	'05544413061',	'ahmetatakus@hotmail.com',	'1980-05-07',	3, 'Linguistic', 1)
CALL add_person_teacher('Bilge',	'Usak'	,	'05544413061',	'bilgeusak@hotmail.com'	,	'1994-10-11',	3, 'Object Oriented' ,2)


INSERT INTO public.tbl_course(
	 name, code, credit, dep_id)
	VALUES ( 'Algorithms', 'BIL115115', 7, 1),
		( 'Carving', 'STA223344', 6, 3),
		( 'Organic modeling', 'BIO11345', 5, 2);

INSERT INTO public.tbl_project(
	 title, description, course_id)
	VALUES ( 'Sorting algorithm project', 'describe each algorithms characteristics', 1),
		( 'Organical modeling examples project', 'draw 10 organical compunds model', 3);

INSERT INTO public.tbl_educates_in(
	start_date, end_date, gpa, grad_id, person_id)
	VALUES ('2013-11-07', '2017-07-07', 2.9, 1, 1),
		('2015-11-05', '2017-07-07', 2.9, 4, 2),
		('2016-11-03', '2018-08-08', 2.9, 3, 3);

INSERT INTO public.tbl_references(
	teacher_id, referenced_person_id, date, context)
	VALUES (4, 1, '2019-12-12', 'Bright kid'),
		(4, 2, '2020-01-01', 'Best in her class');
INSERT INTO tbl_messages(from_person_id, to_person_id, title, context, date) VALUES 
(1,3,’Sınav Saati Hk.’, ‘Sınav saati ne zaman?’,’01.01.2020’),
(4,2,’Ders Programı’, ‘Ders programında Salı günü hangi ders var?’);

INSERT INTO public.tbl_knows(
	person_id, skill_id)
	VALUES (1, 3),
		(2, 3),
		(4, 2);

INSERT INTO public.tbl_teaches(
	teacher_id, course_id, semester)
	VALUES (4, 1, 'winter'),
		(5, 2,'winter'),
		(3, 3, 'spring');

INSERT INTO public.tbl_works_on(
	student_id, project_id, grade, semester)
	VALUES (1, 1, '40' ,'spring'),
		(2, 1, '50', 'spring');

INSERT INTO public.tbl_enrolls(
	student_id, course_id, semester, grade)
	VALUES (1, 1, 'spring', 1.9),
		(2, 1, 'spring', 1.9);

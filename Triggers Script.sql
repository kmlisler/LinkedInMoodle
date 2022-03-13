CREATE OR REPLACE FUNCTION add_active_student()
  RETURNS trigger AS
$$
BEGIN
IF NEW.end_date = Null  AND assert_is_student = 'False' THEN
         INSERT INTO tbl_student(student_id,gpa,grade)
         VALUES(NEW.person_id,NEW.gpa,'1');

END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER add_active_student_trigger
  AFTER INSERT
  ON tbl_educates_in
  FOR EACH ROW
  EXECUTE PROCEDURE add_active_student();



CREATE OR REPLACE FUNCTION init_employment()
  RETURNS trigger AS
$$
BEGIN
IF NEW.status = 'ACCEPTED' THEN
      WITH new_worksfor as (
		SELECT job_title, member_id, office_id  FROM tbl_job_offer , NEW WHERE offer_id  = NEW.offer_id )
		INSERT INTO tbl_works_for(member_id,  job_title, office_id, start_date) 
		SELECT member_id,job_title, office_id FROM  new_worksfor, current.date;

END IF;
END;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER init_employment_trigger
  AFTER INSERT OR UPDATE
  ON tbl_applies
  FOR EACH ROW
  EXECUTE PROCEDURE init_employment();


CREATE OR REPLACE FUNCTION remove_student()
  RETURNS trigger AS
$$
BEGIN
IF NEW.end_date != Null THEN
         DELETE FROM tbl_student WHERE student_id = OLD.student_id;

END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER remove_student_trigger
  AFTER UPDATE
  ON tbl_educates_in
  FOR EACH ROW
  EXECUTE PROCEDURE remove_student();


CREATE OR REPLACE FUNCTION auto_join_group()
  RETURNS trigger AS
$$
BEGIN

    INSERT INTO tbl_joins(member_id, group_id) VALUES ( NEW.member_id, NEW.group_id);

END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER auto_join_group_trigger
  AFTER INSERT
  ON tbl_group
  FOR EACH ROW
  EXECUTE PROCEDURE auto_join_group();

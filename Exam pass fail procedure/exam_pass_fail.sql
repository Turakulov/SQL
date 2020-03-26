CREATE TABLE exams
(
	student_id    number(4)  NOT NULL,
	test_id       number(4)  NOT NULL,	
	grade_id      number(4)  NOT NULL,
	period_id     number(4)  NOT NULL,
	test_date     DATE       NOT NULL,
	pass_fail     number(1)  NOT NULL
);

alter session set NLS_DATE_LANGUAGE='AMERICAN';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';


Insert into exams values(1, 1, 2, 1, '01-FEB-2015',0);
Insert into exams values(1, 2, 2, 1, '01-MAR-2015',1);
Insert into exams values(1, 3, 2, 1, '01-APR-2015',0);
Insert into exams values(1, 4, 2, 2, '01-MAY-2015',0);
Insert into exams values(1, 5, 2, 2, '01-JUN-2015',0);
Insert into exams values(1, 6, 2, 2, '01-JUL-2015',0);

CREATE OR REPLACE PROCEDURE testtask
IS
	sum_pass_fail   NUMBER(2); -- ну все же 10 экзов это перебор. хотя...)
	max_date        DATE;
	requirement     CHAR(1);
	sql_stmt        VARCHAR2(200);

BEGIN
	EXECUTE IMMEDIATE 'drop table dataout';
	sql_stmt := 'CREATE TABLE dataout AS SELECT * FROM exams WHERE 1=0';
	EXECUTE IMMEDIATE sql_stmt;
	sql_stmt := 'ALTER TABLE dataout DROP COLUMN pass_fail';
	EXECUTE IMMEDIATE sql_stmt;
	sql_stmt := 'ALTER TABLE dataout ADD (met_requirement CHAR(1), in_progress NUMBER(1))';
	EXECUTE IMMEDIATE sql_stmt;

	FOR cursor_student_id IN  -- для каждого из студентов
		(SELECT DISTINCT student_id FROM exams)
	LOOP
		FOR cursor_period_id IN  -- для каждого из периодов для определенного студента
			(SELECT DISTINCT period_id FROM exams WHERE exams.student_id = cursor_student_id.student_id)
		LOOP
			SELECT SUM(pass_fail) INTO sum_pass_fail FROM exams WHERE exams.student_id = cursor_student_id.student_id AND exams.period_id = cursor_period_id.period_id;
			SELECT MAX(test_date) INTO max_date FROM exams WHERE exams.student_id = cursor_student_id.student_id AND exams.period_id = cursor_period_id.period_id;
			
			IF (sum_pass_fail = 0)
				THEN requirement := '-';
			ELSE
				requirement := '+';	
			END IF;
			FOR cursor_datain_line IN  -- для строк с определенным студентом и периодом
				(SELECT student_id, test_id, grade_id, period_id, test_date FROM exams 
				WHERE exams.student_id = cursor_student_id.student_id AND exams.period_id = cursor_period_id.period_id)
			LOOP
				sql_stmt := 'INSERT INTO dataout (student_id, test_id, grade_id, period_id, test_date, met_requirement,in_progress)
				       VALUES (:1, :2, :3, :4, :5, :6, :7)';
				EXECUTE IMMEDIATE sql_stmt USING cursor_datain_line.student_id, cursor_datain_line.test_id, cursor_datain_line.grade_id,cursor_datain_line.period_id, cursor_datain_line.test_date, requirement, 0; 

			END LOOP;
			FOR cursor_date IN  -- для строк с полностью несданными предметами
				(SELECT max(test_date) as max_test_date FROM exams 
				WHERE exams.student_id = cursor_student_id.student_id AND exams.period_id = cursor_period_id.period_id)
			LOOP
			IF (cursor_date.max_test_date = max_date)
				THEN 
				sql_stmt := 'UPDATE dataout SET in_progress = 1 where met_requirement = :1 and test_date = :2 and period_id = :1';
				EXECUTE IMMEDIATE sql_stmt USING '-', cursor_date.max_test_date,cursor_period_id.period_id;
			END IF;
			END LOOP;

		END LOOP;
	END LOOP;
EXCEPTION   -- начало обработчика исключений 
	WHEN NO_DATA_FOUND THEN  
		DBMS_OUTPUT.PUT_LINE('Не найдено ни одной строки в таблице');
	WHEN others THEN null;
END;
/


Insert into exams values(4, 1, 2, 3, '01-FEB-2015',0);
Insert into exams values(1, 2, 2, 1, '01-MAR-2015',0);
Insert into exams values(1, 3, 2, 1, '01-APR-2015',0);
Insert into exams values(2, 4, 2, 2, '01-MAY-2015',1);
Insert into exams values(3, 5, 2, 2, '01-JUN-2015',1);
Insert into exams values(3, 6, 2, 2, '01-JUL-2015',0);

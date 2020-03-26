CONN system/admin;

-- однострочные комментарии в Oracle начинаются с "--". многострочные заключаются в "/* */"

/*
форматирование вывода в БД (длины строки в символах и длины страницы в строках) выполняется командами
	set linesize длина_строки;
	set pagesize количество_строк;
*/

/*
Изменение формата времени системы
От имени system или sys
*/
	CREATE OR REPLACE
		TRIGGER on_login_trigger
	AFTER
		LOGON ON DATABASE
	BEGIN
		EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD.MM.YYYY HH24:MI:SS''';
	END on_login_trigger;

-- для работы необходимо создать пользователя. это делается от имени администратора БД (system или sys);


CREATE USER rfid IDENTIFIED BY 19230
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

GRANT CONNECT TO rfid;
GRANT ALL PRIVILEGES TO rfid;
DISC;


CONN rfid/19230;

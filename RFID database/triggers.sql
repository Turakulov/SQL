--Тригеры на DELETE
_____________________________________

/*
Триггер – это именованный pl/sql блок, который хранится в базе данных.
Он всегда срабатывает только на определенное событие автоматически, например на удаление, изменение таблицы
*/

--Триггер, заносящий данные в архивные таблицы a_closets

CREATE OR REPLACE
	TRIGGER trigger_on_delete_closets
AFTER DELETE ON
	closets
	FOR EACH ROW
BEGIN
	INSERT INTO a_closets 
	VALUES 
	(:old.c_id,
	 :old.c_cells,
         :old.c_bld,
         :old.c_floor,
         :old.c_desc);
END;
_____________________________________
--Триггер, заносящий данные в архивные таблицы a_cells

CREATE OR REPLACE
	TRIGGER trigger_on_delete_cells
AFTER DELETE ON
	cells
	FOR EACH ROW
BEGIN
	INSERT INTO a_cells
	VALUES 
	(:old.cs_num,
	 :old.cs_type,
         :old.cs_closet,
         :old.cs_currval,
         :old.cs_maxval);
END;
_____________________________________
--Триггер, заносящий данные в архивные таблицы a_types

CREATE OR REPLACE
	TRIGGER trigger_on_delete_types
AFTER DELETE ON
	types
	FOR EACH ROW
BEGIN
	INSERT INTO a_types
	VALUES 
	(:old.t_name);
END;

_____________________________________
--Триггер, заносящий данные в архивные таблицы a_buildings

CREATE OR REPLACE
	TRIGGER trigger_on_delete_buildings
AFTER DELETE ON
	buildings
	FOR EACH ROW
BEGIN
	INSERT INTO a_buildings
	VALUES 
	(:old.bld_id,
         :old.bld_section,
         :old.bld_name);
END;

_____________________________________
--Триггер, заносящий данные в архивные таблицы a_mvalues

CREATE OR REPLACE
	TRIGGER trigger_on_delete_mvalues
AFTER DELETE ON
	mvalues
	FOR EACH ROW
BEGIN
	INSERT INTO a_mvalues 
	VALUES 
	(:old.mv_id,
         :old.mv_type,
	 :old.mv_closet,
         :old.mv_cell,
	 :old.mv_desc);
END;

_____________________________________
--Триггер, заносящий данные в архивные таблицы a_users

CREATE OR REPLACE
	TRIGGER trigger_on_delete_users
AFTER DELETE ON
	users
	FOR EACH ROW
BEGIN
	INSERT INTO a_users 
	VALUES 
	(:old.u_id,
	 :old.u_f,
	 :old.u_io,
         :old.u_email,
	 :old.u_code);
END;

_____________________________________
--Триггер, заносящий данные в архивные таблицы a_departments

CREATE OR REPLACE
	TRIGGER trigger_on_delete_departments
AFTER DELETE ON
	departments
	FOR EACH ROW
BEGIN
	INSERT INTO a_departments
	VALUES 
	(:old.d_code,
	 :old.d_name);
END;
_____________________________________
--Триггер, заносящий данные в архивные таблицы

CREATE OR REPLACE
	TRIGGER trigger_on_delete_tvalues
AFTER DELETE ON
	tvalues
	FOR EACH ROW
BEGIN
	INSERT INTO a_tvalues 
	VALUES 
	(:old.tv_user,
	 :old.tv_value,
	 :old.tv_take,
	 :old.tv_ret);
END;

--Cоздание таблиц
_________________________________________________________________________

-- Таблица шкафы

CREATE TABLE closets
(
	c_id       VARCHAR(10),
	c_cells    NUMBER(2)       NOT NULL,
	c_bld      NUMBER(2)       NOT NULL,	
	c_floor    NUMBER(2)       NOT NULL,
	c_desc     VARCHAR(500)    NOT NULL,
	CONSTRAINT pk_closets      PRIMARY KEY (c_id),
	CONSTRAINT fk_closets_blds FOREIGN KEY (c_bld) REFERENCES buildings (bld_id)
);

-- Таблица ячейки

CREATE TABLE cells
(
	cs_num     NUMBER(2),
	cs_type    VARCHAR(60)      NOT NULL,
	cs_closet  VARCHAR(10)      NOT NULL,
	cs_currval NUMBER(2)        NOT NULL,
	cs_maxval  NUMBER(2)        NOT NULL,
	CONSTRAINT pk_cells         PRIMARY KEY (cs_closet , cs_num),
	CONSTRAINT fk_cells_closets FOREIGN KEY (cs_closet) REFERENCES closets(c_id),
	CONSTRAINT fk_cells_types   FOREIGN KEY (cs_type)   REFERENCES types(t_name)
);

-- Справочная таблица типы для mvalues

CREATE TABLE types
(
	t_name     VARCHAR(60),
	CONSTRAINT pk_types PRIMARY KEY (t_name)
);

-- Справочная таблица корпуса для closets

CREATE TABLE buildings
(
  	bld_id      NUMBER(2),
  	bld_section VARCHAR(40)  NOT NULL,
  	bld_name    VARCHAR(80)  NOT NULL,
  	CONSTRAINT  pk_buildings PRIMARY KEY  (bld_id)
);
-- Таблица материальные вещи

CREATE TABLE mvalues
(
	mv_id      VARCHAR(14),
	mv_type	   VARCHAR(60)      NOT NULL,
	mv_closet  VARCHAR(10)      NOT NULL,
 	mv_cell    NUMBER(2)        NOT NULL,
	mv_desc    VARCHAR(500)     NOT NULL,
	CONSTRAINT pk_mvalues       PRIMARY KEY (mv_id),
	CONSTRAINT fk_mvalues_cells FOREIGN KEY (mv_closet, mv_cell) REFERENCES cells(cs_closet , cs_num),
	CONSTRAINT fk_mvalues_types FOREIGN KEY (mv_type)            REFERENCES types(t_name)
);

-- Таблица пользователи

CREATE TABLE users
(
	u_id		   VARCHAR(14),
	u_f 		   VARCHAR(60)   NOT NULL,
	u_io       VARCHAR(60)   NOT NULL,
	u_email	   VARCHAR(60)   NOT NULL,
	u_code	   VARCHAR(20)   NOT NULL,
	CONSTRAINT pk_users      PRIMARY KEY (u_id),
  CONSTRAINT fk_users_deps FOREIGN KEY (u_code) REFERENCES departments (d_code)
);

-- Справочная таблица департаментов для таблицы users

CREATE TABLE departments
(
	d_code	   VARCHAR(20),
	d_name	   VARCHAR(400) NOT NULL,
	CONSTRAINT pk_code      PRIMARY KEY (d_code)
);

-- Таблица взятые вещи

CREATE TABLE tvalues
(
	tv_user    VARCHAR(14)        NOT NULL,
	tv_value   VARCHAR(14)        NOT NULL,
	tv_take    DATE               NOT NULL,
	tv_ret     DATE,
	CONSTRAINT fk_tvalues_users   FOREIGN KEY (tv_user)  REFERENCES users   (u_id),
	CONSTRAINT fk_tvalues_mvalues FOREIGN KEY (tv_value) REFERENCES mvalues (mv_id)
);

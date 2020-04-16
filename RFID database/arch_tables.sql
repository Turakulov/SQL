--Cоздание архивных таблиц
_________________________________________________________________________

/*
Архивные таблицы нужны для своевременной выгрузки устаревших/ошибочных 
данных в резервные таблицы. Такой способ хранения данных позволяет избежать 
потерь данных и значительно ускорить доступ к основным таблицам.
*/

CREATE TABLE a_closets
(
	acl_id     VARCHAR(10),
	acl_cells  NUMBER(2)            NOT NULL,
	acl_bld    NUMBER(2)            NOT NULL,
  	acl_floor  NUMBER(2)            NOT NULL,
	acl_desc   VARCHAR(500)         NOT NULL,
  
	CONSTRAINT pk_closets           PRIMARY KEY(acl_id)
	CONSTRAINT fk_closets_buildings FOREIGN KEY(acl_bld) REFERENCES a_buildings(ab_id)

);
____________________________________
CREATE TABLE a_cells
(
	ace_num      NUMBER(2),
	ace_type     VARCHAR(60)      NOT NULL,
	ace_closet   VARCHAR(10)      NOT NULL,
	ace_currval  NUMBER(2)        NOT NULL,
	ace_maxval   NUMBER(2)        NOT NULL,
  
	CONSTRAINT   pk_cells         PRIMARY KEY (ace_closet , ace_num)
	CONSTRAINT   fk_cells_closets FOREIGN KEY (ace_closet) REFERENCES a_closets(acl_id)
	CONSTRAINT   fk_cells_types   FOREIGN KEY (ace_type)   REFERENCES a_types(at_name)
)
____________________________________

CREATE TABLE a_types
(
	at_name     VARCHAR(60)
	CONSTRAINT  pk_types PRIMARY KEY(at_name)
)

____________________________________

CREATE TABLE a_buildings
(
	ab_id       NUMBER(2),
  	ab_section  VARCHAR(40)  NOT NULL,
  	ab_name     VARCHAR(80)  NOT NULL,
  
  CONSTRAINT  pk_buildings PRIMARY KEY(ab_id)
);

____________________________________

CREATE TABLE a_mvalues
(
	amv_id       VARCHAR(14),
	amv_type     VARCHAR(60)      NOT NULL,
	amv_closet   VARCHAR(10)      NOT NULL,
  	amv_cell     NUMBER(2)        NOT NULL,
	amv_desc     VARCHAR(500)     NOT NULL,
  
	CONSTRAINT   pk_mvalues       PRIMARY KEY (amv_id),
	CONSTRAINT   fk_mvalues_cell  FOREIGN KEY (amv_closet, amv_cell) REFERENCES a_cells(ace_closet, ace_num),
	CONSTRAINT   fk_mvalues_types FOREIGN KEY (amv_type) REFERENCES a_types(at_name)
);

___________________________________

CREATE TABLE a_users
(
	au_id	   VARCHAR(14),
	au_f 	   VARCHAR(60)   NOT NULL,
	au_io      VARCHAR(60)   NOT NULL,
	au_email   VARCHAR(60)   NOT NULL,
	au_code	   VARCHAR(20)   NOT NULL,
  
	CONSTRAINT pk_users      PRIMARY KEY (au_id)
  	CONSTRAINT fk_users_deps FOREIGN KEY (au_code) REFERENCES departments(ad_code)
);

___________________________________

CREATE TABLE a_departments
(
	ad_code	   VARCHAR(20)
	ad_name	   VARCHAR(300) NOT NULL,
  
	CONSTRAINT pk_code      PRIMARY KEY (ad_code)
);

____________________________________
CREATE TABLE a_tvalues
(
	atv_user   VARCHAR(14)        NOT NULL,
	atv_value  VARCHAR(14)        NOT NULL,
	atv_take   DATE               NOT NULL,
	atv_ret    DATE,
  
	CONSTRAINT fk_tvalues_users   FOREIGN KEY(atv_user)  REFERENCES a_users   (au_id),
	CONSTRAINT fk_tvalues_mvalues FOREIGN KEY(atv_value) REFERENCES a_mvalues (amv_id)
);

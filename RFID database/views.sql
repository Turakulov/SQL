--Cоздание представлений
_________________________________________________________________________

/*
Представление (view), или виртуальная таблица в базе данных Oracle — это 
специфический образ таблицы или набора таблиц, определенный оператором SELECT. 
Представление не существует физически как обычная таблица, являющаяся частью 
табличного пространства.Фактически представление создает виртуальную таблицу 
или подтаблицу только с теми строками и/или столбцами, которые нужно показать 
пользователю.
*/

-- Представление о всех взятых вещах всеми пользователями за всё время

CREATE OR REPLACE VIEW
	tvview
AS SELECT
	u.u_id as tvv_uid, u.u_f as tvv_uf, u.u_io as tvv_uio, u.u_emailt as tvv_email,
	mv.mv_id as tvv_mvid, mv.mv_type as tvv_mvtype, mv.mv_desc as tvv_mvdesc,
	mv.mv_closet as tvv_mvcloset, mv.mv_cell as tvv_mvcell,
	tv.tv_take as tvv_take, tv.tv_ret as tvv_ret
FROM
	users u,
	mvalues mv,
	tvalues tv
WHERE
	u.u_id = tv.tv_user AND mv.mv_id = tv.tv_value
ORDER BY
	tv.tv_take DESC;
DISC;

-- Представление о всех взятых вещах всеми пользователями которые еще не вернули

CREATE OR REPLACE VIEW
	tvview
AS SELECT
	u.u_id as tvv_uid, u.u_f as tvv_uf, u.u_io as tvv_uio,
	u.u_emailt as tvv_email, mv.mv_id as tvv_mvid, 
	mv.mv_type as tvv_mvtype, mv.mv_desc as tvv_mvdesc,
	mv.mv_closet as tvv_mvcloset, mv.mv_cell as tvv_mvcell,
	tv.tv_take as tvv_take, tv.tv_ret as tvv_ret
FROM
	users u,
	mvalues mv,
	tvalues tv
WHERE
	u.u_id = tv.tv_user
	AND
	mv.mv_id = tv.tv_value
	AND tv.tv_ret is NULL
ORDER BY
	tv.tv_take DESC;
DISC;


-- представление о всех доступных вещах в шкафах
____________________________________

CREATE OR REPLACE VIEW
	avvalues
AS SELECT
	mv.mv_id as id, mv.mv_type as type, mv.mv_desc, 
	сs.cs_currval as currvalue, c.c_bld as bld_id,  
	b.bld_name as bld_name, b.bld_section as section, 
	cs.cs_cell as cell, c.c_floor as floor
FROM
	mvalues mv,
	closets c,
	cells cs,
	buildings b
WHERE
	mv.mv_closet = cs.cs_closet AND mv.mv_cell = cs.cs_num AND cs.cs_closet = c.c_id AND c.c_bld = b.bld_id
ORDER BY
	mv.mv_id DESC;
DISC;

-- представление о всех ячейках в  шкафах в которых есть место
____________________________________

CREATE OR REPLACE VIEW
	avclosets
AS SELECT
	c.c_id, c.c_cells, cs.cs_cell as cell, сs.cs_currval as currvalue,
	cs.cs_maxval, c.c_bld as bld_id,  b.bld_name as bld_name, 
	b.bld_section as section, c.c_floor as floor
FROM
	closets c,
	cells cs,
	buildings b
WHERE
	cs.cs_closet = c.c_id AND c.c_bld = b.bld_id AND cs.cs_maxval > cs.cs_currval
ORDER BY
	c.c_id DESC;
DISC;

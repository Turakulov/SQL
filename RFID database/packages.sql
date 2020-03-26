-- Cоздание пакета для вызова информации о взятых вещах по конкретному пользователю
_________________________________________________________________________
/*
Пакет Oracle PL/SQL — это объект схемы, который группирует логически связанные типы, 
элементы и подпрограммы. Пакеты обычно состоят из двух частей: спецификации и тела, 
хотя иногда тело не нужно.Спецификация пакета содержит список всех доступных элементов
и предоставляет разработчику информацию, необходимую для использования пакета в приложениях. 
Ее часто называют программным интерфейсом — API (Application Programming Interface).
*/

CREATE OR REPLACE PACKAGE takenValues IS
TYPE rowGetValues IS record(
  row_u_id		    users.u_id%TYPE,
  row_u_f		      users.u_f%TYPE, 
  row_u_io		    users.u_io%TYPE, 
  row_u_email     users.u_email%TYPE,
  row_mv_id		    mvalues.mv_id%TYPE,
  row_mv_type	    mvalues.mv_type%TYPE,
  row_mv_desc		  mvalues.mv_desc%TYPE, 
  row_mv_closet	  mvalues.mv_closet%TYPE,
  row_mv_cell		  mvalues.mv_cell%TYPE,
  row_tv_take		  tvalues.tv_take%TYPE, 
  row_tv_ret		  tvalues.tv_ret%TYPE
);

TYPE tblGetValues IS TABLE OF rowGetValues;

FUNCTION getValues(email_in varchar default NULL)
RETURN tblGetValues
pipelined;

END takenValues;


/*
Затем вызвать код тела пакета. Тело пакета содержит детали реализации 
и приватные объявления, которые скрыты от вашего приложения. За декларативной 
частью тела пакета следует необязательная часть инициализации, которая обычно 
содержит операторы, которые инициализируют переменные пакета.
*/

CREATE OR REPLACE PACKAGE BODY takenValues IS
FUNCTION getValues(email_in varchar default NULL)
RETURN tblGetValues
pipelined

IS 
BEGIN
  IF email_in IS NOT NULL THEN
    FOR curr IN (
      SELECT
        u.u_id, u.u_f, u.u_io, u.u_email,
        mv.mv_id, mv.mv_type, mv.mv_desc, mv.mv_closet, mv.mv_cell,
        tv.tv_take, tv.tv_ret
      FROM
        users u,
        mvalues mv,
        tvalues tv
      WHERE
        u.u_id = tv.tv_user AND mv.mv_id = tv.tv_value AND u.u_email = email_in
      ORDER BY
        tv.tv_take DESC
    ) loop
        pipe row(curr);
      end loop;
  end if;
end getValues;

end takenValues;

-- Вызов пакета select * from TABLE(takenValues.getValues(‘pakhmetiev@hse.ru’));

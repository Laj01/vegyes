select sysdate from dual;
select * from KONYVTAR.konyv; --megjegyzes
select /*komment asdasdasdasd*/ * from dual; --dualnak garant�ltan 1 sora van
select sysdate from konyvtar.konyv; --minden sorra k�l�n ki�rt�keli a sysdate-et, ez�rt van 51 sor
select sysdate, user, uid, 3*4, cos(3.14) from dual;
select to_char (sysdate, 'YYYY.MM.DD. HH24:MI:SS') from dual; --ha t�rt m�spdpercet akarunk akkor TIMESTAMP kell sysdate helyett �s .FF a v�g�re
select to_char (sysdate, 'DS TS') from dual; -- DateShort TimeShort
select to_char (round (sysdate, 'DD'),'DS TS')from dual; --round-dal kerek�t�nk id�ben el�re, napra DD, h�napra MM, �vre YYYYec
select to_char (trunc (sysdate, 'MM'),'DS TS')from dual; --trunc-al LEFEL� kerek�t�nk
select round (123.56789,-1), trunc(123.56789,2) from dual; -- 2-vel 2 tizedesjegyre kerek�t�nk, ha nem �runk a "," ut�n semmit, akkor eg�szre kerek�t
select to_char (sysdate +1, 'DS TS') from dual; --hozz�adunk +1 napot a mostani d�tumhoz, levonni is lehet "-"al, t�rt sz�mot is adhatunk hozz�
select to_char (add_months(sysdate, 1), 'DS TS') from dual; --h�napot adunk hozz� 
select (sysdate - to_date('1990.08.18. 21:15', 'YYYY.MM.DD. HH24:MI'))/365,25 from dual; --sz�let�si �vb�l sz�moljuk hogy h�ny �vesek vagyunk, napokkal sz�molva
select months_between(sysdate, to_date('1990.08.18. 21:15', 'YYYY.MM.DD. HH24:MI'))/12 from dual; --sz�let�si �vb�l sz�moljuk hogy h�ny �vesek vagyunk, h�napokkal sz�molva

select cim, ar from KONYVTAR.konyv; --csak a c�met �s az �rat list�zzuk ki, az oszlopok sorrendje sz�m�t!!
select * from KONYVTAR.konyv where ar > 10000; --�r szerint sz�r�nk, selectek be�gyazhat�k m�s utas�t�sokba �s egym�sba is

--olvas�k vezet�k+keresztneve �s sz�let�si ideje �s �letkora �vekben m�rve eg�sz sz�m k�nt akik lefeljebbb 20 �vesek:
select vezeteknev, keresztnev, szuletesi_datum from KONYVTAR.tag --eddig jutottam �n
--

select vezeteknev, keresztnev, szuletesi_datum,
    round(months_between(sysdate, szuletesi_datum,)/12)
    from KONYVTAR.tag
    where months_between(sysdate, szuletesi_datum)/12 <= 20;
--
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag; --nevek �sszef�z�se, k�z�tt�k sz�k�zzel �s a fejl�c �tnevez�se
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like 'A%'; --"A"-val kezd�d� nevek
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like '%a%a%'; --azok a nevek amiben legal�bb 2 "a" bet� van

select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where lower(vezeteknev || ' ' || keresztnev) like '%a%a%'; --legal�bb 2 kis "a" van a n�vben
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like '%a%a%' or
    vezeteknev || ' ' || keresztnev like '%A%A%' or
    vezeteknev || ' ' || keresztnev like '%a%A%' or
    vezeteknev || ' ' || keresztnev like '%A%a%';
    
--irassuk ki azokat a neveket amiben pontosan 2 a bet� van, lehet kicsi vagy nagy is
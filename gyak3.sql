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
select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
where lower (vezeteknev || ' ' || keresztnev) like '%a%a%'
        and
        not lower (vezeteknev || ' ' || keresztnev) like '%a%a%a%'; --a ()-ek ne maradjanak le!!
--lower (vezeteknev || ' ' || keresztnev) not like '%a%a%a%'; ugyan ez lesz

--2.gyakorlat-------------------------------------------------------------------------------------------------------------

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by keresztnev; -- rendez�s abc sorba keresztnevek szerint

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by keresztnev desc; --rendez�s abc sorba keresztnevek szerint cs�kken�en (descent), ellentettje az "asc", de nem szoktuk kitenni mert ez az alap�rtelmezett

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by szuletesi_datum; --olyan oszlop szerint is lehet rendezni, ami nem felt�tlen�l jelenik meg,!!de a t�bl�zatban benne van

select vezeteknev || ' ' || keresztnev nev, szuletesi_datum
from KONYVTAR.tag
order by szuletesi_datum;

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by length (nev);--a n�v hossza szerint rendez�nk

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by 1; --az eredm�sz els� oszlopa szerint rendez (itt n�v)

select vezeteknev || ' ' || keresztnev nev, szuletesi_datum
from KONYVTAR.tag
order by 2 desc; --az eredm�sz els� oszlopa szerint rendez (itt szul.d�tum)

select tema, cim 
    from KONYVTAR.konyv;

select tema, cim 
    from KONYVTAR.konyv
    order by tema nulls first; --a nullokat teszi el�re (ellenkez�je a "nulls last")
    --az order by csak a legv�g�n �ll el�
    
--azon szerz� vezet�k/kereszt nev�re, sz�l-idej�re, valamint �letkor�ra �vekben m�rve eg�sz sz�m k�nt vagyok kiv�ncsi, akik t�bb mint 50 �vesek �s legal�bb 2 "a" bet� van a teljes nev�kben, rendezz�k vezet�kn�v majd keresztn�v szerint n�vekv�ben

select vezeteknev, keresztnev,to_char(szuletesi_datum, 'ds'),
    round(months_between(sysdate, szuletesi_datum)/12) kor
    from KONYVTAR.szerzo
    where round(months_between(sysdate, szuletesi_datum)/12) > 50
        and
        lower (vezeteknev || keresztnev) like '%a%a%'
    order by vezeteknev, keresztnev;

--azon k�nyvek c�me, isbn sz�ma, kiad�s d�tuma, t�m�j�ra, amelyek vagy horror vagy scifi vagy t�rt�nelem t�m�j�ak �s ebben az �vezredben ker�ltek kiad�sra, rendezz�k kiad�s d�tum szerint cs�kken�en

select cim,isbn,TO_CHAR(kiadas_datuma, 'ds'),tema
    from KONYVTAR.konyv
    where tema in ('horror', 'sci-fi', 't�rt�nelem') --p�rja a "not in"
    and
    to_char(kiadas_datuma , 'YYYY') between 2000 and 2999 --p�rja a "not between"
    order by kiadas_datuma desc;
    
--azoknak a k�nyveknek az �ra, kiad�s d�tuma, c�me, t�m�ja, oldalsz�ma, amely k�nyvek 1990 �s 2000 k�z�tt ker�ltek kiad�sra vagy a k�nyv �ra 1000 �s 3000 huf k�z� esik vagy 20 oldaln�l r�videbb sci-fi, rendezz�k t�ma szerint cs�kken, azonos t�m�ks eset�n oldalsz�m szerint n�vekv� sorrendbe
select ar,to_char(kiadas_datuma, 'ds'),cim,tema,oldalszam
    from KONYVTAR.konyv
    where to_char(kiadas_datuma, 'yyyy') between 1990 and 2000
        or
        ar between 1000 and 3000
        or
        tema = 'sci-fi' and oldalszam <20
    order by tema desc, oldalszam;
    
-- a '%'-jel testsz�leges sz�m� karaktert helyettes�t, m�g az '_'-jel 1 db tetsz�leges karaktert helyettes�t
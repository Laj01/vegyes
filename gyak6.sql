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

select 'igen' from dual where 'almafa' like '%\_%' escape '\'; --a _ joker karaktert keres�k az escappel

------------------------gyak 4--------------------------------------------------------

select 'igen' from dual where 'almafa' like '%z%%' escape 'z'; --a % joker karaktert keres�k az escappel

select tema from KONYVTAR.konyv where tema !=null; -- nem egyenl�: <>, !=, ^=, NULL-ra nemm �k�di az egyenl�s�g/nem egyenl�s�g vizsg�lat
select tema from KONYVTAR.konyv where tema is null;
select tema from KONYVTAR.konyv where tema is not null; --is vagy is not-tal keres�nk NULL-ra

--------csoportk�pz�s-----------
select COUNT(*) from KONYVTAR.konyv;  ----megsz�molja h�ny sorunk van, a * jelenti az �sszes sort
select COUNT(cim) from KONYVTAR.konyv;
select COUNT(ar) from KONYVTAR.konyv; --a NULL �rt�kket nem sz�molja bele a COUNT
select COUNT(tema) from KONYVTAR.konyv;
select COUNT(*) from KONYVTAR.konyv where tema is not null; --ekvivalens az el�z� sorral
select COUNT(distinct tema) from KONYVTAR.konyv; ---(k�l�nb�z� tema)
select tema from KONYVTAR.konyv;
select distinct tema from KONYVTAR.konyv;-- distinct csak egyb�l select ut�n �llhat
select DISTINCT ar, tema from KONYVTAR.konyv;
select distinct ar, tema from KONYVTAR.konyv order by 1, 2 ;
select COUNT(*), cim from KONYVTAR.konyv; ---nem lehet egyszerre 2 , hib�t kapunk

select count(*), --figyelembe veszi a NULL-t
    min(ar), --m�k�dik sz�mokra, sz�vegre(abc szerint), d�tumra(legkor�bbi)
    max(ar), --ugyan ez
    avg(ar), --m�r csak numerikus adatoka m�k�dik
    sum(ar), --ugyan ez, egyik f�ggv�ny sem veszi figyelembe a NULL-okat adatokat, ha az �sszes �rt�k NULL-�rt�k, akkor az eredm�ny is NULL lesz
    min(kiado), --abc-sorrendbe rakja, az�rt van a HOLNAP kiad� el�l, mert van el�tte egy sz�k�z
    max(kiadas_datuma)
    from KONYVTAR.konyv;
    
select sum(ar) / count(ar), avg(ar) from KONYVTAR.konyv;
select sum(ar) / count(*), avg(ar) from KONYVTAR.konyv;

select tema,
    min(ar),
    max(ar),
    avg(ar),
    sum(ar),
    min(kiado),
    max(kiadas_datuma)
    from KONYVTAR.konyv
    group by tema; --t�m�nk�nt csoportos�tjuk
    
select tema,
    min(ar),
    max(ar),
    avg(ar),
    sum(ar),
    min(kiado),
    to_char (max(kiadas_datuma), 'ds') --konvert�lhatjuk a form�tumot
    from KONYVTAR.konyv
    group by tema;
    
select kiado, count(*) --azoka a kiad�k, amikor 300 oldaln�l r�videbb k�nyveket adtank ki 
    from KONYVTAR.konyv
    where oldalszam < 300
    group by kiado;
    
select kiado, tema, count(*)  
    from KONYVTAR.konyv
    group by kiado, tema;

select kiado || tema, count(*) --zinte ugyanaz mint az el�z�  
    from KONYVTAR.konyv
    group by kiado || tema;

select TO_CHAR(szuletesi_datum, 'YYYY'), count(*)
    from KONYVTAR.tag
    group by to_char( szuletesi_datum, 'YYYY');
    
select TO_CHAR(szuletesi_datum, 'YYYY'), count(*)
    from KONYVTAR.tag
    group by to_char( szuletesi_datum, 'YYYY')
    order by count (*) desc; --vagy order by 2 desc; "a 2. oszlop szerint"
    
select TO_CHAR(szuletesi_datum, 'YYYY'), count(*)
    from KONYVTAR.tag
    group by to_char( szuletesi_datum, 'YYYY')
    having count(*) > 2
    order by count (*) desc;
    
select TO_CHAR(szuletesi_datum, 'YYYY'), count(*)
    from KONYVTAR.tag
    where nem = 'n'
    group by to_char( szuletesi_datum, 'YYYY')
    having count(*) > 2
    order by count (*) desc;
-- a fel��si sorrend csak ez lehet: select, from, where, group by, order by
-- v�grehajt�si sorrend: from, where, group by, having, select, order by

select TO_CHAR(szuletesi_datum, 'YYYY'), count(*) db --to_car helyett lehet : extract(year from szuletesi_datum)
    from KONYVTAR.tag
    --where nem = 'n'
    group by to_char( szuletesi_datum, 'YYYY')
    having count(*) > 2
    order by db desc;
    

--feladat: egyes ir�ny�t�sz�m� helyszinekr�l, h�ny olvas� van beiratkozva, rendezzunk az eredm�nyt darabsz�m szerint cs�kken sorrendbe
select substr('almafa', 3, 2) from dual;

select substr(cim, 1, 4), count (*)
    from konyvtar.tag
    group by substr(cim, 1, 4)
    order by 2 desc;
    
--telep�l�sek szerint, csoportos�tjuk
select substr(cim, 6, instr(cim, ',')-6), count (*)
    from konyvtar.tag
    group by substr(cim, 6, instr(cim, ',')-6)
    order by 2 desc;


-- az egyes szerz�k mennyit kerestek �sszesen eddig a k�nyvekb�l, de csak azok akik min 1000000-et kerestek, rendezz�k �sszhonor�rium szerint cs�kken�ben, adjuk meg a szerz�ket azonost�juk szerint

select szerzo_azon, sum(honorarium)
    from KONYVTAR.konyvszerzo
    group by szerzo_azon
    having sum(honorarium) >= 1000000
    order by sum(honorarium) desc;
    
select min(szuletesi_datum) --a leg�regebb olvas� sz�let�si d�tuma
    from KONYVTAR.tag;
    
select vezeteknev, keresztnev, szuletesi_datum --a leg�regebb olvas�, n�vvel egy�tt 
    from KONYVTAR.tag
    where szuletesi_datum = 
        (select min(szuletesi_datum)
        from konyvtar.tag);
        
---------------------------5. gyakorlat----------------------------------------

-----�rassuk ki,az egyes lelt�ri sz�m�t, �rt�k�t, c�m�t �s t�m�j�t
select count(*) from konyvtar.konyvtari_konyv;
select count(*) from konyvtar.konyv;

select * from konyvtar.konyvtari_konyv, konyvtar.konyv;
select count(*) from konyvtar.konyvtari_konyv, konyvtar.konyv;
select 51*135 from dual;

select * 
    from konyvtar.konyvtari_konyv, konyvtar.konyv
    where KONYVTAR.konyv.konyv_azon = KONYVTAR.konyvtari_konyv.konyv_azon; ---a reprezent�ci�ban, a ny�l forr�sa lesz az els�dleges, ara hivatkozunk el�sz�r

select * 
    from konyvtar.konyvtari_konyv join konyvtar.konyv
    on KONYVTAR.konyv.konyv_azon = KONYVTAR.konyvtari_konyv.konyv_azon;--- ekvivalens az el�z�vel, join+using egy�tt
    
select * 
    from konyvtar.konyvtari_konyv k join konyvtar.konyv kk--- alias-t is adhatunk a neveknek, hogy egyszer�s�dj�n
    on k.konyv_azon = kk.konyv_azon;--- �sszekapcsol�si attrib�tumok

select * 
    from konyvtar.konyvtari_konyv k join konyvtar.konyv kk----ekvivalens az el�z�vel, join+using egy�tt
    using (konyv_azon);--a k�t k�nyv azonos�t�b�l csak az els�t tett�k be, a m�sikat kisz�rt�k
    
select * 
    from konyvtar.konyvtari_konyv natural join konyvtar.konyv;--mag�t�l megkeresi a 2 rel�ci�ban az azonos nev� oszlopp�rokat �s �sszekapcsolja �ket a keres�si felt�telekben
    
select * 
    from konyvtar.konyvtari_konyv k join konyvtar.konyv kk
    on k.konyv_azon = kk.konyv_azon
    where tema='krimi';
    

select leltari_szam, ertek, cim, tema
    from konyvtar.konyvtari_konyv k join konyvtar.konyv kk
    on k.konyv_azon = kk.konyv_azon---a feladat megold�sa
    where cim = 'T�z kicsi n�ger';
    

---------frei tam�s mennyit kapott az �ltala �rt egyes k�nyvek�rt, k�l�n k�l�n k�nyvek�rt---------

select konyv_azon, honorarium, cim, tema 
    from KONYVTAR.szerzo natural join KONYVTAR.konyvszerzo natural join KONYVTAR.konyv
    where vezeteknev || keresztnev = 'FreiTam�s';
    
    
----azok a k�nyvek amelyeket nem hoztak vissza �s di�kok k�lcs�n�ztek ki, h�ny p�ld�ny van

select leltari_szam
    from KONYVTAR.tag join konyvtar.kolcsonzes
    on olvasojegyszam = ;
    
    
    
------------ki �rta a t�z kicsi n�gert?

select keresztnev, vezeteknev
    from KONYVTAR.szerzo natural join KONYVTAR.konyvszerzo natural join KONYVTAR.konyv
    where cim = 'T�z kicsi n�ger';
    
--------- milyen t�m�j� konyveket vett ki Vak Ond, egy t�m�t csak egyszer �rjuk ki, rendezz�k abc sorrendben
select distinct tema ------vagy group by tema
    from konyvtar.tag join KONYVTAR.kolcsonzes
    on olvasojegyszam = tag_azon
    join KONYVTAR.konyvtari_konyv using (leltari_szam)
    join KONYVTAR.konyv using (konyv_azon)
    where vezeteknev || keresztnev = 'VakOnd'
    order by tema;
    
-----------------------6. gyakorlat------------------------------------------------------



-----�rassuk ki azok k�nyvek adatait, amiknek egy p�ld�nya sincs a k�nyvt�rban

select * 
    from KONYVTAR.konyv
    where konyv_azon not in
        (select konyv_azon        ---- f�ggetlen alk�rd�s, ez �nmag�ban is lefuttathat�
            from konyvtar.konyvtari_konyv);
            
select * 
    from KONYVTAR.konyv k
    where not exists
        (select *       ---f�gg� alk�rd�s
            from KONYVTAR.konyvtari_konyv kk
            where kk.konyv_azon = k.konyv_azon);
            
            
----K�ls� �szekapcsol�s , outer join-------------

select * 
    from konyvtar.konyv k join KONYVTAR.konyvtari_konyv kk --- itt nem l�tjuk a l�g� sorokat (NULL �rt�kek)
        using (konyv_azon);
        
select * 
    from konyvtar.konyv k full outer join KONYVTAR.konyvtari_konyv kk  ---meg kell adni, hogy left/right/full outer join, de az outer el is hagyhat�
        using (konyv_azon);


---irassuk ki az �sszes k�nyv �sszes adat�t, mell� �rva az adott k�nyv p�ld�nyainak adataivel, azokat is l�tni szeretn�nk, amiknek nincs p�ld�nya
select * 
    from konyvtar.konyv k full outer join KONYVTAR.konyvtari_konyv kk  ---mindig meg kell adni, hogy left/right/full outer join, de az outer el is hagyhat�
        using (konyv_azon);


---�rassuk ki az �sszes nyugd�jas olvas�nkat, valamint azt, hogy milyen lelt�ri sz�m� k�nyveket k�lcs�n�ztek ki

select vezeteknev, keresztnev, leltari_szam
    from konyvtar.tag left join konyvtar.kolcsonzes
        on olvasojegyszam = tag_azon
    where besorolas ='nyugd�jas';


---irassuk ki az �sszes szerz� nev�t, mell� azon k�nyvek azonos�t�i, amket �k szereztek

select vezeteknev, keresztnev, konyv_azon
    from konyvtar.szerzo left join konyvtar.konyvszerzo
        using (szerzo_azon);
        
------irassuk ki az �sszes szerz� nev�t, mell� azon k�nyvek azonos�t�i, amket �k szereztek, �s a k�nyvek c�m�t is �rjuk ki

select vezeteknev, keresztnev, konyv_azon, cim
    from konyvtar.szerzo left join konyvtar.konyvszerzo 
        using (szerzo_azon)
            left join KONYVTAR.konyv
            using (konyv_azon);
            
select vezeteknev, keresztnev, konyv_azon, cim
    from konyvtar.konyvszerzo
        join konyvtar.konyv using (konyv_azon)
        right join konyvtar.szerzo using (szerzo_azon;)
        
---az �sszes 1000ft-n �l dr�g�bb konyvt�ri p�ld�nyt �s hogy kik �lcs�n�z�k ki, azokat is l�ssuk, amiket nem k�lcs�nz�tt ki senki

select leltari_szam, ertek, vezeteknev, keresztnev
    from konyvtar.konyvtari_konyv left join konyvtar.kolcsonzes 
    using (leltari_szam)
    left join KONYVTAR.tag
    on olvasojegyszam = tag_azon
    where ertek > 1000; 
    
----egyes tagok, h�ny k�l�nb�z� k�nyvet k�lcs�n�ztek ki
select vezeteknev, keresztnev, count(*) 
    from konyvtar.tag join konyvtar.kolcsonzes
        on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev;
        
---- szeretn�nnk, minden ebert l�tni, azt is aki nem kolcs�nz�tt ki semmit

select vezeteknev, keresztnev, count(kolcsonzesi_datum) ---count csillag sorokat sz�mol 
    from konyvtar.tag left join konyvtar.kolcsonzes
        on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev;

----�tlagosan mekkora az �rt�ke a sci-fi t�m�j� k�nyvek p�ld�nyainak

select avg (ertek)
    from konyvtar.konyv join KONYVTAR.konyvtari_konyv
        using (konyv_azon)
            where tema = 'sci-fi';
            

----�tlagosan mekkora az �rt�ke a sci-fi t�m�j� k�nyvek p�ld�nyainak, sz�m�tsuk be azokat a konyveket is, amib�l nincs p�ld�nyunk, ezeket sz�moljuk 0 ft-os �rt�kkel

select sum (ertek) / count(*)
    from konyvtar.konyv left join KONYVTAR.konyvtari_konyv ---left join, hogy azok a konyvek is megmaradjanak amiknek nincs k�nyvt�ri p�ld�nya
        using (konyv_azon)
            where tema = 'sci-fi';
 
-----------------9. gyak---------------------
--DDL (Data definition language)
---t�bla l�trehoz�sa, DML utas�t�sok
--- CREATE TABLE <t�blan�v>
--([<oszlople�r�s> | <t�blamegszor�t�s>]....)


--oszlople�r�s:
--<oszlopn�v> <t�pus> [<oszlopmegszor�t�s>]....


--<t�blamegszor�t�s> vagy <oszlopmegszor�t�s>:
--[CONSTRAINT <megszor�t�s>] <le�r�s>

--hozzunk l�tre egy t�bl�t, Tulaj n�ven az al�bbi mez�kkel, azon: max 5 jegy� eg�sz, n�v: max 30 karakteres string , sz�l_dat: sz�let�s d�tum, szemelyiszam: 11 karakter hossz�s�g� string
-- nem lehet . az azonos�t�ban, ha midnenk�ppen kell bele akkor (.)-k�nt tessz�k bele
--megszor�t�sok: n�v/szem�lyi sz�m nem lehet NULL �rt�k, els�dleges kulcs az azon legyen, m�gegy kulcs a szem�lyi sz�m

create table Tulaj
( 
    azon number(5) primary key, --typusok lehetnek: number:  alap�rtelmezett hossz�s�g� eg�sz sz�m, number(p): �n adom meg h�ny sz�mjegyet t�rolhat, lehet +-jel is el�tte, number (p,s): �sszes szmjegy �s ut�na �sszes tizedesjegy sz�ma
    nev varchar2(30) not null, --vachar2r: v�ltoz� hossz�s�g� string, (h�ny maxim�lis karaktert akarunk t�rolni), sima char(p): ha fix hossz�s�g� stringet akarok t�rolni
    szul_dat date,
    szemelyiszam char(11) not null unique ---unique kulcs deklar�l�s�ra, primary key els�dleges kulcsra   
);

drop table Tulaj; -----teljes t�bla t�rl�se

create table Tulaj---oszlop megszor�t�sokat fogunk haszn�lni
( 
    azon number(5) constraint tulaj_pk primary key, ---elneveztem a megszor�t�st tulaj_pk-ra
    nev varchar2(30) not null, 
    szul_dat date default sysdate, ---ez lesz az alap�rtlmezett �rt�k, ha nincs default �rt�k akkror nulla lesz, ha a not null is van meg nincs default �rt�k se, akkor hiba�zenetet kapunk
    szemelyiszam char(11) not null constraint tulaj_un_szsz unique ---elneveztem a megszor�t�st
);

---hozzuk l�tre az Auto t�bl�t, rendsz�m : max 6 karakteres string, sz�n: max 10 karakteres string, tulaj_azon: max 5 sz�mjegy, ar: max 8 tizedesjegy, ebb�l 2 t�rtr�sz
--megszor�t�sok: els�dleges kulcs a rendsz�m, k�ls� kulcs legyen a tulaj_azon �s hivatkozzon a Tulaj t�bla azon mez�j�re, ne lehessen az �r 10000-n�l kisebb, adjunk nevez az �sszes nevet a megszor�t�snak

create table Auto
(
    rendszam varchar2(6) constraint auto_pk primary key,---nevet adunk
    szin varchar2(10),
    tulaj_azon number(5) constraint auto_fk_tulaj references Tulaj(azon),---kuls� kulcs megad�sa �s elnevez�se
    ar number(8,2) constraint auto_ch_ar check(ar >= 10000)
);

drop table Auto;

create table Auto---t�bla megsor�t�sokat fogunk haszn�lni
(
    rendszam varchar2(6),---nevet adunk
    szin varchar2(10),
    tulaj_azon number(5),---kuls� kulcs megad�sa �s elnevez�se
    ar number(8,2) ,
    constraint auto_pk primary key (rendszam),----kiemelj�k �j sorba, a not nullt �s defaultot nem lehet kiemelni
    constraint auto_fk_tulaj foreign key (tulaj_azon) references Tulaj(azon),
    constraint auto_ch_ar check(ar >= 10000)
);


---create table m�sik esete:
--hozzunk l�tre egy Tag nev� t�bl�t, ami olvas�k vezet�k/kereszt nev�t, sz�l. d�tum�t stingk�nt, �s az adott tagnak h�ny k�lcs�nz�se volt

create table Tag as---az �gy kapott t�bl�ban nem lesz semilyen megszor�t�s, m�g els�dleges kulcs sem
    select vezeteknev, keresztnev, to_char(szuletesi_datum, 'ds') szuldat, count(*) darab ---a 2 kifejez�shez musz�j �tnevezni
        from KONYVTAR.tag join KONYVTAR.kolcsonzes on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev, szuletesi_datum;
        
drop table Tag;

---ugyanez, de a vezet�kn�z v�g�re tegy�nk egy + jelet, ha 80 ut�n sz�letett

create table Tag as
    select
    case when extract(year from szuletesi_datum) >= 1980 then
        vezeteknev || '+'
        else
        vezeteknev
        end vezeteknev,
        case when extract(year from szuletesi_datum) >= 1980 then
        keresztnev || '+'
        else
        keresztnev
        end keresztnev,
        to_char(szuletesi_datum, 'ds') szuldat, 
        count(*) darab ---a 2 kifejez�shez musz�j �tnevezni
        from KONYVTAR.tag join KONYVTAR.kolcsonzes on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev, szuletesi_datum;
        
drop table Tag;
        
        ----m�jus 28 kedd du. 2 teok  jav�t� zh
        
------------------------------10 gyak.------------------------------

--alter table <t�blan�v> t�bla m�dos�t�sa
--kulcsszavak t�blan�v m�g�tt: (t�bb m�dos�t�s eset�n z�r�jelezni kell) ADD, MODIFY, DROP COLUMN <oszlop>, DROP CONSTRAINT <megszor�t�s>, DROP PRIMARY KEY, RENAME ti <t�blan�v>
-- RENAME COLUMN <oszlopn�v> to <�j oszlopn�v>, RENAME CONSTRAINT <n�v> to <n�v>, k�l�n rename utas�t�s: RENAME <t�blan�v> to <�j t�blan�v>


create table Tag as
    select
    case when extract(year from szuletesi_datum) >= 1980 then
        vezeteknev || '+'
        else
        vezeteknev
        end vezeteknev,
        case when extract(year from szuletesi_datum) >= 1980 then
        keresztnev || '+'
        else
        keresztnev
        end keresztnev,
        to_char(szuletesi_datum, 'ds') szuldat, 
        count(*) darab ---a 2 kifejez�shez musz�j �tnevezni
        from KONYVTAR.tag join KONYVTAR.kolcsonzes on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev, szuletesi_datum;
        

alter table Tag
    add primary key (vezeteknev, keresztnev, szuldat, darab);
    
alter table Tag
    add tag_azon number;
    
alter table Tag
    drop primary key;
    
alter table Tag
    add primary key (tag_azon);
    
--szekvencia: n�vekm�ny �rt�k, van kezdete, v�ge �s n�veked�s m�rt�ke

create sequence szekv;--ha nem adok meg semmilyen param�tert, akkor alap�rt�kekkel dolgozik, kulcs default �rt�kek�nt is lehet haszn�lni, 
--itt most a tag_azonhoz adtuk hozz�, hogy leszen ott valamilyen �rt�k, hogy primary key-t tudjunk bel�le csin�lni
update tag set tag_azon=szekv.nextval;

alter table Tag
    add primary key (tag_azon);--mostm�r primary key-t tudtunk bel�le csin�lni

drop table Auto;

create table Auto
(
    rendszam varchar2(6) constraint auto_pk primary key,---nevet adunk
    szin varchar2(10),
    tulaj_azon number(5) constraint auto_fk_tulaj references Tulaj(azon),---kuls� kulcs megad�sa �s elnevez�se
    ar number(8,2) constraint auto_ch_ar check(ar >= 10000)
);

--b�v�ts�k a t�bl�t egy �j oszloppal

alter table Auto
    add tipus varchar2(20);
    
--nevezz�k �t modell-re

alter table Auto
    rename column tipus to modell;
    
--nevezz�k �t a megszor�t�st

alter table Auto
    rename CONSTRAINT AUTO_CH_AR to AUTO_CHECK_AR;
    
--nevezz�k �t az eg�sz t�bl�t

alter table Auto
    rename TO Kocsi;
    
--nevezz�k vissza

rename Kocsi to Auto;

--t�r�lj�nk megszor�t�st

alter table Auto
    drop constraint AUTO_CHECK_AR;
    
--hosszab rendsz�mokat is t�rolni akarok, m�dos�tsuk a rendsz�mot 20 hossz�s�g� stringre, �s cs�kkents�k a sz�n hossz�t 6-ra, itt m�r kel a () t�bb oszlop eset�n

alter table Auto
    modify (rendszam varchar2(20),
            szin varchar2(6));
            
--t�r�lj�k a modell oszlopot
alter table Auto
    drop column modell;
    
---DDl utas�t�s: create view, mindig a lek�rdez�s pillanat�ban hoz l�tre egy n�zetet a t�bl�r�l
--el�szr a selectet �rjuk meg, azt�n el��rjuk a create view-t
--k�t oszlop, szerz�n�v, k�nyvc�m, a szerz�n�v legyen sz�k�zzel elv�lasztva
create view konyvek as
select vezeteknev || ' ' || keresztnev nev, cim 
    from KONYVTAR.szerzo left join KONYVTAR.konyvszerzo
        using (szerzo_azon)
        left join KONYVTAR.konyv using (konyv_azon);
        
        
--csak a 20 bet�n�l r�videbb k�nyvc�meket akarom l�tni       
select * from konyvek
        where length (cim)<20;
        
--n�zetet is lehet droppolni, m�dos�tani
--dolgozat: create table, create view, bonyolult selectek



--DML utas�t�sok (data manipulation language): INSERT , DELETE, UPDATE utas�t�sok    
--insert into <t�blan�v> (oszlopnevek felsorol�sa, ha nem adok meg oszlopokat, akkor az �sszeset besz�rja, ha kell) values (<�rt�kek>); a column ID adja meg az oszlopok sorendj�t, csak 1 sort lehet besz�rni
--inster into <t�blan�v>(<oszlopnevek>) values (<�rt�k>) | select...)

truncate table tulaj; --nem t�rli a t�bl�t, de az �sszes rekordot kigyalulja, v�gleges, nem csin�lhat� vissza
delete from Tulaj;---ugyanaz, de ez visszacsin�lhat�
rollback;

--besz�rok egy �j sort
insert into tulaj
    values (10, 'Toth Geza', TO_DATE ('1990.dec.31', 'yyyy.mm.dd'), '19912311234');
    
    
insert into tulaj(nev, szemelyiszam, azon)
    values (
            (select vezeteknev || ' ' || keresztnev 
                from KONYVTAR.szerzo
                where szuletesi_datum = (select min (szuletesi_datum) from KONYVTAR.szerzo)), --a legid�sebb k�lt�
            (select substr(ISBN,1,11) 
                from KONYVTAR.konyv
                where ar = (select max(ar) from KONYVTAR.konyv) and isbn like '%-%'), --�ltal �rt  legdr�g�bb k�nyv isbn sz�m�nak els� 11 sz�mjegye, ez lesz a szem�lyi sz�m
                11 --azonos�t�
            );
    
insert into tulaj
    select mod(konyv_azon, power(10,5)), tema, null, substr(isbn,1,11)
        from KONYVTAR.konyv
            where tema like 's%';
            
            
delete from tulaj--t�r�lj�k az sz-el kezd�d� neveket
    where nev like 'sz%';
    
delete from tulaj; --ha nem adok meg semmit, akkor mindent t�r�l a t�bl�b�l

ROLLBACK;
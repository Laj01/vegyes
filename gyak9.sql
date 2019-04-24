-----------------9. gyak---------------------
--DDL (Data definition language)
---tábla létrehozása, DML utasítások
--- CREATE TABLE <táblanév>
--([<oszlopleírás> | <táblamegszorítás>]....)


--oszlopleírás:
--<oszlopnév> <típus> [<oszlopmegszorítás>]....


--<táblamegszorítás> vagy <oszlopmegszorítás>:
--[CONSTRAINT <megszorítás>] <leírás>

--hozzunk létre egy táblát, Tulaj néven az alábbi mezõkkel, azon: max 5 jegyû egész, név: max 30 karakteres string , szül_dat: születés dátum, szemelyiszam: 11 karakter hosszúságú string
-- nem lehet . az azonosítóban, ha midnenképpen kell bele akkor (.)-ként tesszük bele
--megszorítások: név/személyi szám nem lehet NULL érték, elsõdleges kulcs az azon legyen, mégegy kulcs a személyi szám

create table Tulaj
( 
    azon number(5) primary key, --typusok lehetnek: number:  alapértelmezett hosszúságú egész szám, number(p): én adom meg hány számjegyet tárolhat, lehet +-jel is elõtte, number (p,s): összes szmjegy és utána összes tizedesjegy száma
    nev varchar2(30) not null, --vachar2r: változó hosszúságú string, (hány maximális karaktert akarunk tárolni), sima char(p): ha fix hosszúságú stringet akarok tárolni
    szul_dat date,
    szemelyiszam char(11) not null unique ---unique kulcs deklarálására, primary key elsõdleges kulcsra   
);

drop table Tulaj; -----teljes tábla törlése

create table Tulaj---oszlop megszorításokat fogunk használni
( 
    azon number(5) constraint tulaj_pk primary key, ---elneveztem a megszorítást tulaj_pk-ra
    nev varchar2(30) not null, 
    szul_dat date default sysdate, ---ez lesz az alapértlmezett érték, ha nincs default érték akkror nulla lesz, ha a not null is van meg nincs default érték se, akkor hibaüzenetet kapunk
    szemelyiszam char(11) not null constraint tulaj_un_szsz unique ---elneveztem a megszorítást
);

---hozzuk létre az Auto táblát, rendszám : max 6 karakteres string, szín: max 10 karakteres string, tulaj_azon: max 5 számjegy, ar: max 8 tizedesjegy, ebbõl 2 törtrész
--megszorítások: elsõdleges kulcs a rendszám, külsõ kulcs legyen a tulaj_azon és hivatkozzon a Tulaj tábla azon mezõjére, ne lehessen az ár 10000-nél kisebb, adjunk nevez az összes nevet a megszorításnak

create table Auto
(
    rendszam varchar2(6) constraint auto_pk primary key,---nevet adunk
    szin varchar2(10),
    tulaj_azon number(5) constraint auto_fk_tulaj references Tulaj(azon),---kulsõ kulcs megadása és elnevezése
    ar number(8,2) constraint auto_ch_ar check(ar >= 10000)
);

drop table Auto;

create table Auto---tábla megsorításokat fogunk használni
(
    rendszam varchar2(6),---nevet adunk
    szin varchar2(10),
    tulaj_azon number(5),---kulsõ kulcs megadása és elnevezése
    ar number(8,2) ,
    constraint auto_pk primary key (rendszam),----kiemeljük új sorba, a not nullt és defaultot nem lehet kiemelni
    constraint auto_fk_tulaj foreign key (tulaj_azon) references Tulaj(azon),
    constraint auto_ch_ar check(ar >= 10000)
);


---create table másik esete:
--hozzunk létre egy Tag nevü táblát, ami olvasók vezeték/kereszt nevét, szül. dátumát stingként, és az adott tagnak hány kölcsönzése volt

create table Tag as---az így kapott táblában nem lesz semilyen megszorítás, még elsõdleges kulcs sem
    select vezeteknev, keresztnev, to_char(szuletesi_datum, 'ds') szuldat, count(*) darab ---a 2 kifejezéshez muszáj átnevezni
        from KONYVTAR.tag join KONYVTAR.kolcsonzes on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev, szuletesi_datum;
        
drop table Tag;

---ugyanez, de a vezetéknéz végére tegyünk egy + jelet, ha 80 után született

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
        count(*) darab ---a 2 kifejezéshez muszáj átnevezni
        from KONYVTAR.tag join KONYVTAR.kolcsonzes on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev, szuletesi_datum;
        
drop table Tag;
        
        ----május 28 kedd du. 2 teok  javító zh
        
------------------------------10 gyak.------------------------------

--alter table <táblanév> tábla módosítása
--kulcsszavak táblanév mögött: (több módosítás esetén zárójelezni kell) ADD, MODIFY, DROP COLUMN <oszlop>, DROP CONSTRAINT <megszorítás>, DROP PRIMARY KEY, RENAME ti <táblanév>
-- RENAME COLUMN <oszlopnév> to <új oszlopnév>, RENAME CONSTRAINT <név> to <név>, külön rename utasítás: RENAME <táblanév> to <új táblanév>


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
        count(*) darab ---a 2 kifejezéshez muszáj átnevezni
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
    
--szekvencia: növekmény érték, van kezdete, vége és növekedés mértéke

create sequence szekv;--ha nem adok meg semmilyen paramétert, akkor alapértékekkel dolgozik, kulcs default értékeként is lehet használni, 
--itt most a tag_azonhoz adtuk hozzá, hogy leszen ott valamilyen érték, hogy primary key-t tudjunk belõle csinálni
update tag set tag_azon=szekv.nextval;

alter table Tag
    add primary key (tag_azon);--mostmár primary key-t tudtunk belõle csinálni

drop table Auto;

create table Auto
(
    rendszam varchar2(6) constraint auto_pk primary key,---nevet adunk
    szin varchar2(10),
    tulaj_azon number(5) constraint auto_fk_tulaj references Tulaj(azon),---kulsõ kulcs megadása és elnevezése
    ar number(8,2) constraint auto_ch_ar check(ar >= 10000)
);

--bõvítsük a táblát egy új oszloppal

alter table Auto
    add tipus varchar2(20);
    
--nevezzük át modell-re

alter table Auto
    rename column tipus to modell;
    
--nevezzük át a megszorítást

alter table Auto
    rename CONSTRAINT AUTO_CH_AR to AUTO_CHECK_AR;
    
--nevezzük át az egész táblát

alter table Auto
    rename TO Kocsi;
    
--nevezzük vissza

rename Kocsi to Auto;

--töröljünk megszorítást

alter table Auto
    drop constraint AUTO_CHECK_AR;
    
--hosszab rendszámokat is tárolni akarok, módosítsuk a rendszámot 20 hosszúságú stringre, és csükkentsük a szín hosszát 6-ra, itt már kel a () több oszlop esetén

alter table Auto
    modify (rendszam varchar2(20),
            szin varchar2(6));
            
--töröljük a modell oszlopot
alter table Auto
    drop column modell;
    
---DDl utasítás: create view, mindig a lekérdezés pillanatában hoz létre egy nézetet a tábláról
--elõszr a selectet írjuk meg, aztán eléírjuk a create view-t
--két oszlop, szerzõnév, könyvcím, a szerzõnév legyen szóközzel elválasztva
create view konyvek as
select vezeteknev || ' ' || keresztnev nev, cim 
    from KONYVTAR.szerzo left join KONYVTAR.konyvszerzo
        using (szerzo_azon)
        left join KONYVTAR.konyv using (konyv_azon);
        
        
--csak a 20 betûnél rövidebb könyvcímeket akarom látni       
select * from konyvek
        where length (cim)<20;
        
--nézetet is lehet droppolni, módosítani
--dolgozat: create table, create view, bonyolult selectek



--DML utasítások (data manipulation language): INSERT , DELETE, UPDATE utasítások    
--insert into <táblanév> (oszlopnevek felsorolása, ha nem adok meg oszlopokat, akkor az összeset beszúrja, ha kell) values (<értékek>); a column ID adja meg az oszlopok sorendjét, csak 1 sort lehet beszúrni
--inster into <táblanév>(<oszlopnevek>) values (<érték>) | select...)

truncate table tulaj; --nem törli a táblát, de az összes rekordot kigyalulja, végleges, nem csinálható vissza
delete from Tulaj;---ugyanaz, de ez visszacsinálható
rollback;

--beszúrok egy új sort
insert into tulaj
    values (10, 'Toth Geza', TO_DATE ('1990.dec.31', 'yyyy.mm.dd'), '19912311234');
    
    
insert into tulaj(nev, szemelyiszam, azon)
    values (
            (select vezeteknev || ' ' || keresztnev 
                from KONYVTAR.szerzo
                where szuletesi_datum = (select min (szuletesi_datum) from KONYVTAR.szerzo)), --a legidõsebb költõ
            (select substr(ISBN,1,11) 
                from KONYVTAR.konyv
                where ar = (select max(ar) from KONYVTAR.konyv) and isbn like '%-%'), --által írt  legdrágább könyv isbn számának elsõ 11 számjegye, ez lesz a személyi szám
                11 --azonosító
            );
    
insert into tulaj
    select mod(konyv_azon, power(10,5)), tema, null, substr(isbn,1,11)
        from KONYVTAR.konyv
            where tema like 's%';
            
            
delete from tulaj--töröljük az sz-el kezdõdõ neveket
    where nev like 'sz%';
    
delete from tulaj; --ha nem adok meg semmit, akkor mindent töröl a táblából

ROLLBACK;
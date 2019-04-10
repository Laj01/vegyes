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

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

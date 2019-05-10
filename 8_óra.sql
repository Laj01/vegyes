--TechOnTheNet --> Látványosabb mint az oracle doksi.
--Halmazmûveletek:
    --Az attribútomok számának és típusának is meg kell egyezni.
    --Union -> unió:
        --Az egyforma elemek(ha teljesen megegyeznek) csak egyszer jelennek meg
    --union all:
        --Ez esetben ha van 2 teljesen egyforma elem is, akkor is 2szer jelennek meg
    --intersect -> metszet:
        -- Ami mindkét táblában szerepel.
    --minus -> Minusz:
        --Ami az egyikben megtalálható, a másikban viszont nem.
        
--Felsõ n analízis(rownum) -> Arra használatos,hogy az eredményünk felsõ n sorát kiválasszuk.
select k.*,rownum from KONYVTAR.konyv k
where rownum < 4; --Erre késõbb tudunk szûrni, most például az elsõ 3 elem.

--A rownumhoz általában külsõ selectet használunk ami annyi hogy select * from
select * from
(select vezeteknev,keresztnev
from konyvtar.tag
order by vezeteknev desc, keresztnev desc)
where rownum < 11;

--Legfiatalabb tag:
select * from
(select * from konyvtar.tag
order by szuletesi_datum)
where rownum = 1;

--Nem a legjobb.Ne használjuk ahhoz hogy megtudjuk a maxot/mint.
--A rownum csak az oracle-s SQL része.
--A rownum mindig az order by elõtt értékelõdik ki.

--Adatszótárnézetek(Data Dictionary Views/Catalog Views)
--DBA(Database Administrator) -> Adatbázisszintû adatokkal foglalkozik
--User -> User szintû adatokkal foglalkozik
--all -> Bármelyiket végre lehet hajtani.
--V -> statisztikák készítése, hasznos információk az adatbázisról futási idõben is.

--Úgy szerepelnek mint a táblák és úgy is viselkednek tehát írhatunk rájuk lekérdezéseket.
select * from all_tables; -- A rendszer összes táblája amit látni van jogosultságunk.
select * from all_users -- Minden usert visszaad akiket van jogosultságunk látni.
where username = 'U_ABW4BR';

select *from user_tables; -- A jelenlegin user által létrehozott táblákat listázza
select * from user_tab_columns; --Az elõbbi táblák oszlopai.

--Összetett lekérdezések:
--Azok a könyvek amiket nem kölcsönöztek ki. 
select distinct k.cim
from konyvtar.konyv k
join konyvtar.konyvtari_konyv kk
using(konyv_azon)
where kk.leltari_szam not in 
(select leltari_szam from konyvtar.kolcsonzes)
order by 1;

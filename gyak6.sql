select sysdate from dual;
select * from KONYVTAR.konyv; --megjegyzes
select /*komment asdasdasdasd*/ * from dual; --dualnak garantáltan 1 sora van
select sysdate from konyvtar.konyv; --minden sorra külön kiértékeli a sysdate-et, ezért van 51 sor
select sysdate, user, uid, 3*4, cos(3.14) from dual;
select to_char (sysdate, 'YYYY.MM.DD. HH24:MI:SS') from dual; --ha tört máspdpercet akarunk akkor TIMESTAMP kell sysdate helyett és .FF a végére
select to_char (sysdate, 'DS TS') from dual; -- DateShort TimeShort
select to_char (round (sysdate, 'DD'),'DS TS')from dual; --round-dal kerekítünk idõben elõre, napra DD, hónapra MM, évre YYYYec
select to_char (trunc (sysdate, 'MM'),'DS TS')from dual; --trunc-al LEFELÉ kerekítünk
select round (123.56789,-1), trunc(123.56789,2) from dual; -- 2-vel 2 tizedesjegyre kerekítünk, ha nem írunk a "," után semmit, akkor egészre kerekít
select to_char (sysdate +1, 'DS TS') from dual; --hozzáadunk +1 napot a mostani dátumhoz, levonni is lehet "-"al, tört számot is adhatunk hozzá
select to_char (add_months(sysdate, 1), 'DS TS') from dual; --hónapot adunk hozzá 
select (sysdate - to_date('1990.08.18. 21:15', 'YYYY.MM.DD. HH24:MI'))/365,25 from dual; --születési évbõl számoljuk hogy hány évesek vagyunk, napokkal számolva
select months_between(sysdate, to_date('1990.08.18. 21:15', 'YYYY.MM.DD. HH24:MI'))/12 from dual; --születési évbõl számoljuk hogy hány évesek vagyunk, hónapokkal számolva

select cim, ar from KONYVTAR.konyv; --csak a címet és az árat listázzuk ki, az oszlopok sorrendje számít!!
select * from KONYVTAR.konyv where ar > 10000; --ár szerint szûrünk, selectek beágyazhatók más utasításokba és egymásba is

--olvasók vezeték+keresztneve és születési ideje és életkora években mérve egész szám ként akik lefeljebbb 20 évesek:
select vezeteknev, keresztnev, szuletesi_datum from KONYVTAR.tag --eddig jutottam én
--

select vezeteknev, keresztnev, szuletesi_datum,
    round(months_between(sysdate, szuletesi_datum,)/12)
    from KONYVTAR.tag
    where months_between(sysdate, szuletesi_datum)/12 <= 20;
--
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag; --nevek összefûzése, közöttük szóközzel és a fejléc átnevezése
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like 'A%'; --"A"-val kezdõdõ nevek 
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like '%a%a%'; --azok a nevek amiben legalább 2 "a" betû van

select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where lower(vezeteknev || ' ' || keresztnev) like '%a%a%'; --legalább 2 kis "a" van a névben
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like '%a%a%' or
    vezeteknev || ' ' || keresztnev like '%A%A%' or
    vezeteknev || ' ' || keresztnev like '%a%A%' or
    vezeteknev || ' ' || keresztnev like '%A%a%';
    
--irassuk ki azokat a neveket amiben pontosan 2 a betû van, lehet kicsi vagy nagy is
select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
where lower (vezeteknev || ' ' || keresztnev) like '%a%a%'
        and
        not lower (vezeteknev || ' ' || keresztnev) like '%a%a%a%'; --a ()-ek ne maradjanak le!!
--lower (vezeteknev || ' ' || keresztnev) not like '%a%a%a%'; ugyan ez lesz

--2.gyakorlat-------------------------------------------------------------------------------------------------------------

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by keresztnev; -- rendezés abc sorba keresztnevek szerint

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by keresztnev desc; --rendezés abc sorba keresztnevek szerint csökkenõen (descent), ellentettje az "asc", de nem szoktuk kitenni mert ez az alapértelmezett

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by szuletesi_datum; --olyan oszlop szerint is lehet rendezni, ami nem feltétlenül jelenik meg,!!de a táblázatban benne van

select vezeteknev || ' ' || keresztnev nev, szuletesi_datum
from KONYVTAR.tag
order by szuletesi_datum;

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by length (nev);--a név hossza szerint rendezünk

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by 1; --az eredmész elsõ oszlopa szerint rendez (itt név)

select vezeteknev || ' ' || keresztnev nev, szuletesi_datum
from KONYVTAR.tag
order by 2 desc; --az eredmész elsõ oszlopa szerint rendez (itt szul.dátum)

select tema, cim 
    from KONYVTAR.konyv;

select tema, cim 
    from KONYVTAR.konyv
    order by tema nulls first; --a nullokat teszi elõre (ellenkezõje a "nulls last")
    --az order by csak a legvégén áll elõ
    
--azon szerzõ vezeték/kereszt nevére, szül-idejére, valamint életkorára években mérve egész szám ként vagyok kiváncsi, akik több mint 50 évesek és legalább 2 "a" betü van a teljes nevükben, rendezzük vezetéknév majd keresztnév szerint növekvõben

select vezeteknev, keresztnev,to_char(szuletesi_datum, 'ds'),
    round(months_between(sysdate, szuletesi_datum)/12) kor
    from KONYVTAR.szerzo
    where round(months_between(sysdate, szuletesi_datum)/12) > 50
        and
        lower (vezeteknev || keresztnev) like '%a%a%'
    order by vezeteknev, keresztnev;

--azon könyvek címe, isbn száma, kiadás dátuma, témájára, amelyek vagy horror vagy scifi vagy történelem témájúak és ebben az évezredben kerültek kiadásra, rendezzük kiadás dátum szerint csökkenõen

select cim,isbn,TO_CHAR(kiadas_datuma, 'ds'),tema
    from KONYVTAR.konyv
    where tema in ('horror', 'sci-fi', 'történelem') --párja a "not in"
    and
    to_char(kiadas_datuma , 'YYYY') between 2000 and 2999 --párja a "not between"
    order by kiadas_datuma desc;
    
--azoknak a könyveknek az ára, kiadás dátuma, címe, témája, oldalszáma, amely könyvek 1990 és 2000 között kerültek kiadásra vagy a könyv ára 1000 és 3000 huf közé esik vagy 20 oldalnál rövidebb sci-fi, rendezzük téma szerint csökken, azonos témáks esetén oldalszám szerint növekvõ sorrendbe
select ar,to_char(kiadas_datuma, 'ds'),cim,tema,oldalszam
    from KONYVTAR.konyv
    where to_char(kiadas_datuma, 'yyyy') between 1990 and 2000
        or
        ar between 1000 and 3000
        or
        tema = 'sci-fi' and oldalszam <20
    order by tema desc, oldalszam;
    
-- a '%'-jel testszõleges számú karaktert helyettesít, míg az '_'-jel 1 db tetszõleges karaktert helyettesít

select 'igen' from dual where 'almafa' like '%\_%' escape '\'; --a _ joker karaktert keresük az escappel

------------------------gyak 4--------------------------------------------------------

select 'igen' from dual where 'almafa' like '%z%%' escape 'z'; --a % joker karaktert keresük az escappel

select tema from KONYVTAR.konyv where tema !=null; -- nem egyenlõ: <>, !=, ^=, NULL-ra nemm ûködi az egyenlõség/nem egyenlõség vizsgálat
select tema from KONYVTAR.konyv where tema is null;
select tema from KONYVTAR.konyv where tema is not null; --is vagy is not-tal keresünk NULL-ra

--------csoportképzés-----------
select COUNT(*) from KONYVTAR.konyv;  ----megszámolja hány sorunk van, a * jelenti az összes sort
select COUNT(cim) from KONYVTAR.konyv;
select COUNT(ar) from KONYVTAR.konyv; --a NULL értékket nem számolja bele a COUNT
select COUNT(tema) from KONYVTAR.konyv;
select COUNT(*) from KONYVTAR.konyv where tema is not null; --ekvivalens az elõzõ sorral
select COUNT(distinct tema) from KONYVTAR.konyv; ---(különbözõ tema)
select tema from KONYVTAR.konyv;
select distinct tema from KONYVTAR.konyv;-- distinct csak egybõl select után állhat
select DISTINCT ar, tema from KONYVTAR.konyv;
select distinct ar, tema from KONYVTAR.konyv order by 1, 2 ;
select COUNT(*), cim from KONYVTAR.konyv; ---nem lehet egyszerre 2 , hibát kapunk

select count(*), --figyelembe veszi a NULL-t
    min(ar), --mûködik számokra, szövegre(abc szerint), dátumra(legkorábbi)
    max(ar), --ugyan ez
    avg(ar), --már csak numerikus adatoka mûködik
    sum(ar), --ugyan ez, egyik függvény sem veszi figyelembe a NULL-okat adatokat, ha az összes érték NULL-érték, akkor az eredmény is NULL lesz
    min(kiado), --abc-sorrendbe rakja, azért van a HOLNAP kiadó elöl, mert van elõtte egy szóköz
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
    group by tema; --témánként csoportosítjuk
    
select tema,
    min(ar),
    max(ar),
    avg(ar),
    sum(ar),
    min(kiado),
    to_char (max(kiadas_datuma), 'ds') --konvertálhatjuk a formátumot
    from KONYVTAR.konyv
    group by tema;
    
select kiado, count(*) --azoka a kiadók, amikor 300 oldalnál rövidebb könyveket adtank ki 
    from KONYVTAR.konyv
    where oldalszam < 300
    group by kiado;
    
select kiado, tema, count(*)  
    from KONYVTAR.konyv
    group by kiado, tema;

select kiado || tema, count(*) --zinte ugyanaz mint az elõzõ  
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
-- a felíási sorrend csak ez lehet: select, from, where, group by, order by
-- végrehajtási sorrend: from, where, group by, having, select, order by

select TO_CHAR(szuletesi_datum, 'YYYY'), count(*) db --to_car helyett lehet : extract(year from szuletesi_datum)
    from KONYVTAR.tag
    --where nem = 'n'
    group by to_char( szuletesi_datum, 'YYYY')
    having count(*) > 2
    order by db desc;
    

--feladat: egyes irányítószámú helyszinekrõl, hány olvasó van beiratkozva, rendezzunk az eredményt darabszám szerint csökken sorrendbe
select substr('almafa', 3, 2) from dual;

select substr(cim, 1, 4), count (*)
    from konyvtar.tag
    group by substr(cim, 1, 4)
    order by 2 desc;
    
--települések szerint, csoportosítjuk
select substr(cim, 6, instr(cim, ',')-6), count (*)
    from konyvtar.tag
    group by substr(cim, 6, instr(cim, ',')-6)
    order by 2 desc;


-- az egyes szerzõk mennyit kerestek összesen eddig a könyvekbõl, de csak azok akik min 1000000-et kerestek, rendezzük összhonorárium szerint csökkenõben, adjuk meg a szerzõket azonostójuk szerint

select szerzo_azon, sum(honorarium)
    from KONYVTAR.konyvszerzo
    group by szerzo_azon
    having sum(honorarium) >= 1000000
    order by sum(honorarium) desc;
    
select min(szuletesi_datum) --a legöregebb olvasó születési dátuma
    from KONYVTAR.tag;
    
select vezeteknev, keresztnev, szuletesi_datum --a legöregebb olvasó, névvel együtt 
    from KONYVTAR.tag
    where szuletesi_datum = 
        (select min(szuletesi_datum)
        from konyvtar.tag);
        
---------------------------5. gyakorlat----------------------------------------

-----írassuk ki,az egyes leltári számát, értékét, címét és témáját
select count(*) from konyvtar.konyvtari_konyv;
select count(*) from konyvtar.konyv;

select * from konyvtar.konyvtari_konyv, konyvtar.konyv;
select count(*) from konyvtar.konyvtari_konyv, konyvtar.konyv;
select 51*135 from dual;

select * 
    from konyvtar.konyvtari_konyv, konyvtar.konyv
    where KONYVTAR.konyv.konyv_azon = KONYVTAR.konyvtari_konyv.konyv_azon; ---a reprezentációban, a nyíl forrása lesz az elsõdleges, ara hivatkozunk elõször

select * 
    from konyvtar.konyvtari_konyv join konyvtar.konyv
    on KONYVTAR.konyv.konyv_azon = KONYVTAR.konyvtari_konyv.konyv_azon;--- ekvivalens az elõzõvel, join+using együtt
    
select * 
    from konyvtar.konyvtari_konyv k join konyvtar.konyv kk--- alias-t is adhatunk a neveknek, hogy egyszerûsödjön
    on k.konyv_azon = kk.konyv_azon;--- összekapcsolási attribútumok

select * 
    from konyvtar.konyvtari_konyv k join konyvtar.konyv kk----ekvivalens az elõzõvel, join+using együtt
    using (konyv_azon);--a két könyv azonosítóból csak az elsõt tettük be, a másikat kiszûrtük
    
select * 
    from konyvtar.konyvtari_konyv natural join konyvtar.konyv;--magától megkeresi a 2 relációban az azonos nevû oszloppárokat és összekapcsolja õket a keresési feltételekben
    
select * 
    from konyvtar.konyvtari_konyv k join konyvtar.konyv kk
    on k.konyv_azon = kk.konyv_azon
    where tema='krimi';
    

select leltari_szam, ertek, cim, tema
    from konyvtar.konyvtari_konyv k join konyvtar.konyv kk
    on k.konyv_azon = kk.konyv_azon---a feladat megoldása
    where cim = 'Tíz kicsi néger';
    

---------frei tamás mennyit kapott az általa írt egyes könyvekért, külön külön könyvekért---------

select konyv_azon, honorarium, cim, tema 
    from KONYVTAR.szerzo natural join KONYVTAR.konyvszerzo natural join KONYVTAR.konyv
    where vezeteknev || keresztnev = 'FreiTamás';
    
    
----azok a könyvek amelyeket nem hoztak vissza és diákok kölcsönöztek ki, hány példány van

select leltari_szam
    from KONYVTAR.tag join konyvtar.kolcsonzes
    on olvasojegyszam = ;
    
    
    
------------ki írta a tíz kicsi négert?

select keresztnev, vezeteknev
    from KONYVTAR.szerzo natural join KONYVTAR.konyvszerzo natural join KONYVTAR.konyv
    where cim = 'Tíz kicsi néger';
    
--------- milyen témájú konyveket vett ki Vak Ond, egy témát csak egyszer írjuk ki, rendezzük abc sorrendben
select distinct tema ------vagy group by tema
    from konyvtar.tag join KONYVTAR.kolcsonzes
    on olvasojegyszam = tag_azon
    join KONYVTAR.konyvtari_konyv using (leltari_szam)
    join KONYVTAR.konyv using (konyv_azon)
    where vezeteknev || keresztnev = 'VakOnd'
    order by tema;
    
-----------------------6. gyakorlat------------------------------------------------------



-----írassuk ki azok könyvek adatait, amiknek egy példánya sincs a könyvtárban

select * 
    from KONYVTAR.konyv
    where konyv_azon not in
        (select konyv_azon        ---- független alkérdés, ez önmagában is lefuttatható
            from konyvtar.konyvtari_konyv);
            
select * 
    from KONYVTAR.konyv k
    where not exists
        (select *       ---függû alkérdés
            from KONYVTAR.konyvtari_konyv kk
            where kk.konyv_azon = k.konyv_azon);
            
            
----Külsõ öszekapcsolás , outer join-------------

select * 
    from konyvtar.konyv k join KONYVTAR.konyvtari_konyv kk --- itt nem látjuk a lógó sorokat (NULL értékek)
        using (konyv_azon);
        
select * 
    from konyvtar.konyv k full outer join KONYVTAR.konyvtari_konyv kk  ---meg kell adni, hogy left/right/full outer join, de az outer el is hagyható
        using (konyv_azon);


---irassuk ki az összes könyv összes adatát, mellé írva az adott könyv példányainak adataivel, azokat is látni szeretnénk, amiknek nincs példánya
select * 
    from konyvtar.konyv k full outer join KONYVTAR.konyvtari_konyv kk  ---mindig meg kell adni, hogy left/right/full outer join, de az outer el is hagyható
        using (konyv_azon);


---írassuk ki az összes nyugdíjas olvasónkat, valamint azt, hogy milyen leltári számú könyveket kölcsönöztek ki

select vezeteknev, keresztnev, leltari_szam
    from konyvtar.tag left join konyvtar.kolcsonzes
        on olvasojegyszam = tag_azon
    where besorolas ='nyugdíjas';


---irassuk ki az összes szerzõ nevét, mellé azon könyvek azonosítói, amket õk szereztek

select vezeteknev, keresztnev, konyv_azon
    from konyvtar.szerzo left join konyvtar.konyvszerzo
        using (szerzo_azon);
        
------irassuk ki az összes szerzõ nevét, mellé azon könyvek azonosítói, amket õk szereztek, és a könyvek címét is írjuk ki

select vezeteknev, keresztnev, konyv_azon, cim
    from konyvtar.szerzo left join konyvtar.konyvszerzo 
        using (szerzo_azon)
            left join KONYVTAR.konyv
            using (konyv_azon);
            
select vezeteknev, keresztnev, konyv_azon, cim
    from konyvtar.konyvszerzo
        join konyvtar.konyv using (konyv_azon)
        right join konyvtar.szerzo using (szerzo_azon;)
        
---az összes 1000ft-n ál drágább konyvtári példányt és hogy kik ölcsönözék ki, azokat is lássuk, amiket nem kölcsönzött ki senki

select leltari_szam, ertek, vezeteknev, keresztnev
    from konyvtar.konyvtari_konyv left join konyvtar.kolcsonzes 
    using (leltari_szam)
    left join KONYVTAR.tag
    on olvasojegyszam = tag_azon
    where ertek > 1000; 
    
----egyes tagok, hány különbözõ könyvet kölcsönöztek ki
select vezeteknev, keresztnev, count(*) 
    from konyvtar.tag join konyvtar.kolcsonzes
        on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev;
        
---- szeretnénnk, minden ebert látni, azt is aki nem kolcsönzött ki semmit

select vezeteknev, keresztnev, count(kolcsonzesi_datum) ---count csillag sorokat számol 
    from konyvtar.tag left join konyvtar.kolcsonzes
        on olvasojegyszam = tag_azon
        group by olvasojegyszam, vezeteknev, keresztnev;

----átlagosan mekkora az értéke a sci-fi témájú könyvek példányainak

select avg (ertek)
    from konyvtar.konyv join KONYVTAR.konyvtari_konyv
        using (konyv_azon)
            where tema = 'sci-fi';
            

----átlagosan mekkora az értéke a sci-fi témájú könyvek példányainak, számítsuk be azokat a konyveket is, amibõl nincs példányunk, ezeket számoljuk 0 ft-os értékkel

select sum (ertek) / count(*)
    from konyvtar.konyv left join KONYVTAR.konyvtari_konyv ---left join, hogy azok a konyvek is megmaradjanak amiknek nincs könyvtári példánya
        using (konyv_azon)
            where tema = 'sci-fi';
 
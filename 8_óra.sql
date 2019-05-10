--TechOnTheNet --> L�tv�nyosabb mint az oracle doksi.
--Halmazm�veletek:
    --Az attrib�tomok sz�m�nak �s t�pus�nak is meg kell egyezni.
    --Union -> uni�:
        --Az egyforma elemek(ha teljesen megegyeznek) csak egyszer jelennek meg
    --union all:
        --Ez esetben ha van 2 teljesen egyforma elem is, akkor is 2szer jelennek meg
    --intersect -> metszet:
        -- Ami mindk�t t�bl�ban szerepel.
    --minus -> Minusz:
        --Ami az egyikben megtal�lhat�, a m�sikban viszont nem.
        
--Fels� n anal�zis(rownum) -> Arra haszn�latos,hogy az eredm�ny�nk fels� n sor�t kiv�lasszuk.
select k.*,rownum from KONYVTAR.konyv k
where rownum < 4; --Erre k�s�bb tudunk sz�rni, most p�ld�ul az els� 3 elem.

--A rownumhoz �ltal�ban k�ls� selectet haszn�lunk ami annyi hogy select * from
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

--Nem a legjobb.Ne haszn�ljuk ahhoz hogy megtudjuk a maxot/mint.
--A rownum csak az oracle-s SQL r�sze.
--A rownum mindig az order by el�tt �rt�kel�dik ki.

--Adatsz�t�rn�zetek(Data Dictionary Views/Catalog Views)
--DBA(Database Administrator) -> Adatb�zisszint� adatokkal foglalkozik
--User -> User szint� adatokkal foglalkozik
--all -> B�rmelyiket v�gre lehet hajtani.
--V -> statisztik�k k�sz�t�se, hasznos inform�ci�k az adatb�zisr�l fut�si id�ben is.

--�gy szerepelnek mint a t�bl�k �s �gy is viselkednek teh�t �rhatunk r�juk lek�rdez�seket.
select * from all_tables; -- A rendszer �sszes t�bl�ja amit l�tni van jogosults�gunk.
select * from all_users -- Minden usert visszaad akiket van jogosults�gunk l�tni.
where username = 'U_ABW4BR';

select *from user_tables; -- A jelenlegin user �ltal l�trehozott t�bl�kat list�zza
select * from user_tab_columns; --Az el�bbi t�bl�k oszlopai.

--�sszetett lek�rdez�sek:
--Azok a k�nyvek amiket nem k�lcs�n�ztek ki. 
select distinct k.cim
from konyvtar.konyv k
join konyvtar.konyvtari_konyv kk
using(konyv_azon)
where kk.leltari_szam not in 
(select leltari_szam from konyvtar.kolcsonzes)
order by 1;

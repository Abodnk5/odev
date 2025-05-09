use test 
--Bir i�lem (transaction) ba�latmak i�in kullan�l�r. Bu komuttan sonra yap�lan i�lemler,
--COMMIT veya ROLLBACK komutu gelene kadar veritaban�na kaydedilmez.
BEGIN TRANSACTION;


--��lemde yap�lan t�m de�i�iklikleri kal�c� hale getirir.
--Ba�ar�l� �ekilde tamamlanan i�lemleri veritaban�na yans�tmak i�in kullan�l�r.
COMMIT;


--��lem s�ras�nda bir hata olu�tu�unda t�m de�i�iklikleri geri almak i�in kullan�l�r. Veri b�t�nl���n� korumak i�in �nemlidir.
ROLLBACK;



--Sat�rlar �zerinde kilit almadan veri okuma sa�lar. Performans avantaj� sa�lar fakat kirli veri (dirty read) riski vard�r.
SELECT * FROM Musteriler WITH (NOLOCK);



--Sat�rlar �zerinde �zel kilit al�r. Di�er i�lemler bu verilere eri�emez. Kritik g�ncellemelerde veri tutarl�l��� i�in kullan�l�r.

SELECT * FROM Siparisler WITH (XLOCK);



--Yaln�zca ilgili sat�r �zerinde kilit al�r. Ayn� anda birden fazla kullan�c�n�n eri�ti�i sistemlerde �ak��malar� azalt�r.

BEGIN TRANSACTION;
UPDATE Urunler WITH (ROWLOCK) SET Stok = Stok - 1 WHERE UrunID = 10;
COMMIT;


--��lem boyunca t�m tabloyu kilitler. B�y�k hacimli i�lemlerde tutarl�l�k sa�lamak amac�yla kullan�l�r.
SELECT * FROM Stoklar WITH (TABLOCK);


--Sat�rlar� okurken g�ncelleme kilidi al�r. Di�er i�lemlerin ayn� veriyi g�ncellemesini engeller ama okumas�n� engellemez.
SELECT * FROM Kategoriler WITH (UPDLOCK) WHERE KategoriID = 1;


--En y�ksek yal�t�m seviyesi. Phantom read, dirty read gibi durumlar� engeller. Finansal i�lemlerde tercih edilir.

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;




--�ki i�lem birbirinin kilitledi�i kaynaklara eri�meye �al��t���nda kilitlenme (deadlock) olu�ur. Bu �rnek deadlock�un nas�l olu�tu�unu g�sterir.
--1.

BEGIN TRANSACTION;
UPDATE TabloA SET Kolon1 = 'A' WHERE ID = 1;
WAITFOR DELAY '00:00:10';
UPDATE TabloB SET Kolon2 = 'B' WHERE ID = 1;
COMMIT;


--2.

BEGIN TRANSACTION;
UPDATE TabloB SET Kolon2 = 'C' WHERE ID = 1;
WAITFOR DELAY '00:00:10';
UPDATE TabloA SET Kolon1 = 'D' WHERE ID = 1;
COMMIT;









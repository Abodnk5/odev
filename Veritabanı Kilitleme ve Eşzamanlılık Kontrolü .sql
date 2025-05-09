use test 
--Bir iþlem (transaction) baþlatmak için kullanýlýr. Bu komuttan sonra yapýlan iþlemler,
--COMMIT veya ROLLBACK komutu gelene kadar veritabanýna kaydedilmez.
BEGIN TRANSACTION;


--Ýþlemde yapýlan tüm deðiþiklikleri kalýcý hale getirir.
--Baþarýlý þekilde tamamlanan iþlemleri veritabanýna yansýtmak için kullanýlýr.
COMMIT;


--Ýþlem sýrasýnda bir hata oluþtuðunda tüm deðiþiklikleri geri almak için kullanýlýr. Veri bütünlüðünü korumak için önemlidir.
ROLLBACK;



--Satýrlar üzerinde kilit almadan veri okuma saðlar. Performans avantajý saðlar fakat kirli veri (dirty read) riski vardýr.
SELECT * FROM Musteriler WITH (NOLOCK);



--Satýrlar üzerinde özel kilit alýr. Diðer iþlemler bu verilere eriþemez. Kritik güncellemelerde veri tutarlýlýðý için kullanýlýr.

SELECT * FROM Siparisler WITH (XLOCK);



--Yalnýzca ilgili satýr üzerinde kilit alýr. Ayný anda birden fazla kullanýcýnýn eriþtiði sistemlerde çakýþmalarý azaltýr.

BEGIN TRANSACTION;
UPDATE Urunler WITH (ROWLOCK) SET Stok = Stok - 1 WHERE UrunID = 10;
COMMIT;


--Ýþlem boyunca tüm tabloyu kilitler. Büyük hacimli iþlemlerde tutarlýlýk saðlamak amacýyla kullanýlýr.
SELECT * FROM Stoklar WITH (TABLOCK);


--Satýrlarý okurken güncelleme kilidi alýr. Diðer iþlemlerin ayný veriyi güncellemesini engeller ama okumasýný engellemez.
SELECT * FROM Kategoriler WITH (UPDLOCK) WHERE KategoriID = 1;


--En yüksek yalýtým seviyesi. Phantom read, dirty read gibi durumlarý engeller. Finansal iþlemlerde tercih edilir.

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;




--Ýki iþlem birbirinin kilitlediði kaynaklara eriþmeye çalýþtýðýnda kilitlenme (deadlock) oluþur. Bu örnek deadlock’un nasýl oluþtuðunu gösterir.
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









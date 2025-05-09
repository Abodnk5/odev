--1.	Ürün stok adedini kontrol eden
CREATE PROCEDURE CheckProductStock
    @ProductId UNIQUEIDENTIFIER,
    @RequiredQuantity INT,
    @IsAvailable BIT OUTPUT
AS
BEGIN
    DECLARE @CurrentStock INT;
    SELECT @CurrentStock = Stock FROM Product WHERE Id = @ProductId;

    IF @CurrentStock >= @RequiredQuantity
        SET @IsAvailable = 1;
    ELSE
        SET @IsAvailable = 0;
END;


--2.	Ürün satýldýktan sonra stok miktarýný azaltan
CREATE PROCEDURE ReduceProductStock
    @ProductId UNIQUEIDENTIFIER,
    @Quantity INT
AS
BEGIN
    UPDATE Product
    SET Stock = Stock - @Quantity
    WHERE Id = @ProductId AND Stock >= @Quantity;
END;




--3.	Sipariþ oluþturulduysa notification bilgisini çýkaran
CREATE PROCEDURE NotifyOrderCreation
    @OrderId UNIQUEIDENTIFIER,
    @CustomerId UNIQUEIDENTIFIER
AS
BEGIN
    INSERT INTO Notification (Id, OrderId, CustomerId, Message, CreatedAt)
    VALUES (NEWID(), @OrderId, @CustomerId, 'Yeni sipariþ oluþturuldu.', GETDATE());
END;

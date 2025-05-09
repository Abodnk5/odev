--1.	�r�n stok adedini kontrol eden
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


--2.	�r�n sat�ld�ktan sonra stok miktar�n� azaltan
CREATE PROCEDURE ReduceProductStock
    @ProductId UNIQUEIDENTIFIER,
    @Quantity INT
AS
BEGIN
    UPDATE Product
    SET Stock = Stock - @Quantity
    WHERE Id = @ProductId AND Stock >= @Quantity;
END;




--3.	Sipari� olu�turulduysa notification bilgisini ��karan
CREATE PROCEDURE NotifyOrderCreation
    @OrderId UNIQUEIDENTIFIER,
    @CustomerId UNIQUEIDENTIFIER
AS
BEGIN
    INSERT INTO Notification (Id, OrderId, CustomerId, Message, CreatedAt)
    VALUES (NEWID(), @OrderId, @CustomerId, 'Yeni sipari� olu�turuldu.', GETDATE());
END;

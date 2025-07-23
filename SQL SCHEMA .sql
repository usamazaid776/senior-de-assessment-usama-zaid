CREATE TABLE rejected_records (
    OrderID BIGINT NOT NULL,
    ProductID INT NOT NULL,
    SaleAmount DECIMAL(12,2),
    Currency CHAR(3),
    RejectionReason VARCHAR(100) NOT NULL,
    LoggedTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (OrderID, LoggedTimestamp)
);
CREATE TABLE conversion_log (
    RecordID BIGINT NOT NULL,
    OriginalCurrency CHAR(3) NOT NULL,
    SaleAmount_USD DECIMAL(12,2),
    ConversionTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    ConversionRate DECIMAL(10,6),
    RateSource VARCHAR(20),
    PRIMARY KEY (RecordID, ConversionTimestamp),
    INDEX idx_conversion_time (ConversionTimestamp)
);
CREATE TABLE final_cleaned_sales (
    OrderID BIGINT NOT NULL,
    ProductID INT NOT NULL,
    SaleAmount_USD DECIMAL(12,2),
    Currency CHAR(3),
    PRIMARY KEY (OrderID)
);

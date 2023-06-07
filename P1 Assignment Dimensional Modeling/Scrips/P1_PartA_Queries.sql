-- @Title:    P1 Assignment: Dimensional Modeling
-- @Course:   ISM6208.020U23
-- @Date:     June 2023
-- @Authors:  Dalton Anderson & Kevin Hitt 

-- Descriptive/exploratory queries for reference
SELECT COUNT(*) FROM FIN.FRED_UNRATE;
SELECT MIN(RELEASE_DATE_STR), MAX(RELEASE_DATE_STR) FROM FIN.FRED_UNRATE;
SELECT MIN(RELEASE_DATE_STR), MAX(RELEASE_DATE_STR) FROM FIN.FRED_UNRATE;
SELECT MIN(TRADE_DATE_STR), MAX(TRADE_DATE_STR) FROM FIN.SP500_EOD_STOCK_FACTS;
SELECT COUNT(*) FROM FIN.SP500_EOD_STOCK_FACTS;

-- Copying existing tables from FIN schema
-- Our central fact table will be SP500_EOD_STOCK_FACTS 
-- SP500_STOCKS will be a dimension table
CREATE TABLE PEARL_SP500_EOD_STOCK_FACTS AS SELECT * FROM FIN.SP500_EOD_STOCK_FACTS;
CREATE TABLE PEARL_SP500_STOCKS AS SELECT * FROM FIN.SP500_STOCKS;

-- Creating new dimension tables to address assignment scenarios
CREATE TABLE PEARL_STOCK_SPLITS (
    Ticker_Symbol VARCHAR(10),
    Split_Date DATE,
    Split_Ratio DECIMAL(10,2),
    Price_Pre_Split DECIMAL(10,2),
    Price_Post_Split DECIMAL(10,2),
    PRIMARY KEY(Ticker_Symbol, Split_Date)
);

CREATE TABLE PEARL_MERGERS_ACQUISITIONS (
    Acquiring_Company_Ticker VARCHAR(10),
    Acquired_Company_Ticker VARCHAR(10),
    Merger_Acquisition_Date DATE,
    Note VARCHAR(255),
    PRIMARY KEY(Acquiring_Company_Ticker, Acquired_Company_Ticker, Merger_Acquisition_Date)
);

-- Adding a slow changing dimension to the existing table
-- to record history of sector changes
ALTER TABLE PEARL_SP500_STOCKS
ADD (Effective_Date DATE, 
     End_Date DATE, 
     Current_Flag CHAR(1));


-- Row insertion for STOCK_SPLITS hypothetical data
-- (Oracle version does not support inserting multiple rows with a single INSERT statement)
INSERT INTO PEARL_STOCK_SPLITS (Ticker_Symbol, Split_Date, Split_Ratio, Price_Pre_Split, Price_Post_Split)
VALUES ('GOOG', TO_DATE('2009-11-17', 'YYYY-MM-DD'), 1.5, 2000.00, 1333.33);
       
INSERT INTO PEARL_STOCK_SPLITS (Ticker_Symbol, Split_Date, Split_Ratio, Price_Pre_Split, Price_Post_Split)
VALUES ('AAPL', TO_DATE('2009-12-09', 'YYYY-MM-DD'), 2.0, 120.00, 60.00);

INSERT INTO PEARL_STOCK_SPLITS (Ticker_Symbol, Split_Date, Split_Ratio, Price_Pre_Split, Price_Post_Split)
VALUES ('CBS', TO_DATE('2009-11-06', 'YYYY-MM-DD'), 1.5, 2000.00, 1333.33);

INSERT INTO PEARL_STOCK_SPLITS (Ticker_Symbol, Split_Date, Split_Ratio, Price_Pre_Split, Price_Post_Split)
VALUES ('MSFT', TO_DATE('2009-12-02', 'YYYY-MM-DD'), 2.0, 220.00, 110.00);


-- Row insertion for MERGERS_ACQUISITIONS hypothetical data 
-- (Oracle version does not support inserting multiple rows with a single INSERT statement)
INSERT INTO PEARL_MERGERS_ACQUISITIONS (Acquiring_Company_Ticker, Acquired_Company_Ticker, Merger_Acquisition_Date, Note)
VALUES ('GOOG', 'YTBE', TO_DATE('2019-11-01', 'YYYY-MM-DD'), 'Google acquires YouTube');

INSERT INTO PEARL_MERGERS_ACQUISITIONS (Acquiring_Company_Ticker, Acquired_Company_Ticker, Merger_Acquisition_Date, Note)
VALUES ('AAPL', 'NXTM', TO_DATE('2018-06-01', 'YYYY-MM-DD'), 'Apple acquires NeXT');

INSERT INTO PEARL_MERGERS_ACQUISITIONS (Acquiring_Company_Ticker, Acquired_Company_Ticker, Merger_Acquisition_Date, Note)
VALUES ('FB', 'INST', TO_DATE('2012-04-01', 'YYYY-MM-DD'), 'Facebook acquires Instagram');

INSERT INTO PEARL_MERGERS_ACQUISITIONS (Acquiring_Company_Ticker, Acquired_Company_Ticker, Merger_Acquisition_Date, Note)
VALUES ('MSFT', 'LNKD', TO_DATE('2016-12-01', 'YYYY-MM-DD'), 'Microsoft acquires LinkedIn');

INSERT INTO PEARL_MERGERS_ACQUISITIONS (Acquiring_Company_Ticker, Acquired_Company_Ticker, Merger_Acquisition_Date, Note)
VALUES ('AMZN', 'WFMI', TO_DATE('2017-08-01', 'YYYY-MM-DD'), 'Amazon acquires Whole Foods');


-- Adding new table from Federal Reserve Economic Data (FRED)
CREATE TABLE PEARL_UNRATE AS SELECT * FROM FIN.FRED_UNRATE;


-- Query 1: Analyzing the effect of stock splits on stock price:
-- This query gives the closing price of the stock on the day of the split.
SELECT S.Ticker_Symbol, S.Split_Date, 
       S.Price_Pre_Split, S.Price_Post_Split,
       F.Close
FROM PEARL_STOCK_SPLITS S
JOIN PEARL_SP500_EOD_STOCK_FACTS F
ON S.Ticker_Symbol = F.Ticker_Symbol AND 
   S.Split_Date = F.Trade_Date;


-- Query 2: Finding the correlation between unemployment rate and overall stock market performance:
-- This query gives the average closing price of stocks for each unique unemployment rate.
SELECT U.UNRATE_PERCENT, AVG(F.Close) AS Average_Close_Price
FROM PEARL_UNRATE U
JOIN PEARL_SP500_EOD_STOCK_FACTS F
ON TO_CHAR(U.RELEASE_DATE, 'DD-MON-YY') = F.Trade_Date
GROUP BY U.UNRATE_PERCENT
ORDER BY U.UNRATE_PERCENT;


-- Query 3: Analyzing the likelihood of a company in a certain sector to perform a stock split or be involved in a merger or acquisition:
-- This query gives the number of stock splits that have occurred in each sector.
SELECT T.GICS_Sector, COUNT(*) AS Split_Count
FROM PEARL_STOCK_SPLITS S
JOIN PEARL_SP500_STOCKS T
ON S.Ticker_Symbol = T.Ticker_Symbol
GROUP BY T.GICS_Sector
ORDER BY Split_Count DESC;

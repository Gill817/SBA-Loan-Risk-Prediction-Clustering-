
SELECT TOP 10 * FROM sba_loans;
SELECT TOP 10 * FROM sba_loans_cleaned;


SELECT 
    a.Program,
    a.BankName,
    a.ProjectState,
    a.GrossApproval,
    a.ApprovalFY,
    b.Cluster,
    b.DefaultFlag,
    b.InterestRate,
    b.BusinessType_encoded,
    b.NAICSDescription_encoded
FROM sba_loans AS a
INNER JOIN sba_loans_cleaned AS b
    ON a.BankName = b.BankName
    AND a.ProjectState = b.ProjectState;


SELECT 
    a.Program,
    a.BankName,
    a.ProjectState,
    a.GrossApproval,
    b.Cluster,
    b.DefaultFlag,
    b.InterestRate
FROM sba_loans AS a
LEFT JOIN sba_loans_cleaned AS b
    ON a.BankName = b.BankName;

--state chekc
SELECT 
    a.ProjectState,
    COUNT(*) AS Total_Loans,
    ROUND(AVG(a.GrossApproval), 2) AS Avg_Approval,
    ROUND(AVG(b.InterestRate), 2) AS Avg_Interest,
    SUM(CASE WHEN b.DefaultFlag = 1 THEN 1 ELSE 0 END) AS Defaults,
    ROUND(AVG(b.DefaultFlag) * 100, 2) AS Default_Rate_Percent
FROM sba_loans a
JOIN sba_loans_cleaned b
    ON a.BankName = b.BankName
GROUP BY a.ProjectState
ORDER BY Default_Rate_Percent DESC;


--industries check
SELECT 
    b.NAICSDescription AS Industry,
    COUNT(*) AS Total_Loans,
    ROUND(AVG(a.GrossApproval), 2) AS Avg_Loan_Amount,
    ROUND(AVG(b.DefaultFlag) * 100, 2) AS Default_Rate_Percent
FROM sba_loans a
JOIN sba_loans_cleaned b
    ON a.NAICSDescription = b.NAICSDescription
GROUP BY b.NAICSDescription
ORDER BY Default_Rate_Percent DESC;


--highest banking 
SELECT 
    a.BankName,
    COUNT(*) AS Total_Loans,
    ROUND(AVG(a.GrossApproval), 2) AS Avg_Loan,
    SUM(CASE WHEN b.DefaultFlag = 1 THEN 1 ELSE 0 END) AS Total_Defaults,
    ROUND(AVG(b.DefaultFlag) * 100, 2) AS Default_Rate_Percent
FROM sba_loans a
JOIN sba_loans_cleaned b
    ON a.BankName = b.BankName
GROUP BY a.BankName
HAVING COUNT(*) > 10
ORDER BY Default_Rate_Percent DESC;


-yearly analysis
SELECT 
    a.ApprovalFY AS Year,
    COUNT(*) AS Total_Loans,
    ROUND(AVG(a.GrossApproval), 2) AS Avg_Loan_Amount,
    ROUND(AVG(b.DefaultFlag) * 100, 2) AS Default_Rate_Percent
FROM sba_loans a
JOIN sba_loans_cleaned b
    ON a.BankName = b.BankName
GROUP BY a.ApprovalFY
ORDER BY a.ApprovalFY;


-top loan to guranate ratio 
SELECT 
    a.ProjectState,
    ROUND(AVG(b.LoanToGuaranteeRatio), 2) AS Avg_Ratio,
    ROUND(AVG(b.DefaultFlag) * 100, 2) AS Default_Rate_Percent
FROM sba_loans a
JOIN sba_loans_cleaned b
    ON a.ProjectState = b.ProjectState
GROUP BY a.ProjectState
ORDER BY Avg_Ratio DESC;



SELECT COUNT(*) AS Total_Rows_Raw FROM sba_loans;
SELECT COUNT(*) AS Total_Rows_Cleaned FROM sba_loans_cleaned;

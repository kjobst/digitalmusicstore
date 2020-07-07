/*Q1*/--Used for Insight 1
SELECT  g.name as Genre,
        iL.UnitPrice* SUM(iL.Quantity) as Sales
FROM InvoiceLine IL
JOIN Track T
ON t.TrackId=iL.TrackId
JOIN GENRE g
ON t.genreid=g.genreid
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/*Q2*/--Used for Insight 2
SELECT ar.name Artist,
			g.name genre,
			COUNT (*)  Songs_per_genre,
			SUM (COUNT (*)) OVER (PARTITION by g.name ) GenreTotalCount
	FROM GENRE g
	JOIN Track t
	ON t.genreid=g.genreid
	JOIN Album al
	ON t.albumid=al.albumid
	JOIN Artist ar
	ON al.ARTISTid=ar.artistid
	WHERE genre = 'Rock' OR genre= 'Latin'
	GROUP BY 2,1
	order by 2,3 desc;

/*Q3*/--Used for Insight 3
WITH T1 AS (SELECT ar.name  as artist,
				           g.name as Genre,
				           iL.UnitPrice* SUM(iL.Quantity) as PurchaseAmount

        		FROM InvoiceLine iL
        		JOIN Track T
        		ON il.trackid=t.TrackId
        		JOIN GENRE g
        		ON t.genreid=g.genreid
        		JOIN Album al
        		ON t.albumid=al.albumid
        		JOIN Artist ar
        		ON al.ARTISTid=ar.artistid
				WHERE genre ='Rock' OR genre='Latin'
        		GROUP BY 1,2
        		ORDER BY 3 DESC)

SELECT t1.artist,
			t1.genre,
			SUM(purchaseAmount) artistsalespergenre,
			SUM (SUM(purchaseAmount)) OVER (Partition by t1.artist ) as totalperartist,
			SUM (SUM(purchaseAmount)) OVER (Partition by t1.genre) as totalpergenre
FROM T1
group by 2,1
order by 2, 4 desc;

/*Q4*/-- Used for Insight 4
WITH T1 AS (SELECT i.invoiceid,
									 strftime ('%Y',i.InvoiceDate) AS YEAR ,
									 g.name as Genre,
									 iL.UnitPrice* SUM(iL.Quantity) as PurchaseAmount
						FROM Invoice i
						JOIN InvoiceLine iL
						ON i.invoiceid = iL.invoiceid
						JOIN Track T
						ON t.TrackId=iL.TrackId
						JOIN GENRE g
						ON t.genreid=g.genreid
						WHERE genre='Rock' OR genre='Latin'
						GROUP BY 1,2,3
						ORDER BY 4 DESC)

SELECT t1.genre,
			t1.year,
			SUM(purchaseAmount) as salesperyear
FROM T1

CREATE DATABASE QLBH
GO
USE QLBH
GO
CREATE TABLE KHACHHANG(
	MAKH char(4) CONSTRAINT PK_KH PRIMARY KEY,
	HOTEN varchar(40) NOT NULL,
	DCHI varchar(50),
	SODT varchar(20),
	NGSINH smalldatetime,
	DOANHSO money,
	NGDK smalldatetime,
)
CREATE TABLE NHANVIEN (
	MANV char(4) CONSTRAINT PK_NV PRIMARY KEY,
	HOTEN varchar(40) NOT NULL,
	SODT varchar(20),
	NGVL SMALLdatetime,
)
CREATE TABLE SANPHAM (
	MASP char(4) CONSTRAINT PK_SP PRIMARY KEY,
		TENSP varchar(40) NOT NULL,
	DVT varchar(20),
	NUOCSX varchar(40),
	GIA money,
)
CREATE TABLE HOADON (
	SOHD int CONSTRAINT PK_HD PRIMARY KEY,
	NGHD smalldatetime,
	MAKH char(4) ,
	MANV char(4) ,
	TRIGIA money,
)
CREATE TABLE CTHD (
	SOHD int,
	MASP char(4),
	SL int CONSTRAINT PK_CTHD PRIMARY KEY(SOHD, MASP),
)

--1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TrungQuoc'

--2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE DVT = 'cay'
INTERSECT
SELECT MASP, TENSP
FROM SANPHAM
WHERE DVT = 'quyen'

--3. In ra danh sách các sản phẩm (MASP,TENSP) có
--mã sản phẩm bắt đầu là “B” và kết thúc là “01”. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE 'B_01'

--4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất 
--có giá từ 30.000 đến 40.000. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA BETWEEN 30000 AND 40000

--5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” 
--sản xuất có giá từ 30.000 đến 40.000. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX IN ('TrungQuoc','ThaiLan') 
			AND (GIA BETWEEN 30000 AND 40000)

--6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007. 
SELECT SOHD,TRIGIA
FROM HOADON
WHERE NGHD IN ('1/1/2007', '2/1/2007')

--7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, 
--sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần). 
SELECT SOHD, TRIGIA
FROM HOADON
WHERE MONTH(NGHD) = 1 AND YEAR(NGHD) = 2007
ORDER BY DAY(NGHD), TRIGIA DESC

--8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007. 
SELECT KH.MAKH, KH.HOTEN
FROM KHACHHANG AS KH, HOADON AS HD
WHERE KH.MAKH = HD.MAKH 
	AND NGHD = '1/1/2007'

--9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” 
--lập trong ngày 28/10/2006. 
SELECT HD.SOHD, HD.TRIGIA
FROM HOADON AS HD, NHANVIEN AS NV
WHERE HD.MANV = NV.MANV 
	AND HOTEN = 'Nguyen Van B' AND NGHD = '28/10/2006'

--10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” 
--mua trong tháng 10/2006. 
SELECT SP.MASP, SP.TENSP
FROM HOADON AS HD, KHACHHANG AS KH, SANPHAM AS SP, CTHD
WHERE HD.MAKH = KH.MAKH AND CTHD.SOHD = HD.SOHD AND CTHD.MASP = SP.MASP 
	AND HOTEN = 'Nguyen Van A' AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006

--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”. 
SELECT CTHD.SOHD
FROM HOADON AS HD, SANPHAM AS SP, CTHD
WHERE HD.SOHD =CTHD.SOHD AND CTHD.MASP = SP.MASP 
	AND (SP.MASP = 'BB01' OR SP.MASP = 'BB02')

--12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”,
--mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE CTHD.MASP='BB01' AND (SL BETWEEN 10 AND 20)
UNION
SELECT SOHD
FROM CTHD
WHERE CTHD.MASP='BB02' AND (SL BETWEEN 10 AND 20)

--13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, 
--mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE CTHD.MASP='BB01' AND (SL BETWEEN 10 AND 20)
INTERSECT
SELECT SOHD
FROM CTHD
WHERE CTHD.MASP='BB02' AND (SL BETWEEN 10 AND 20)

--14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất 
--hoặc các sản phẩm được bán ra trong ngày 1/1/2007. 
SELECT SP.MASP, TENSP
FROM SANPHAM SP, CTHD, HOADON HD
WHERE SP.MASP = CTHD.MASP AND HD.SOHD = CTHD.SOHD
	AND (NUOCSX = 'TrungQuoc' OR NGHD = '01/01/2007')

--15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được. 
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT SP.MASP, SP.TENSP
FROM SANPHAM AS SP,CTHD
WHERE CTHD.MASP = SP.MASP

--16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006. 
SELECT MASP, TENSP
FROM SANPHAM SP
WHERE NOT EXISTS 	
	(SELECT *
	FROM CTHD, HOADON HD
	WHERE CTHD.SOHD = HD.SOHD AND  SP.MASP = CTHD.MASP
		AND YEAR(NGHD) = 2006)

--17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất 
--không bán được trong năm 2006. 
SELECT MASP, TENSP
FROM SANPHAM SP
WHERE NUOCSX = 'TrungQuoc' AND NOT EXISTS 	
		(SELECT *
		FROM CTHD, HOADON HD
		WHERE CTHD.SOHD = HD.SOHD AND SP.MASP = CTHD.MASP
			AND YEAR(NGHD) = 2006)

--18. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT DISTINCT CTHD.SOHD
FROM CTHD, HOADON HD, SANPHAM SP
WHERE HD.SOHD = CTHD.SOHD AND SP.MASP = CTHD.MASP
	AND YEAR(NGHD) ='2006' AND NUOCSX = 'Singapore'

--19. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua? 
SELECT COUNT(SOHD)
FROM HOADON HD, KHACHHANG KH
WHERE HD.MAKH=KH.MAKH AND NGDK IS NULL

--20. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006. 
SELECT COUNT(DISTINCT(MASP)) AS SoSanPhamKhacNhau
FROM CTHD, HOADON HD
WHERE CTHD.SOHD=HD.SOHD AND YEAR(NGHD)=2006

--21. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu? 
SELECT MAX(TRIGIA) AS TriGiaHoaDon_CaoNhat, 
	   MIN(TRIGIA) AS TriGiaHoaDon_ThapNhat
FROM HOADON

--22. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AS TriGiaTrungBinhHoaDon_Nam2006
FROM HOADON
WHERE YEAR(NGHD) = 2006

--23. Tính doanh thu bán hàng trong năm 2006. 
SELECT SUM(TRIGIA) AS DoanhThu
FROM HOADON
WHERE YEAR(NGHD) = 2006

--24. Tìm số hóa đơn có trị giá cao nhất trong năm 2006. 
SELECT MAX(TRIGIA) AS TriGiaHoaDon_CaoNhat
FROM HOADON
WHERE YEAR(NGHD) = '2006'

--25. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN
FROM KHACHHANG KH, HOADON HD
WHERE KH.MAKH = HD.MAKH AND YEAR(NGHD) = '2006' 
		AND TRIGIA >= 
		(SELECT MAX(TRIGIA)
		FROM HOADON
		WHERE YEAR(NGHD) = '2006')

--26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất. 
--(Bit nhiu hoy)
SELECT TOP 3 MAKH , HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC

--27. In ra danh sách các sản phẩm (MASP, TENSP) 
--có giá bán bằng 1 trong 3 mức giá cao nhất. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA = ANY (
		SELECT TOP 3 GIA
		FROM SANPHAM 
		ORDER BY GIA DESC)

--28. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất
--có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm). 
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'THAILAN' AND GIA = ANY (
		SELECT TOP 3 GIA
		FROM SANPHAM 
		ORDER BY GIA DESC)

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất 
--có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất). 
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC' AND GIA = ANY (
		SELECT TOP 3 GIA
		FROM SANPHAM 
		WHERE NUOCSX = 'TRUNGQUOC'
		ORDER BY GIA DESC)

--30. * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
--(:'> ????)
SELECT TOP 3 MAKH , HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC

--THAM KHAO HOY
SELECT TOP 3 KH.MAKH, HOTEN, SUM(TRIGIA) DOANHSO
FROM KHACHHANG KH, HOADON HD
WHERE KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, HOTEN
ORDER BY SUM(TRIGIA) DESC

--31. Tính tổng số sản phẩm do “Trung Quoc” sản xuất. 
SELECT COUNT(MASP) AS SoPS_TQ
FROM SANPHAM
WHERE NUOCSX='TRUNGQUOC'

--32. Tính tổng số sản phẩm của từng nước sản xuất. 
SELECT NUOCSX, COUNT(MASP) AS TongSP
FROM SANPHAM
GROUP BY NUOCSX

--33. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm. 
SELECT NUOCSX, MAX(GIA) AS GiaBan_CaoNhat, 
			   MIN(GIA) AS GiaBan_ThapNhat, 
			   AVG(GIA) AS GiaBan_TrungBinh
FROM SANPHAM
GROUP BY NUOCSX

--34. Tính doanh thu bán hàng mỗi ngày. 
SELECT NGHD, SUM(TRIGIA) AS DoanhThu
FROM HOADON
GROUP BY NGHD

--35. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006. 
SELECT MASP, SUM(SL) AS SOLUONGBANRA
FROM CTHD, HOADON HD
WHERE CTHD.SOHD=HD.SOHD 
	AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
GROUP BY MASP

--36. Tính doanh thu bán hàng của từng tháng trong năm 2006. 
SELECT MONTH(NGHD) AS Thang,
	   SUM(TRIGIA) AS DoanhThu
FROM HOADON
WHERE YEAR(NGHD)=2006
GROUP BY MONTH(NGHD)

--37. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau. 
SELECT HD.SOHD
FROM HOADON HD, CTHD
WHERE HD.SOHD = CTHD.SOHD
GROUP BY HD.SOHD
HAVING COUNT(MASP) >= 4

--38. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau). 
SELECT HD.SOHD
FROM HOADON HD, CTHD, SANPHAM SP
WHERE HD.SOHD = CTHD.SOHD AND SP.MASP = CTHD.MASP 
	AND NUOCSX = 'VIETNAM'
GROUP BY HD.SOHD
HAVING COUNT(CTHD.MASP) = 3

--39. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất. 
SELECT TOP 1 KH.MAKH, HOTEN
FROM KHACHHANG KH, HOADON HD
WHERE KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, HOTEN
ORDER BY COUNT(HD.SOHD) DESC

--40. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất? 
SELECT TOP 1 MONTH(NGHD) THANG, SUM(TRIGIA) DOANHSO
FROM HOADON
GROUP BY MONTH(NGHD)

--41. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006
SELECT TOP 1 SP.MASP, TENSP 
FROM SANPHAM SP, HOADON HD
WHERE YEAR(NGHD) = '2006'
GROUP BY SP.MASP, TENSP
ORDER BY SUM(TRIGIA)

--42. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA = ANY (
	SELECT MAX(GIA)
	FROM SANPHAM
	GROUP BY NUOCSX)

--43. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau. 
SELECT NUOCSX
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) > 2

--44. *Trong 10 khách hàng có doanh số cao nhất, 
--tìm khách hàng có số lần mua hàng nhiều nhất. 
SELECT TOP 1 MAKH ,HOTEN 
FROM (
		SELECT TOP 10 KHACHHANG.MAKH , KHACHHANG.HOTEN , COUNT(HOADON.MAKH) AS SL
		FROM  KHACHHANG JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
		GROUP BY KHACHHANG.MAKH , KHACHHANG.DOANHSO , KHACHHANG.HOTEN
		ORDER BY KHACHHANG.DOANHSO DESC
		) KH
ORDER BY SL DESC

create database studenttest;
use studenttest;
# 1.	Tạo 3 bảng và chèn dữ liệu như hình dưới đây:
create table Student(
                        RN int not null auto_increment primary key ,
                        Name varchar(20) not null ,
                        Age tinyint not null
);
create table Test(
                     testID int not null auto_increment primary key ,
                     names varchar(20) not null
);
create table StudentTest(
                            rN int not null ,
                            TestID int not null ,
                            Date datetime,
                            Mark float not null,
                            primary key (rN, TestID),
                            foreign key (rN) references Student(RN),
                            foreign key (TestID) references Test(TestID)
);


# 2.	Sử dụng alter để sửa đổi:
# a.	Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55
# b.	Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
# c.	Thêm khóa chính cho bảng studenttest là (RN,TestID)
# d.	Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
# e.	Xóa ràng buộc duy nhất (unique) trên bảng Test

# a:
alter table Student add constraint check_age check (Age between 15 and 55);
# b:
alter table StudentTest alter Mark set default 0;
# c:
# Show diagram is OK
# d:
alter table Test add constraint only_name unique (names); #only_name la ten rang buoc duy nhat
# e:
# alter table Test drop constraint only_name; #Báo đỏ vì chưa chạy tên ràng buộc :)

# 3. Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi giống như hình sau:
select Name as "Student Name", names as "Test Name", Mark as "Mark", Date as "Date"
from Student s, StudentTest s_t, Test t
where s_t.RN = s.RN and s_t.TestID = t.testID;

# 4. Hiển thị danh sách các bạn học viên chưa thi môn nào như hình sau:
SELECT * FROM   Student
WHERE NOT EXISTS (SELECT * FROM   StudentTest WHERE  StudentTest.RN = Student.RN);

#5. Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5) như sau:
select Name as "Student Name", names as "Test Name", Mark as "Mark", Date as "Date"
from Student s, StudentTest s_t, Test t
where s_t.RN = s.RN and s_t.TestID = t.testID and Mark < 5;

#6. Hiển thị danh sách học viên và điểm trung bình (Average) của các môn đã thi. Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần(nếu không sắp xếp thì chỉ được ½ số điểm) như sau:
SELECT s.name, AVG(s_t.Mark) "Average"
FROM Student s, StudentTest s_t where s_t.RN = s.RN  GROUP BY  s_t.RN order by AVG(mark) desc;

#7. Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
select s.name,  max(avg_mark) "Max Mark"
from Student s, (select  avg(Mark) AS avg_mark
                 from StudentTest s_t, Student s where s_t.RN = s.RN
                 group by s_t.RN) As maxMark;

select Student.Name, max(avg_mark) from Student, (select avg(Mark) as avg_mark from StudentTest
                                                                                        join student on StudentTest.rN = Student.RN group by StudentTest.rN) as maxMark;

#8. Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học như sau:
select test.names, max(mark) as "Max Mark" from StudentTest join test on StudentTest.TestID = test.testID group by Test.names order by Test.names;

#9. Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null như sau:
select student.name, test.names from StudentTest right join student on StudentTest.rN = student.RN left join test on StudentTest.testID = test.testID;

#10. Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi:
UPDATE Student SET Age = Age + 1;

#11. Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student:
alter table Student add status varchar(10);
select * from Student;

#12. Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’,
# trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student.
update student set status = case when Student.Age < 30 then 'Young' else 'Old' END;

update Student set Status = (case when Age < 30 then 'Young' when Age > 30 then 'Old'end);

#13. Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi như sau:
select Name as "Student Name", names as "Test Name", Mark as "Mark", Date as "Date"
from Student s, StudentTest s_t, Test t
where s_t.RN = s.RN and s_t.TestID = t.testID order by s_t.Date and s.Name;

#14 Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5. Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình:

select student.name, avg(mark) as avgmark from StudentTest
                                                   join student on StudentTest.rN = Student.RN where Name like 'T%' group by StudentTest.rN having avgmark > 4.5;
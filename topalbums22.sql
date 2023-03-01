create database topalbums;

use topalbums;

create table genres
(
genre_id int PRIMARY KEY,
gname varchar(50),
gdescription varchar(200)
);

create table labels
(
label_id int PRIMARY KEY,
lname varchar(50),
hqlocation varchar(50),
revenue int
);

create table artists
(
artist_id int PRIMARY KEY,
aname varchar(70),
age int
);

create table albums
(
album_id int PRIMARY KEY,
title varchar(70),
artist_id int,
releasedate date,
label_id int,
genre_id int, 
FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
FOREIGN KEY (label_id) REFERENCES labels(label_id),
FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

create table topspotifyalbums22
(
aposition int,
artist_id int,
album_id int,
streams int,
FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
FOREIGN KEY (album_id) REFERENCES albums(album_id)
);


insert into genres
(genre_id, gname, gdescription)
values
(1, 'reggaeton', 'originated in Panama from dancehall, influenced by hip-hop, Latin American and Caribbean music'),
(2, 'pop', 'originated in mid-50s in USA and UK, usually includes repeated choruses and hooks, written in a basic format with rhythms easily danced to'),
(3, 'r&b', ' features a distinctive production style, drum machine-backed rhythms, pitch corrected vocals, and a smooth, lush style of vocal arrangement'),
(4, 'latin', 'a catch-all category for various styles of music from Ibero-America and the Latino United States inspired by Latin American, Spanish and Portuguese music genres'),
(5, 'hip hop', 'originated in New York City in the 1970s, consists of stylized rhythmic music that commonly accompanies rapping, a rhythmic and rhyming speech that is chanted');

select * from genres;

insert into labels
(label_id, lname, hqlocation, revenue)
values
(1, 'Rimas', 'San Juan, Puerto Rico', 13000000),
(2, 'Columbia', 'New York City, New York', 34000000),
(3, 'Republic', 'New York City, New York', 625000000),
(4, 'RCA', 'Pennsylvania', 385000000),
(5, 'UMLE', 'Los Angeles, California', 7500000),
(6, 'Warner', 'Los Angeles, California', 590000000),
(7, 'Interscope', 'Santa Monica, California', 710000000);

select * from labels;

insert into artists
(artist_id, aname, age)
values
(1, 'Bad Bunny', 28),
(2, 'Harry Styles', 28),
(3, 'Taylor Swift', 33),
(4, 'The Weeknd', 32),
(5, 'SZA', 33),
(6, 'Sebastian Yatra', 28),
(7, 'Rosalia', 29),
(8, 'Ali Gatie', 25),
(9, 'Post Malone', 27),
(10, 'Kendrick Lamar', 35);

select * from artists;

insert into albums
(album_id, title, artist_id, releasedate, label_id, genre_id)
values
(213, 'Un Verano Sin Ti', 1, '2022-05-06', 1, 1),
(324, 'Harrys House', 2, '2022-05-20', 2, 2),
(435, 'Midnights', 3, '2022-10-21', 3, 2),
(546, 'Dawn FM', 4, '2022-01-07', 3, 2),
(657, 'SOS', 5, '2022-12-09', 4, 3),
(768, 'Dharma', 6, '2022-01-28', 5, 4),
(879, 'Motomami', 7, '2022-03-18', 2, 1),
(980, 'Who hurt you?', 8, '2022-08-12', 6, 4),
(102, 'Twelve Carat Toothache', 9, '2022-06-03', 3, 2),
(123, 'Mr.Morale and the Big Steppers', 10, '2022-05-13', 7, 5);

select * from albums;

insert into topspotifyalbums22
(aposition, artist_id, album_id, streams)
values
(1, 1, 213, 10845127),
(2, 2, 324, 4314597),
(3, 3, 435, 3114888),
(4, 4, 546, 2614173),
(5, 5, 657, 2203993),
(6, 6, 768, 2198897),
(7, 7, 879, 1666098),
(8, 8, 980, 1641995),
(9, 9, 102, 1531650),
(10, 10, 123, 1432704);

select * from topspotifyalbums22;

/* CORE/ADVANCED Here I have created a view that replaces the foreign keys in the topspotifyalbums22 table with the names of artists and albums.*/
create view vwTop10
as
	select topspotifyalbums22.aposition as ChartPosition, artists.aname as ArtistName, albums.title as AlbumTitle, topspotifyalbums22.streams as NumberOfStreamsIn2022
	from topspotifyalbums22
	inner join artists on artists.artist_id = topspotifyalbums22.artist_id
	inner join albums on albums.album_id = topspotifyalbums22.album_id
	order by topspotifyalbums22.aposition;

select * from vwTop10;

/*CORE Below is a function that shows how many days have passed since an album was released.*/
DELIMITER //
create function days_since_release (album_id INT)
returns INT
DETERMINISTIC

BEGIN
    DECLARE days INT;
    SET days = DATEDIFF(CURDATE(), (SELECT releasedate FROM albums WHERE album_id = albums.album_id));
    RETURN days;
END //
DELIMITER ;

select days_since_release(435);

/*CORE Here is a query with a subquery to find albums with labels in California.*/
select title as AlbumsLabelInCalifornia
from albums
where label_id in(
	select label_id from labels 
    where hqlocation like '%California');


/*ADVANCED Below is a procedure to combine tables to show the list of albums with details for label and artist*/    
DELIMITER //

create procedure album_list()
begin
	select albums.title as Title, artists.aname as Artist, albums.releasedate as ReleaseDate, labels.lname as Label
	from albums
	inner join artists on artists.artist_id = albums.artist_id
	inner join labels on labels.label_id = albums.label_id;
    
end //
DELIMITER ;

call album_list();
    
/*ADVANCED Find stream total per label, only showing labels where streams exceed 5,000,000, using group by and having*/
select labels.lname, sum(topspotifyalbums22.streams)
from albums
	inner join labels on albums.label_id = labels.label_id
	inner join topspotifyalbums22 on topspotifyalbums22.album_id = albums.album_id
group by labels.lname
having sum(topspotifyalbums22.streams) > 5000000;





--search user name with email address
SELECT password,fname, lname FROM Users WHERE email = ${email};

--select all user's friends
SELECT  * 
FROM Friends
WHERE uid = ${user id}

--search photos by tags
SELECT t.pid, COUNT(CASE WHEN t.text=${tag1} AND t.pid=p.pid THEN 1 ELSE NULL END) +
       COUNT(CASE WHEN t.text=${tag2} AND t.pid=p.pid THEN 1 ELSE NULL END) +
       COUNT(CASE WHEN t.text=${tag3} AND t.pid=p.pid THEN 1 ELSE NULL END) + 
       COUNT(CASE WHEN t.text=${tag4} AND t.pid=p.pid THEN 1 ELSE NULL END) +
       COUNT(CASE WHEN t.text=${tag5} AND t.pid=p.pid THEN 1 ELSE NULL END) AS fulfilled_conditions
FROM Tags t
JOIN Photos p on t.pid = p.pid
WHERE (t.text=${tag1} AND t.pid=p.pid) 
    OR (t.text=${tag2} AND t.pid=p.pid) 
    OR (t.text=${tag3} AND t.pid=p.pid)
    OR (t.text=${tag4} AND t.pid=p.pid)
    OR (t.text=${tag5} AND t.pid=p.pid)
GROUP BY t.pid;

--search all photos with given tags owned by a user
SELECT p.* 
FROM tags t, photos p, albums a
WHERE t.pid = p.pid AND t.text = ${tag} AND a.aid = p.aid AND a.uid = ${user_id};

--search user name with their name
SELECT fname,lname
FROM Users
WHERE fname LIKE ‘${firstName}%’

--find highest contribution score in descending order
SELECT COALESCE(pCount.uid, cCount.uid) as UID, COALESCE(pCount.count, 0) + COALESCE(cCount.count,0) as Contribution
FROM (SELECT uid, COUNT(uid) 
FROM Albums a
JOIN Photos p ON a.aid = p.aid
GROUP BY uid) as pCount
FULL JOIN (SELECT uid, COUNT(uid) 
FROM Coments c
GROUP BY uid) as cCount ON pCount.uid = cCount.uid
ORDER BY Contribution DESC;

--search for photos of the user
SELECT  Users.fname, Users.lname, Photos.phdata
FROM  ((Users
INNER JOIN albums ON albums.uid = Users.uid)
INNER JOIN Photos ON albums.aid = Photos.aid);

--search recently posted/added photos
SELECT p.* 
FROM photos p, albums a
WHERE a.aid = p.aid
ORDER BY a.date DESC;

--search for mutual friends
SELECT f1.fid, count(f1.fid)
FROM Friends f1
JOIN (SELECT fid 
FROM Friends
WHERE uid = ${user_id}) as f2 ON f1.uid = f2.fid
GROUP BY f1.fid

--search albums with album id
SELECT a.* 
FROM albums a
WHERE a.uid = ${user_id};

--search for comment for specific photo
SELECT c.* 
FROM coments c, photos p
WHERE p.pid = ${photo_id} AND p.pid = c.pid;

--search for likes for a spcific photo
SELECT l.* 
FROM likes l, photos p
WHERE p.pid = ${photo_id} AND p.pid = l.pid;

--search for photos associated with tags
SELECT p.* 
FROM photos p, tags t
WHERE t.pid = p.pid AND t.text = ${tag};

--search tag on a photo
SELECT t.text, COUNT(*) as tag_count FROM tags t
JOIN photos p ON t.pid = p.pid
GROUP BY t.text;

--search for specific comment in text form
SELECT *
FROM coments c
WHERE c.text LIKE '${comment}%';

--insert new entry in users table. (new registeration)
INSERT INTO Users
VALUES (${new userId}, ${gender}, ${hometown}, ${dob}, ${fName}, ${lName}, ${email}, ${password};

--insert new friends for a user
INSERT INTO Friends
VALUES (${user id}, ${friends user id}, ${date});

--insert new album
INSERT INTO Albums
VALUES (${album id}, ${user id}, ${date}, ${aName});

--insert new photo
INSERT INTO Photos
VALUES (${new photo id}, ${album id}, ${caption}, ${photo location});

--insert likes
INSERT INTO Likes
VALUES (${user id}, ${photo id});

--insert tags
INSERT INTO Tags
VALUES (${tag id}, ${tag}, ${photo id});

--insert comments
INSERT INTO Coments
VALUES (${new comment id}, ${photo id}, ${user id}, ${comment text}, ${date});
		
--delete album with album ID
DELETE FROM Photos WHERE AID = ${album id}

--delete photos with photo id
DELETE FROM Photos WHERE PID = ${photo id}

CREATE TABLE check_list(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    image_name TEXT NOT NULL,
    opens INTEGER NOT NULL DEFAULT 0
);
INSERT INTO check_list(id, name, image_name) values (1,'去爬山', 'icon_hiking.png');
INSERT INTO check_list(id, name, image_name) values (2,'去野营', 'icon_camping.png');
INSERT INTO check_list(id, name, image_name) values (3,'去上班', 'icon_gotowork.png');
INSERT INTO check_list(id, name, image_name) values (4,'踢足球', 'icon_football.png');
INSERT INTO check_list(id, name, image_name) values (5,'参加面试', 'icon_interview.png');
INSERT INTO check_list(id, name, image_name) values (6,'参加考试', 'icon_exam.png');
INSERT INTO check_list(id, name, image_name) values (7,'出差', 'icon_trip.png');
INSERT INTO check_list(id, name, image_name) values (8,'去购物', 'icon_goshopping.png');
INSERT INTO check_list(id, name, image_name) values (9,'去海边', 'icon_beach.png');
INSERT INTO check_list(id, name, image_name) values (10,'去西藏', 'icon_beach.png');
INSERT INTO check_list(id, name, image_name) values (11,'长途旅行', 'icon_default.png');
INSERT INTO check_list(id, name, image_name) values (12,'短途旅行', 'icon_default.png');
INSERT INTO check_list(id, name, image_name) values (13,'打篮球', 'icon_basketball.png');
INSERT INTO check_list(id, name, image_name) values (14,'打羽毛球', 'icon_badminton.png');
INSERT INTO check_list(id, name, image_name) values (15,'去游泳', 'icon_swimming.png');
INSERT INTO check_list(id, name, image_name) values (16,'参加婚礼', 'icon_wedding.png');
INSERT INTO check_list(id, name, image_name) values (17,'骑自行车', 'icon_bike.png');
INSERT INTO check_list(id, name, image_name) values (18,'约会', 'icon_dating.png');
INSERT INTO check_list(id, name, image_name) values (19,'去跑步', 'icon_jogging.png');

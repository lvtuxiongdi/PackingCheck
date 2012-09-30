CREATE TABLE item(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    name_en TEXT
);

CREATE TABLE list_item(
    list_id INTEGER,
    item_id INTEGER,
    item_order INTEGER DEFAULT 0,
    CONSTRAINT pk_list_item primary key (list_id,item_id)
);

INSERT INTO item(id, name) values (1, '钥匙');
INSERT INTO item(id, name) values (2, '现金');
INSERT INTO item(id, name) values (3, '信用卡');
INSERT INTO item(id, name) values (4, '手机');
INSERT INTO item(id, name) values (5, '钱包');
INSERT INTO item(id, name) values (6, '运动鞋');
INSERT INTO item(id, name) values (7, '篮球');
INSERT INTO item(id, name) values (8, '水');
INSERT INTO item(id, name) values (9, '帐篷');
INSERT INTO item(id, name) values (10, '睡袋');
INSERT INTO item(id, name) values (11, '防潮垫');
INSERT INTO item(id, name) values (12, '食品');
INSERT INTO item(id, name) values (13, '气罐');
INSERT INTO item(id, name) values (14, '炊具');
INSERT INTO item(id, name) values (15, '身份证');
INSERT INTO item(id, name) values (16, '机票');
INSERT INTO item(id, name) values (17, '护照');
INSERT INTO item(id, name) values (18, '红包');
INSERT INTO item(id, name) values (19, '登山鞋');
INSERT INTO item(id, name) values (20, '登山杖');
INSERT INTO item(id, name) values (21, '护膝');
INSERT INTO item(id, name) values (22, '指南针');
INSERT INTO item(id, name) values (23, '药品');
INSERT INTO item(id, name) values (24, '公交卡');
INSERT INTO item(id, name) values (25, '手台');
INSERT INTO item(id, name) values (26, '头灯');
INSERT INTO item(id, name) values (27, '足球');
INSERT INTO item(id, name) values (28, '足球鞋');
INSERT INTO item(id, name) values (29, '护踝');
INSERT INTO item(id, name) values (30, '球拍');
INSERT INTO item(id, name) values (31, '羽毛球');
INSERT INTO item(id, name) values (32, '购物袋');
INSERT INTO item(id, name) values (33, '泳衣');
INSERT INTO item(id, name) values (34, '泳镜');
INSERT INTO item(id, name) values (35, '防晒霜');
INSERT INTO item(id, name) values (36, '车锁');
INSERT INTO item(id, name) values (37, '鱼竿');
INSERT INTO item(id, name) values (38, '鱼饵');
INSERT INTO item(id, name) values (39, '鱼线');
INSERT INTO item(id, name) values (40, '鱼篓');
INSERT INTO item(id, name) values (41, '折叠板凳');
INSERT INTO item(id, name) values (42, '简历');
INSERT INTO item(id, name) values (43, '准考证');
INSERT INTO item(id, name) values (44, '普通铅笔');
INSERT INTO item(id, name) values (45, '文艺铅笔');
INSERT INTO item(id, name) values (46, '2B铅笔');
INSERT INTO item(id, name) values (47, '购物清单');
INSERT INTO item(id, name) values (48, '头盔');
INSERT INTO item(id, name) values (49, '车锁');

INSERT INTO list_item(list_id, item_id) values (1,1);
INSERT INTO list_item(list_id, item_id) values (1,2);
INSERT INTO list_item(list_id, item_id) values (1,4);
INSERT INTO list_item(list_id, item_id) values (1,8);
INSERT INTO list_item(list_id, item_id) values (1,12);
INSERT INTO list_item(list_id, item_id) values (1,19);
INSERT INTO list_item(list_id, item_id) values (1,20);
INSERT INTO list_item(list_id, item_id) values (1,21);
INSERT INTO list_item(list_id, item_id) values (1,22);
INSERT INTO list_item(list_id, item_id) values (1,25);
INSERT INTO list_item(list_id, item_id) values (1,26);

INSERT INTO list_item(list_id, item_id) values (2,1);
INSERT INTO list_item(list_id, item_id) values (2,2);
INSERT INTO list_item(list_id, item_id) values (2,4);
INSERT INTO list_item(list_id, item_id) values (2,8);
INSERT INTO list_item(list_id, item_id) values (2,9);
INSERT INTO list_item(list_id, item_id) values (2,10);
INSERT INTO list_item(list_id, item_id) values (2,11);
INSERT INTO list_item(list_id, item_id) values (2,12);
INSERT INTO list_item(list_id, item_id) values (2,13);
INSERT INTO list_item(list_id, item_id) values (2,14);
INSERT INTO list_item(list_id, item_id) values (2,22);
INSERT INTO list_item(list_id, item_id) values (2,23);
INSERT INTO list_item(list_id, item_id) values (2,25);

INSERT INTO list_item(list_id, item_id) values (3,1);
INSERT INTO list_item(list_id, item_id) values (3,4);
INSERT INTO list_item(list_id, item_id) values (3,5);
INSERT INTO list_item(list_id, item_id) values (3,24);

INSERT INTO list_item(list_id, item_id) values (4,27);
INSERT INTO list_item(list_id, item_id) values (4,28);
INSERT INTO list_item(list_id, item_id) values (4,8);

INSERT INTO list_item(list_id, item_id) values (5,42);

INSERT INTO list_item(list_id, item_id) values (6,44);
INSERT INTO list_item(list_id, item_id) values (6,45);
INSERT INTO list_item(list_id, item_id) values (6,46);

INSERT INTO list_item(list_id, item_id) values (7,2);
INSERT INTO list_item(list_id, item_id) values (7,3);
INSERT INTO list_item(list_id, item_id) values (7,4);
INSERT INTO list_item(list_id, item_id) values (7,15);
INSERT INTO list_item(list_id, item_id) values (7,16);
INSERT INTO list_item(list_id, item_id) values (7,17);

INSERT INTO list_item(list_id, item_id) values (8,3);
INSERT INTO list_item(list_id, item_id) values (8,47);

INSERT INTO list_item(list_id, item_id) values (9,33);
INSERT INTO list_item(list_id, item_id) values (9,34);
INSERT INTO list_item(list_id, item_id) values (9,35);

INSERT INTO list_item(list_id, item_id) values (10,6);
INSERT INTO list_item(list_id, item_id) values (10,7);
INSERT INTO list_item(list_id, item_id) values (10,8);

INSERT INTO list_item(list_id, item_id) values (11,6);
INSERT INTO list_item(list_id, item_id) values (11,8);
INSERT INTO list_item(list_id, item_id) values (11,29);
INSERT INTO list_item(list_id, item_id) values (11,30);
INSERT INTO list_item(list_id, item_id) values (11,31);

INSERT INTO list_item(list_id, item_id) values (12,33);
INSERT INTO list_item(list_id, item_id) values (12,34);

INSERT INTO list_item(list_id, item_id) values (13,18);

INSERT INTO list_item(list_id, item_id) values (14,8);
INSERT INTO list_item(list_id, item_id) values (14,48);
INSERT INTO list_item(list_id, item_id) values (14,49);


INSERT INTO list_item(list_id, item_id) values (15,2);
INSERT INTO list_item(list_id, item_id) values (15,3);
INSERT INTO list_item(list_id, item_id) values (15,4);
INSERT INTO list_item(list_id, item_id) values (15,5);




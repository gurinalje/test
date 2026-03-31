/*
Navicat MySQL Data Transfer

Source Server         : 本地
Source Server Version : 50527
Source Host           : localhost:3306
Source Database       : cinema

Target Server Type    : MYSQL
Target Server Version : 50527
File Encoding         : 65001

Date: 2021-03-20 09:34:11
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `activity`
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(45) NOT NULL,
  `a_description` varchar(255) NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `coupon_id` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of activity
-- ----------------------------
INSERT INTO `activity` VALUES ('2', '春季外卖节', '春季外卖节', '2019-04-23 17:55:59', '5', '2019-04-20 17:55:59');
INSERT INTO `activity` VALUES ('3', '春季外卖节', '春季外卖节', '2019-04-23 17:55:59', '6', '2019-04-20 17:55:59');
INSERT INTO `activity` VALUES ('4', '测试活动', '测试活动', '2019-04-26 16:00:00', '8', '2019-04-20 16:00:00');

-- ----------------------------
-- Table structure for `activity_movie`
-- ----------------------------
DROP TABLE IF EXISTS `activity_movie`;
CREATE TABLE `activity_movie` (
  `activity_id` int(11) DEFAULT NULL,
  `movie_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of activity_movie
-- ----------------------------
INSERT INTO `activity_movie` VALUES ('2', '10');
INSERT INTO `activity_movie` VALUES ('2', '11');
INSERT INTO `activity_movie` VALUES ('2', '16');
INSERT INTO `activity_movie` VALUES ('4', '10');

-- ----------------------------
-- Table structure for `coupon`
-- ----------------------------
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `target_amount` float DEFAULT NULL,
  `discount_amount` float DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of coupon
-- ----------------------------
INSERT INTO `coupon` VALUES ('1', '测试优惠券', '春季电影节', '20', '5', '2019-04-20 17:47:54', '2019-04-23 17:47:59');
INSERT INTO `coupon` VALUES ('5', '测试优惠券', '品质联盟', '30', '4', '2019-04-20 21:14:46', '2019-04-24 21:14:51');
INSERT INTO `coupon` VALUES ('6', '春节电影节优惠券', '电影节优惠券', '50', '10', '2019-04-20 21:15:11', '2019-04-21 21:14:56');
INSERT INTO `coupon` VALUES ('8', '测试优惠券', '123', '100', '99', '2019-04-20 16:00:00', '2019-04-26 16:00:00');

-- ----------------------------
-- Table structure for `coupon_user`
-- ----------------------------
DROP TABLE IF EXISTS `coupon_user`;
CREATE TABLE `coupon_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of coupon_user
-- ----------------------------
INSERT INTO `coupon_user` VALUES ('1', '8', '15');
INSERT INTO `coupon_user` VALUES ('2', '5', '15');
INSERT INTO `coupon_user` VALUES ('3', '8', '15');
INSERT INTO `coupon_user` VALUES ('4', '6', '15');
INSERT INTO `coupon_user` VALUES ('5', '5', '15');
INSERT INTO `coupon_user` VALUES ('6', '8', '15');
INSERT INTO `coupon_user` VALUES ('7', '6', '15');

-- ----------------------------
-- Table structure for `hall`
-- ----------------------------
DROP TABLE IF EXISTS `hall`;
CREATE TABLE `hall` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `column` int(11) DEFAULT NULL,
  `row` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of hall
-- ----------------------------
INSERT INTO `hall` VALUES ('1', '1号厅', '10', '5');
INSERT INTO `hall` VALUES ('2', '2号厅', '12', '8');

-- ----------------------------
-- Table structure for `history`
-- ----------------------------
DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `kind` int(11) NOT NULL,
  `time` datetime DEFAULT NULL,
  `money` double NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of history
-- ----------------------------
INSERT INTO `history` VALUES ('1', '4', '2', '2019-05-31 17:00:00', '30.56', 'nmsl');
INSERT INTO `history` VALUES ('2', '1', '2', null, '12', '电影名：夏目友人帐；影厅名：1号厅；票价：12');
INSERT INTO `history` VALUES ('3', '1', '2', null, '56.2', '电影名：言叶之庭；影厅名：1号厅；票价：56.2');

-- ----------------------------
-- Table structure for `movie`
-- ----------------------------
DROP TABLE IF EXISTS `movie`;
CREATE TABLE `movie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_url` varchar(255) DEFAULT NULL,
  `director` varchar(255) DEFAULT NULL,
  `screen_writer` varchar(255) DEFAULT NULL,
  `starring` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `length` int(11) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `status` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of movie
-- ----------------------------
INSERT INTO `movie` VALUES ('10', 'http://n.sinaimg.cn/translate/640/w600h840/20190312/ampL-hufnxfm4278816.jpg', '大森贵弘 /伊藤秀樹', '', '神谷浩史 /井上和彦 /高良健吾 /小林沙苗 /泽城美雪', '动画', null, null, '120', '2019-04-14 14:54:31', '夏目友人帐', '在人与妖怪之间过着忙碌日子的夏目，偶然与以前的同学结城重逢，由此回忆起了被妖怪缠身的苦涩记忆。此时，夏目认识了在归还名字的妖怪记忆中出现的女性·津村容莉枝。和玲子相识的她，现在和独子椋雄一同过着平稳的生活。夏目通过与他们的交流，心境也变得平和。但这对母子居住的城镇，却似乎潜伏着神秘的妖怪。在调查此事归来后，寄生于猫咪老师身体的“妖之种”，在藤原家的庭院中，一夜之间就长成树结出果实。而吃掉了与自己形状相似果实的猫咪老师，竟然分裂成了3个', '0');
INSERT INTO `movie` VALUES ('11', 'https://i.loli.net/2019/06/20/5d0b77753f47132364.jpg', '新海诚', null, '远野贵树', '爱情/错过', null, null, '120', '2019-04-16 14:55:31', '秒速五厘米', '全作由《樱花抄》、《宇航员》和《秒速五厘米》三话组成。导演结合樱花、电车、卫星等美丽的意象，讲述了围绕着男主角远野贵树和女主角篠原明里、澄田花苗之间所发生的唯美而又忧伤的故事......', '0');
INSERT INTO `movie` VALUES ('12', 'https://i.loli.net/2019/06/20/5d0b77890585f82489.jpg', '新海诚', null, '猫', '孤独', null, null, '120', '2019-04-16 14:57:31', '她和她的猫', '本动画片以一只公猫的视角，讲述了“他”与女主人在同一个屋檐下所过的略带感伤的淡然日子。很久之前的某天，“他”被美丽温柔的女孩捡回家，开始了自认幸福无比的生活。女孩孤身一人，做着一份“他”不知也不介意为何的工作，“他”在意的是女孩很早出门时的那副面庞、身上的那缕清香、问候“他”时的那声淡语以及爱抚“他”时的那份轻柔……以致后来，一只名叫“美美”的猫咪向“他”表白爱意时，“他”婉言拒绝——“他”早已被女孩深深征服。然而，一个个季节逝去，“他”终究无法抚慰她寂寞的心灵。', '0');
INSERT INTO `movie` VALUES ('13', 'https://i.loli.net/2019/06/20/5d0b77e61bdf470098.jpg', '新海诚', null, '雪野百里香', '爱情/悲伤', null, null, '120', '2019-04-16 14:52:31', '言叶之庭', '刚满15岁的高中生秋月孝雄，因母亲离家出走，不得不为了生计打工赚钱。入梅之日，孝雄逃课来到一座日本庭园。安静的小亭子里，27岁的职场女性雪野百香里边吃巧克力、边喝啤酒的样子引起了他的注意。对彼此感到似曾相识的二人，每到落雨之日便从世俗的烦恼中逃脱出来，相会于这座都市丛林中的幽静角落。在梅雨季节，他们的心渐渐互相靠拢。志愿成为手工鞋匠的秋月，决心为雪野做一双鞋。雨过天晴，艳阳高照，庭园中久久不见两人的身影……', '0');
INSERT INTO `movie` VALUES ('14', 'https://i.loli.net/2019/06/20/5d0b78588d53770781.jpg', '新海诚', null, '宫水三叶', '爱情', null, null, '120', '2019-04-18 13:23:15', '你的名字', '在远离大都会的小山村，住着巫女世家出身的高中女孩宫水三叶。不知从何时起，三叶在梦中就会变成一个住在东京的高中男孩。另一方面，住在东京的高中男孩立花泷则总在梦里来到陌生的小山村，以女孩子的身份过着全新的生活。许是受那颗神秘彗星的影响，立花和三叶在梦中交换了身份。', '0');
INSERT INTO `movie` VALUES ('15', '1', '1', '1', '1', '1', '1', '1', '111', '2019-04-16 15:00:24', 'nnmm,,,', '1', '1');
INSERT INTO `movie` VALUES ('16', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2549523952.webp', '林孝谦', 'abcˆ', '陈意涵', '爱情', '大陆', null, '123', '2019-04-18 13:23:15', '比悲伤更悲伤的故事', '唱片制作人张哲凯(刘以豪)和王牌作词人宋媛媛(陈意涵)相依为命，两人自幼身世坎坷只有彼此为伴，他们是亲人、是朋友，也彷佛是命中注定的另一半。父亲罹患遗传重症而被母亲抛弃的哲凯，深怕自己随时会发病不久人世，始终没有跨出友谊的界线对媛媛展露爱意。眼见哲凯的病情加重，他暗自决定用剩余的生命完成他们之间的终曲，再为媛媛找个可以托付一生的好男人。这时，事业有 成温柔体贴的医生(张书豪)适时的出现让他成为照顾媛媛的最佳人选，二人按部就班发展着关系。一切看似都在哲凯的计划下进行。然而，故事远比这里所写更要悲伤......', '1');

-- ----------------------------
-- Table structure for `movie_like`
-- ----------------------------
DROP TABLE IF EXISTS `movie_like`;
CREATE TABLE `movie_like` (
  `movie_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `like_time` datetime DEFAULT NULL,
  PRIMARY KEY (`movie_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of movie_like
-- ----------------------------
INSERT INTO `movie_like` VALUES ('10', '1', null);
INSERT INTO `movie_like` VALUES ('10', '12', '2019-03-25 02:40:19');
INSERT INTO `movie_like` VALUES ('11', '1', '2019-03-22 09:38:12');
INSERT INTO `movie_like` VALUES ('11', '2', '2019-03-23 09:38:12');
INSERT INTO `movie_like` VALUES ('11', '3', '2019-03-22 08:38:12');
INSERT INTO `movie_like` VALUES ('12', '3', '2019-03-25 06:36:22');
INSERT INTO `movie_like` VALUES ('14', '1', null);
INSERT INTO `movie_like` VALUES ('16', '12', '2019-03-23 15:27:48');

-- ----------------------------
-- Table structure for `refundpolicy`
-- ----------------------------
DROP TABLE IF EXISTS `refundpolicy`;
CREATE TABLE `refundpolicy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_id` int(11) DEFAULT NULL,
  `movie_name` varchar(255) NOT NULL,
  `time_limit` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `rate` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of refundpolicy
-- ----------------------------
INSERT INTO `refundpolicy` VALUES ('1', '10', '夏目友人帐', '30', '2019-05-31 17:00:00', '2019-06-28 18:00:00', '0.5');

-- ----------------------------
-- Table structure for `schedule`
-- ----------------------------
DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hall_id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `fare` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of schedule
-- ----------------------------
INSERT INTO `schedule` VALUES ('20', '1', '12', '2019-04-13 17:00:00', '2019-04-13 18:00:00', '20.5');
INSERT INTO `schedule` VALUES ('21', '1', '10', '2019-04-11 12:00:00', '2019-04-11 13:00:00', '90');
INSERT INTO `schedule` VALUES ('27', '1', '11', '2019-04-17 18:01:00', '2019-04-17 20:01:00', '20.5');
INSERT INTO `schedule` VALUES ('28', '1', '11', '2019-04-19 16:00:00', '2019-04-19 18:00:00', '20.5');
INSERT INTO `schedule` VALUES ('30', '1', '11', '2019-04-18 18:01:00', '2019-04-18 20:01:00', '20.5');
INSERT INTO `schedule` VALUES ('31', '1', '11', '2019-04-12 16:00:00', '2019-04-12 18:00:00', '20.5');
INSERT INTO `schedule` VALUES ('32', '1', '11', '2019-04-12 20:00:00', '2019-04-12 22:00:00', '20.5');
INSERT INTO `schedule` VALUES ('37', '1', '11', '2019-04-15 00:00:00', '2019-04-15 02:00:00', '20.5');
INSERT INTO `schedule` VALUES ('38', '1', '11', '2019-04-14 17:00:00', '2019-04-14 19:00:00', '20.5');
INSERT INTO `schedule` VALUES ('40', '1', '10', '2019-04-10 16:00:00', '2019-04-10 18:00:00', '20.5');
INSERT INTO `schedule` VALUES ('41', '1', '11', '2019-04-10 19:00:00', '2019-04-10 21:00:00', '20.5');
INSERT INTO `schedule` VALUES ('42', '1', '11', '2019-04-10 22:00:00', '2019-04-11 00:00:00', '20.5');
INSERT INTO `schedule` VALUES ('43', '1', '10', '2019-04-11 01:00:00', '2019-04-11 03:00:00', '20.5');
INSERT INTO `schedule` VALUES ('44', '2', '10', '2019-04-11 01:00:00', '2019-04-11 03:00:00', '20.5');
INSERT INTO `schedule` VALUES ('45', '2', '10', '2019-04-10 22:00:00', '2019-04-11 00:00:00', '20.5');
INSERT INTO `schedule` VALUES ('46', '2', '11', '2019-04-10 19:00:00', '2019-04-10 21:00:00', '20.5');
INSERT INTO `schedule` VALUES ('47', '2', '11', '2019-04-10 16:00:00', '2019-04-10 18:00:00', '20.5');
INSERT INTO `schedule` VALUES ('48', '2', '10', '2019-04-11 13:00:00', '2019-04-11 15:59:00', '20.5');
INSERT INTO `schedule` VALUES ('50', '1', '10', '2019-04-15 16:00:00', '2019-04-15 19:00:00', '2');
INSERT INTO `schedule` VALUES ('51', '1', '10', '2019-04-17 05:00:00', '2019-04-17 07:00:00', '9');
INSERT INTO `schedule` VALUES ('52', '1', '10', '2019-04-18 05:00:00', '2019-04-18 07:00:00', '9');
INSERT INTO `schedule` VALUES ('53', '1', '16', '2019-04-19 07:00:00', '2019-04-19 10:00:00', '9');
INSERT INTO `schedule` VALUES ('54', '1', '16', '2019-04-16 19:00:00', '2019-04-16 22:00:00', '9');
INSERT INTO `schedule` VALUES ('55', '1', '15', '2019-04-17 23:00:00', '2019-04-18 01:00:00', '9');
INSERT INTO `schedule` VALUES ('56', '2', '10', '2019-04-19 13:00:00', '2019-04-19 15:59:00', '20.5');
INSERT INTO `schedule` VALUES ('57', '2', '10', '2019-04-20 13:00:00', '2019-04-20 15:59:00', '20.5');
INSERT INTO `schedule` VALUES ('58', '2', '10', '2019-04-21 13:00:00', '2019-04-21 15:59:00', '20.5');
INSERT INTO `schedule` VALUES ('61', '1', '13', '2019-04-20 11:00:00', '2019-04-20 13:00:00', '25');
INSERT INTO `schedule` VALUES ('62', '1', '11', '2019-04-20 08:00:00', '2019-04-20 10:00:00', '25');
INSERT INTO `schedule` VALUES ('63', '2', '15', '2019-04-20 16:01:30', '2019-04-21 05:30:00', '30');
INSERT INTO `schedule` VALUES ('64', '1', '16', '2019-04-22 02:00:00', '2019-04-22 05:30:00', '30');
INSERT INTO `schedule` VALUES ('65', '1', '10', '2019-04-23 02:00:00', '2019-04-23 05:30:00', '30');
INSERT INTO `schedule` VALUES ('66', '2', '13', '2019-04-21 07:31:29', '2019-04-16 15:59:00', '20.5');
INSERT INTO `schedule` VALUES ('67', '2', '10', '2019-04-25 13:00:00', '2019-04-25 15:59:00', '20.5');
INSERT INTO `schedule` VALUES ('68', '2', '10', '2019-04-26 13:00:00', '2019-04-26 15:59:00', '20.5');
INSERT INTO `schedule` VALUES ('69', '1', '10', '2021-03-20 14:51:00', '2021-03-20 16:53:00', '12');
INSERT INTO `schedule` VALUES ('70', '1', '13', '2021-03-20 10:25:00', '2021-03-20 12:27:00', '56.2');

-- ----------------------------
-- Table structure for `ticket`
-- ----------------------------
DROP TABLE IF EXISTS `ticket`;
CREATE TABLE `ticket` (
  `user_id` int(11) DEFAULT NULL,
  `schedule_id` int(11) DEFAULT NULL,
  `column_index` int(11) DEFAULT NULL,
  `row_index` int(11) DEFAULT NULL,
  `state` tinyint(4) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of ticket
-- ----------------------------
INSERT INTO `ticket` VALUES ('1', '69', '5', '4', '1', '2', null);
INSERT INTO `ticket` VALUES ('1', '70', '4', '3', '1', '3', null);
INSERT INTO `ticket` VALUES ('1', '69', '8', '1', '0', '4', null);

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `kind` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_uindex` (`id`),
  UNIQUE KEY `user_username_uindex` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'faker', '123123', '2');
INSERT INTO `user` VALUES ('2', 'boss', '413566', '0');
INSERT INTO `user` VALUES ('8', 'root', '123456', '1');

-- ----------------------------
-- Table structure for `view`
-- ----------------------------
DROP TABLE IF EXISTS `view`;
CREATE TABLE `view` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of view
-- ----------------------------
INSERT INTO `view` VALUES ('1', '7');

-- ----------------------------
-- Table structure for `vip_card`
-- ----------------------------
DROP TABLE IF EXISTS `vip_card`;
CREATE TABLE `vip_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `balance` double NOT NULL,
  `join_time` datetime DEFAULT NULL,
  `total` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vip_card_user_id_uindex` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vip_card
-- ----------------------------
INSERT INTO `vip_card` VALUES ('1', 'dd', '15', '375', '2019-04-21 13:54:38', '560.8');
INSERT INTO `vip_card` VALUES ('2', 'faker', '12', '660', '2019-04-17 18:47:42', '1290.45');

-- ----------------------------
-- Table structure for `vip_strategy`
-- ----------------------------
DROP TABLE IF EXISTS `vip_strategy`;
CREATE TABLE `vip_strategy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charge_limit` int(11) DEFAULT NULL,
  `gift_amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vip_strategy
-- ----------------------------
INSERT INTO `vip_strategy` VALUES ('1', '100', '30');

-- ----------------------------
-- Table structure for `vip_strategy3`
-- ----------------------------
DROP TABLE IF EXISTS `vip_strategy3`;
CREATE TABLE `vip_strategy3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charge_limit` int(11) DEFAULT NULL,
  `gift_amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vip_strategy3
-- ----------------------------
INSERT INTO `vip_strategy3` VALUES ('1', '100', '30');

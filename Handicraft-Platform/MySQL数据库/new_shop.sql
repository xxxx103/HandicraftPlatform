/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80033 (8.0.33)
 Source Host           : localhost:3306
 Source Schema         : new_shop

 Target Server Type    : MySQL
 Target Server Version : 80033 (8.0.33)
 File Encoding         : 65001

 Date: 15/01/2025 16:05:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version`  (
  `version_num` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`version_num`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO `alembic_version` VALUES ('89367bd96c7f');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `cname` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('1', '编织');
INSERT INTO `category` VALUES ('2', '刺绣');
INSERT INTO `category` VALUES ('3', '缠花');
INSERT INTO `category` VALUES ('4', '点翠');
INSERT INTO `category` VALUES ('5', '绒花');
INSERT INTO `category` VALUES ('6', '手艺');
INSERT INTO `category` VALUES ('7', '其他');

-- ----------------------------
-- Table structure for category_second
-- ----------------------------
DROP TABLE IF EXISTS `category_second`;
CREATE TABLE `category_second`  (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `csname` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `cid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `cid`(`cid` ASC) USING BTREE,
  CONSTRAINT `category_second_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category_second
-- ----------------------------
INSERT INTO `category_second` VALUES ('1', '花', '1');
INSERT INTO `category_second` VALUES ('10', '装饰画', '2');
INSERT INTO `category_second` VALUES ('11', '书签', '2');
INSERT INTO `category_second` VALUES ('12', '团扇', '2');
INSERT INTO `category_second` VALUES ('13', '香囊', '2');
INSERT INTO `category_second` VALUES ('14', '手帕', '2');
INSERT INTO `category_second` VALUES ('16', '发簪', '3');
INSERT INTO `category_second` VALUES ('17', '发夹', '3');
INSERT INTO `category_second` VALUES ('18', '胸针', '3');
INSERT INTO `category_second` VALUES ('19', '书签', '3');
INSERT INTO `category_second` VALUES ('2', '娃娃', '1');
INSERT INTO `category_second` VALUES ('20', '发簪', '4');
INSERT INTO `category_second` VALUES ('21', '耳饰', '4');
INSERT INTO `category_second` VALUES ('22', '戒指', '4');
INSERT INTO `category_second` VALUES ('23', '发饰', '4');
INSERT INTO `category_second` VALUES ('24', '发簪', '5');
INSERT INTO `category_second` VALUES ('25', '配饰', '5');
INSERT INTO `category_second` VALUES ('26', '耳饰', '5');
INSERT INTO `category_second` VALUES ('27', '摆件', '5');
INSERT INTO `category_second` VALUES ('28', '琉璃摆件', '6');
INSERT INTO `category_second` VALUES ('29', '陶瓷', '6');
INSERT INTO `category_second` VALUES ('3', '挂件', '1');
INSERT INTO `category_second` VALUES ('30', '木雕', '6');
INSERT INTO `category_second` VALUES ('31', '竹制品', '6');
INSERT INTO `category_second` VALUES ('32', '油画', '6');
INSERT INTO `category_second` VALUES ('33', '通草花', '7');
INSERT INTO `category_second` VALUES ('34', '永生花', '7');
INSERT INTO `category_second` VALUES ('35', '其他', '7');
INSERT INTO `category_second` VALUES ('4', '发卡', '1');
INSERT INTO `category_second` VALUES ('5', '手链', '1');
INSERT INTO `category_second` VALUES ('6', '包包', '1');
INSERT INTO `category_second` VALUES ('7', '围巾', '1');
INSERT INTO `category_second` VALUES ('9', '禁步', '2');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_read` int NULL DEFAULT NULL,
  `cdate` datetime NULL DEFAULT NULL,
  `uid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `comment_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `pid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid` ASC) USING BTREE,
  INDEX `comment_id`(`comment_id` ASC) USING BTREE,
  INDEX `pid`(`pid` ASC) USING BTREE,
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `comment_ibfk_3` FOREIGN KEY (`pid`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES ('0170b81a81df11ea9c4dacde48001122', '哈哈哈哈哈 确实不错', 0, '2025-01-14 09:42:19', '191806a4d29811e89e82b808cfd4f089', NULL, NULL);
INSERT INTO `comment` VALUES ('251944788f9311ea8675acde48001122', '这个缠花书签真的很便宜 欢迎大家来买', 0, '2025-01-06 20:14:33', '4ebfe6b8554311ea8306acde48001122', NULL, 'b0fe4e328ea011ea9d5eacde48001122');
INSERT INTO `comment` VALUES ('2ed39da490fd11eaadc8acde48001122', '我的和这个一样 买的时候真的很不错', 0, '2025-01-08 15:26:07', '191806a4d29811e89e82b808cfd4f089', NULL, '9ccbc7628ea211eaaed5acde48001122');
INSERT INTO `comment` VALUES ('372a8e6a8f9311ea8675acde48001122', '是的呢 这', 0, '2025-01-06 20:15:04', '9c96169c8ee511ea8e36acde48001122', '251944788f9311ea8675acde48001122', NULL);
INSERT INTO `comment` VALUES ('39f44f7690fd11eaadc8acde48001122', '嗯嗯 这个价钱很低', 0, '2025-01-08 15:26:26', '191806a4d29811e89e82b808cfd4f089', '2ed39da490fd11eaadc8acde48001122', NULL);
INSERT INTO `comment` VALUES ('42a5b8da555211eabba8acde48001122', '你好', 0, '2025-01-22 17:03:58', '4ebfe6b8554311ea8306acde48001122', NULL, 'b6136dc6d2a111e8b281b808cfd4f089');
INSERT INTO `comment` VALUES ('699541fe904911eab57aacde48001122', '真不错，好喜欢', 0, '2025-01-07 17:59:17', '191806a4d29811e89e82b808cfd4f089', NULL, '73336ac8555d11ea8a88acde48001122');
INSERT INTO `comment` VALUES ('8fd12452592e11eab856acde48001122', '可以便宜点吗', 0, '2025-01-27 14:58:30', '191806a4d29811e89e82b808cfd4f089', NULL, '3284b00c592e11eab856acde48001122');
INSERT INTO `comment` VALUES ('d3a4964e556611eaaa43acde48001122', '你好价格可以便宜一点吗', 0, '2025-01-22 19:31:11', '191806a4d29811e89e82b808cfd4f089', NULL, '34d0b7e8d2a111e8ac05b808cfd4f089');
INSERT INTO `comment` VALUES ('df62ef76d2af11e88719b808cfd4f089', '么么哒', 0, '2025-01-18 16:29:04', '191806a4d29811e89e82b808cfd4f089', NULL, NULL);
INSERT INTO `comment` VALUES ('e8700022556611eaaa43acde48001122', '不好意思 已经是最低价钱啦', 0, '2025-01-22 19:31:46', '4ebfe6b8554311ea8306acde48001122', 'd3a4964e556611eaaa43acde48001122', NULL);
INSERT INTO `comment` VALUES ('fd446076591a11eab856acde48001122', '咋样', 0, '2025-01-27 12:38:24', '191806a4d29811e89e82b808cfd4f089', NULL, 'fa659a2cd29d11e890a5b808cfd4f089');
INSERT INTO `comment` VALUES ('fefd8e40847d11eab2cfacde48001122', '嗯嗯呢能', 0, '2025-01-22 17:45:27', '191806a4d29811e89e82b808cfd4f089', 'fd446076591a11eab856acde48001122', NULL);

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `total_money` float NULL DEFAULT NULL,
  `ordertime` datetime NULL DEFAULT NULL,
  `state` int NULL DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `addr` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `uid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `order_last_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid` ASC) USING BTREE,
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `count` int NOT NULL,
  `sub_total` float NOT NULL,
  `pid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `oid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pid`(`pid` ASC) USING BTREE,
  INDEX `oid`(`oid` ASC) USING BTREE,
  CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`oid`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `pname` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `old_price` float NOT NULL,
  `new_price` float NOT NULL,
  `images` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `is_hot` int NULL DEFAULT NULL,
  `is_sell` int NULL DEFAULT NULL,
  `pdate` datetime NULL DEFAULT NULL,
  `click_count` int NULL DEFAULT NULL,
  `counts` int NOT NULL,
  `uid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `pDesc` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `love_user` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `is_pass` int NULL DEFAULT NULL,
  `head_img` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `csid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid` ASC) USING BTREE,
  INDEX `csid`(`csid` ASC) USING BTREE,
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`csid`) REFERENCES `category_second` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES ('00337a10d29b11e8802cb808cfd4f089', '非遗手工绒花桃花簪子', 77, 69, 'http://sq237ckvv.hb-bkt.clouddn.com/45ab3dd6c35d981b.jpg@http://sq237ckvv.hb-bkt.clouddn.com/3f3e4aa3c7515658.jpg', 0, 1, '2025-01-15 07:36:05', 14, 1, '191806a4d29811e89e82b808cfd4f089', '商品名称：非遗手工绒花桃花簪子\r\n商品编号：100001860773商品毛重：495.00g', '', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/45ab3dd6c35d981b.jpg', '24');
INSERT INTO `product` VALUES ('0631afe0914211eab7d4acde48001122', '银杏缠花胸针', 23, 19.9, 'http://sq237ckvv.hb-bkt.clouddn.com/0282cae6914211eab7d4acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/03ae4cd8914211eab7d4acde48001122.jpg@', 0, 1, '2025-01-15 15:35:04', 4, 9, '4ebfe6b8554311ea8306acde48001122', '商品名称：银杏缠花胸针商品编号：16232232323321 商品毛重：233.01g', '191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/0282cae6914211eab7d4acde48001122.jpg', '18');
INSERT INTO `product` VALUES ('0989b8f6d2a111e8a452b808cfd4f089', '围巾手工编织', 31, 29.9, 'http://sq237ckvv.hb-bkt.clouddn.com/dd359563dc751ca5%20%281%29.jpg@http://sq237ckvv.hb-bkt.clouddn.com/70e84d1d269937ed.jpg', 0, 1, '2025-01-14 20:07:02', 168, 1, '191806a4d29811e89e82b808cfd4f089', '商品名称：围巾手工编织商品编号：7625455526422 商品毛重：543.69g', '191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/70e84d1d269937ed.jpg', '7');
INSERT INTO `product` VALUES ('3284b00c592e11eab856acde48001122', '仿点翠竹叶渐变虎皮鹦鹉毛耳坠', 600, 588, 'http://sq237ckvv.hb-bkt.clouddn.com/31e90846592e11eab856acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/32602b9c592e11eab856acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/326fafe0592e11eab856acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/3278f686592e11eab856acde48001122.jpg@', 0, 1, '2025-01-08 23:14:03', 11, 1, '191806a4d29811e89e82b808cfd4f089', '商品名称：仿点翠竹叶渐变虎皮鹦鹉毛耳坠编号：100011199522商品毛重：0.6kg', '191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/3278f686592e11eab856acde48001122.jpg', '21');
INSERT INTO `product` VALUES ('34d0b7e8d2a111e8ac05b808cfd4f089', '仿点翠鹦鹉孔雀毛小小牡丹发簪', 1611, 1598, 'http://sq237ckvv.hb-bkt.clouddn.com/2461a6a0c4d4b3db.jpg@http://sq237ckvv.hb-bkt.clouddn.com/343e35fc42a307fd.jpg@http://sq237ckvv.hb-bkt.clouddn.com/15d9c43f11b0ab52.jpg@http://sq237ckvv.hb-bkt.clouddn.com/37080986778851b4.jpg', 0, 1, '2025-01-08 23:14:51', 144, 1, '191806a4d29811e89e82b808cfd4f089', '商品名称：仿点翠鹦鹉孔雀毛小小牡丹发簪商品编号：100008348510商品毛重：500.00g', '4ebfe6b8554311ea8306acde48001122_191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/2461a6a0c4d4b3db.jpg', '20');
INSERT INTO `product` VALUES ('38037514d2a011e89676b808cfd4f089', '钩线玩偶毛线娃娃', 18, 15.32, 'http://sq237ckvv.hb-bkt.clouddn.com/1e1ba7f4f9b6beaf.jpg@http://sq237ckvv.hb-bkt.clouddn.com/0baccec45c425e4c.jpg@http://sq237ckvv.hb-bkt.clouddn.com/993a7456c638b93b.jpg', 0, 1, '2025-01-14 16:44:17', 21, 1, '191806a4d29811e89e82b808cfd4f089', '商品名称：钩线玩偶毛线娃娃商品编号：100005923001商品毛重：0.7kg', NULL, 2, 'http://sq237ckvv.hb-bkt.clouddn.com/1e1ba7f4f9b6beaf.jpg', '2');
INSERT INTO `product` VALUES ('484152348e0211eaa870acde48001122', '竹编灯笼挂件', 8, 7.8, 'http://sq237ckvv.hb-bkt.clouddn.com/41b8ec388e0211eaa870acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/42abf7488e0211eaa870acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/43532bbc8e0211eaa870acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/4539a4428e0211eaa870acde48001122.jpg@', 0, 1, '2025-01-14 19:45:18', 18, 10, '191806a4d29811e89e82b808cfd4f089', '\n商品名称：竹编灯笼挂件商品编号：100012686112商品毛重：200.00g', NULL, 2, 'http://sq237ckvv.hb-bkt.clouddn.com/41b8ec388e0211eaa870acde48001122.jpg', '31');
INSERT INTO `product` VALUES ('4bd0b7508e0211eaa870acde48001122', '琉璃艺术品纯手工拉丝圣诞树桌面装饰创意摆件', 30, 26.8, 'http://sq237ckvv.hb-bkt.clouddn.com/45ae84068e0211eaa870acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/46e60e848e0211eaa870acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/479cc9f88e0211eaa870acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/49b544d68e0211eaa870acde48001122.jpg@', 0, 1, '2025-01-08 21:18:57', 0, 1, '191806a4d29811e89e82b808cfd4f089', '\n商品名称：琉璃艺术品纯手工拉丝圣诞树桌面装饰创意摆件商品编号：100012686112商品毛重：100.00g', NULL, 0, 'http://sq237ckvv.hb-bkt.clouddn.com/49b544d68e0211eaa870acde48001122.jpg', '28');
INSERT INTO `product` VALUES ('64dad6d2d4d111e8866fb808cfd4f089', '唐风蝴蝶绒花发夹侧边配饰', 52, 44.77, 'http://sq237ckvv.hb-bkt.clouddn.com/26ce5396338b6519.jpg@http://sq237ckvv.hb-bkt.clouddn.com/f4c8eb97699aa637.jpg', 0, 1, '2025-01-15 07:18:54', 46, 0, '191806a4d29811e89e82b808cfd4f089', '商品名称：唐风蝴蝶绒花发夹侧边配饰商品编号：100000305421商品毛重：50.86kg', '4ebfe6b8554311ea8306acde48001122_191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/f4c8eb97699aa637.jpg', '25');
INSERT INTO `product` VALUES ('73336ac8555d11ea8a88acde48001122', '编织针织花束', 40, 33.8, 'http://sq237ckvv.hb-bkt.clouddn.com/72d6540a555d11ea8a88acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/730ca5aa555d11ea8a88acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/731e215e555d11ea8a88acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/7328a160555d11ea8a88acde48001122.jpg@', 0, 1, '2025-01-15 15:35:30', 51, 3, '4ebfe6b8554311ea8306acde48001122', '商品名称：编织针织花束商品编号：6547438商品毛重：0.63kg', '191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/7328a160555d11ea8a88acde48001122.jpg', '1');
INSERT INTO `product` VALUES ('9ccbc7628ea211eaaed5acde48001122', '肥啾 木雕小鸟 灰蓝山雀', 39, 35, 'http://sq237ckvv.hb-bkt.clouddn.com/98c7b7ac8ea211eaaed5acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/9957344a8ea211eaaed5acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/99f0bc8c8ea211eaaed5acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/9ba3e81a8ea211eaaed5acde48001122.jpg@', 2, 1, '2025-01-15 12:43:18', 64, 2, '191806a4d29811e89e82b808cfd4f089', '商品名称：肥啾 木雕小鸟 灰蓝山雀商品编号：65542474386商品毛重：35.63kg', '191806a4d29811e89e82b808cfd4f089_9c96169c8ee511ea8e36acde48001122_4ebfe6b8554311ea8306acde48001122_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/98c7b7ac8ea211eaaed5acde48001122.jpg', '30');
INSERT INTO `product` VALUES ('adf6ec2ed29f11e88a64b808cfd4f089', '南京梧翊凰绒花 九尾狐（大）', 42, 4000, 'http://sq237ckvv.hb-bkt.clouddn.com/5926960cN00904afa.jpg@http://sq237ckvv.hb-bkt.clouddn.com/5b7fca77N581900f7.jpg@http://sq237ckvv.hb-bkt.clouddn.com/5926966fN818bfbc5.jpg@http://sq237ckvv.hb-bkt.clouddn.com/59269641N3c72e367.jpg', 2, 1, '2025-01-15 12:42:49', 27, 1, '191806a4d29811e89e82b808cfd4f089', '商品名称：南京梧翊凰绒花 九尾狐（大）商品编号：4247631商品毛重：122.16kg', '53d6fd8c81e211ea844facde48001122_191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/5b7fca77N581900f7.jpg', '27');
INSERT INTO `product` VALUES ('b0fe4e328ea011ea9d5eacde48001122', '精美缠花书签', 19, 15, 'http://sq237ckvv.hb-bkt.clouddn.com/ac6c05d08ea011ea9d5eacde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/ad0cabe88ea011ea9d5eacde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/add7b9008ea011ea9d5eacde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/aed6328c8ea011ea9d5eacde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/afbb05068ea011ea9d5eacde48001122.jpg@', 2, 1, '2025-01-14 19:28:49', 54, 12, '191806a4d29811e89e82b808cfd4f089', '商品名称：精美缠花书签商品编号：4247631商品毛重：10.16kg', '191806a4d29811e89e82b808cfd4f089_4ebfe6b8554311ea8306acde48001122_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/ac6c05d08ea011ea9d5eacde48001122.jpg', '19');
INSERT INTO `product` VALUES ('b6136dc6d2a111e8b281b808cfd4f089', '禁步配饰', 338, 332, 'http://sq237ckvv.hb-bkt.clouddn.com/ca98bce6fd0fd462.jpg@http://sq237ckvv.hb-bkt.clouddn.com/a567394d86f451ea.jpg@http://sq237ckvv.hb-bkt.clouddn.com/5b154a06d5c89bff.jpg', 0, 1, '2025-01-14 17:11:13', 75, 1, '191806a4d29811e89e82b808cfd4f089', '商品名称：禁步配饰商品编号：52841063722商品毛重：60.00g', '4ebfe6b8554311ea8306acde48001122_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/ca98bce6fd0fd462.jpg', '9');
INSERT INTO `product` VALUES ('ca7f2450d2a011e8add8b808cfd4f089', '彩虹糖围巾渐变色保暖', 149, 144.66, 'http://sq237ckvv.hb-bkt.clouddn.com/f9b44c03842157b2.jpg@http://sq237ckvv.hb-bkt.clouddn.com/abf6aed0e0a92d4e.jpg', 0, 1, '2025-01-15 12:12:32', 38, 2, '191806a4d29811e89e82b808cfd4f089', '商品名称：彩虹糖围巾渐变色保暖商品编号：58845917170商品毛重：100.00g', '191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/f9b44c03842157b2.jpg', '7');
INSERT INTO `product` VALUES ('d130f60a914311eab7d4acde48001122', '刺绣平安符香囊', 83, 79, 'http://sq237ckvv.hb-bkt.clouddn.com/c9172264914311eab7d4acde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/c98d16e0914311eab7d4acde48001122.jpg@', 0, 1, '2025-01-14 17:11:06', 8, 4, '4ebfe6b8554311ea8306acde48001122', '商品名称：刺绣平安符香囊商品编号：27376914商品毛重：70.00g', '191806a4d29811e89e82b808cfd4f089_4ebfe6b8554311ea8306acde48001122_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/c9172264914311eab7d4acde48001122.jpg', '13');
INSERT INTO `product` VALUES ('f08252166c4411ea9a1cacde48001122', '小桃子绒花头饰', 36.6, 35.3, 'http://sq237ckvv.hb-bkt.clouddn.com/efcc24646c4411ea9a1cacde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/f05b745c6c4411ea9a1cacde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/f065c5926c4411ea9a1cacde48001122.jpg@http://sq237ckvv.hb-bkt.clouddn.com/f07000c06c4411ea9a1cacde48001122.jpg@', 0, 1, '2025-01-15 01:13:45', 46, 1, '191806a4d29811e89e82b808cfd4f089', '商品名称：小桃子绒花头饰商品编号：1166455547商品毛重：21.00g', '191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/efcc24646c4411ea9a1cacde48001122.jpg', '25');
INSERT INTO `product` VALUES ('fa659a2cd29d11e890a5b808cfd4f089', '绣色刺绣书签', 89, 88, 'http://sq237ckvv.hb-bkt.clouddn.com/b139e4c53a97441d.png@http://sq237ckvv.hb-bkt.clouddn.com/8bf1ca80689d819f.jpg@http://sq237ckvv.hb-bkt.clouddn.com/b02321b5cc7beb47.jpg@http://sq237ckvv.hb-bkt.clouddn.com/d76c243ab5dbc2a4.jpg@http://sq237ckvv.hb-bkt.clouddn.com/94bc38968607806c.jpg', 0, 1, '2025-01-15 12:01:45', 41, 8, '191806a4d29811e89e82b808cfd4f089', '商品名称：绣色刺绣书签商品编号：61407045252商品毛重：50.0g', '191806a4d29811e89e82b808cfd4f089_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/b139e4c53a97441d.png', '11');
INSERT INTO `product` VALUES ('fbe6d908d29e11e88b6fb808cfd4f089', '仿点翠手工鹦鹉毛樱花戒指', 129, 128, 'http://sq237ckvv.hb-bkt.clouddn.com/7f84707ddd77d6ce.jpg@http://sq237ckvv.hb-bkt.clouddn.com/b07322b0daeb0348.jpg@http://sq237ckvv.hb-bkt.clouddn.com/ea3fe55c794cebb7.jpg@http://sq237ckvv.hb-bkt.clouddn.com/2a42a7dd7c432a4a.jpg', 0, 1, '2025-01-15 08:20:50', 74, 20, '191806a4d29811e89e82b808cfd4f089', '商品名称：仿点翠手工鹦鹉毛樱花戒指h商品编号：100008348590商品毛重：6.52kg', '4ebfe6b8554311ea8306acde48001122_53d6fd8c81e211ea844facde48001122_', 2, 'http://sq237ckvv.hb-bkt.clouddn.com/b07322b0daeb0348.jpg', '22');

-- ----------------------------
-- Table structure for shop_cart
-- ----------------------------
DROP TABLE IF EXISTS `shop_cart`;
CREATE TABLE `shop_cart`  (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `sdate` datetime NULL DEFAULT NULL,
  `count` int NULL DEFAULT NULL,
  `uid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `pid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `subTotal` float NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid` ASC) USING BTREE,
  INDEX `pid`(`pid` ASC) USING BTREE,
  CONSTRAINT `shop_cart_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `shop_cart_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_cart
-- ----------------------------
INSERT INTO `shop_cart` VALUES ('a4935a14d2ce11efb6bfbc6ee2373d62', '2025-01-15 07:24:04', 1, '53d6fd8c81e211ea844facde48001122', 'fbe6d908d29e11e88b6fb808cfd4f089', 128);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `addr` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `is_ok` int NULL DEFAULT NULL,
  `img_url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `identity` int NULL DEFAULT NULL,
  `scores` int NULL DEFAULT NULL,
  `shop_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('191806a4d29811e89e82b808cfd4f089', 'LLL', 'pbkdf2:sha256:50000$GWCU17XC$b4d726ed90e4b787040610cafdb893e6fc0ceb7766f941364e51d007eba9331d', '李女士', '1247721306@qq.com', '13193801071', '湖南衡阳', 1, 'http://sq237ckvv.hb-bkt.clouddn.com/0c945380556311ea8addacde48001122.jpg', '2018-10-18 13:38:53', 2, 0, NULL);
INSERT INTO `user` VALUES ('4ebfe6b8554311ea8306acde48001122', 'lmn', 'pbkdf2:sha256:50000$OCzaOj8L$22174e8cac8a2f4ad265f9cbb6c4f2aa7ae15165c5a8d3fc8cf1a3c7bee041b1', 'lmn', '1569660468@qq.com', '13193801071', '安徽亳州', 1, 'http://sq237ckvv.hb-bkt.clouddn.com/ada7ec2e900e11eaba30acde48001121.jpg', '2020-02-22 15:16:56', 2, 0, NULL);
INSERT INTO `user` VALUES ('53d6fd8c81e211ea844facde48001122', '小可爱', 'pbkdf2:sha256:50000$aXwG8d7t$fdf2a21c27747553ccb5d538e043b27c540b1b8dcda62c6ac02b31b5bfc25a2a', '小可爱', '2020897405@qq.com', '13193801071', '天津', 1, 'http://sq237ckvv.hb-bkt.clouddn.com/ada7ec2e900e11eaba30acde48001122.jpg', '2020-04-19 10:06:06', 0, 0, NULL);
INSERT INTO `user` VALUES ('85d8a4f6d4dd11e8a23ab808cfd4f089', '李先生', 'pbkdf2:sha256:50000$PE2XpR69$abf7798119bcc9bb9210ffe896efd60871168ebe0113510f5b2c3d339ba92733', '李先生', '3531039691@qq.com', '13193801071', '安徽亳州', 1, 'http://sq237ckvv.hb-bkt.clouddn.com/b391927c555611ea86a8acde48001122.jpg', '2018-10-21 11:00:53', 0, 0, NULL);
INSERT INTO `user` VALUES ('9c96169c8ee511ea8e36acde48001122', 'qinYuGang', 'pbkdf2:sha256:50000$Gm8wwrVn$a202f5c0404b19c87bc8b6a728e2d465f2537ed7c9a21bfe52bb5b066197841f', '秦宇罡', '3227648426@qq.com', '13193801071', '湖南长沙', 1, 'http://sq237ckvv.hb-bkt.clouddn.com/ea1056628ee511ea8e36acde48001122.jpg', '2020-05-05 23:32:21', 0, 0, NULL);

SET FOREIGN_KEY_CHECKS = 1;

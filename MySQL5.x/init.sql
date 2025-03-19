-- 删除所有 root 用户实例（覆盖不同 Host）
DROP USER IF EXISTS 'root'@'localhost', 'root'@'%', 'root'@'127.0.0.1', 'root'@'::1';
FLUSH PRIVILEGES;  -- 强制刷新权限缓存

-- 使用 mysql_native_password 插件（规避 8.0+ 默认插件问题）
CREATE USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;  -- 最终权限生效

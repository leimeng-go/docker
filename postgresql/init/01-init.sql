-- PostgreSQL 初始化脚本
-- 该文件会在容器首次启动时自动执行

-- 创建额外的数据库
CREATE DATABASE app_db;

-- 连接到 test_db 数据库
\c test_db;

-- 创建示例表 - 用户表
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- 插入示例数据
INSERT INTO users (username, email, full_name) VALUES
    ('admin', 'admin@example.com', 'System Administrator'),
    ('test_user', 'test@example.com', 'Test User'),
    ('demo', 'demo@example.com', 'Demo User');

-- 创建产品表
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    stock INTEGER DEFAULT 0,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_price ON products(price);

-- 插入示例产品数据
INSERT INTO products (name, description, price, stock, category) VALUES
    ('产品A', '这是产品A的描述', 99.99, 100, '电子产品'),
    ('产品B', '这是产品B的描述', 199.99, 50, '电子产品'),
    ('产品C', '这是产品C的描述', 49.99, 200, '图书');

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为用户表添加更新触发器
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 为产品表添加更新触发器
CREATE TRIGGER update_products_updated_at 
    BEFORE UPDATE ON products 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 创建视图示例
CREATE VIEW active_users AS
SELECT id, username, email, full_name, created_at
FROM users
WHERE is_active = TRUE;

-- 授予权限（如果需要创建其他用户）
-- CREATE USER app_user WITH PASSWORD '181205';
-- GRANT ALL PRIVILEGES ON DATABASE test_db TO app_user;
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app_user;

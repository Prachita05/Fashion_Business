-- ============================================================================
-- DATABASE VIEWS - Top 3 Essential Views
-- Fashion Business Database
-- ============================================================================
use fashion_business;

-- View 1: Complete Product Catalog
-- Purpose: Most important view - shows all product information in one place
--          Includes designer, collection, pricing, and inventory status
CREATE VIEW vw_Product_Catalog AS
SELECT 
    ci.item_id,
    ci.name AS item_name,
    ci.size,
    ci.color,
    ci.price,
    c.collection_id,
    c.name AS collection_name,
    c.season,
    c.year AS collection_year,
    d.designer_id,
    d.name AS designer_name,
    d.style AS designer_style,
    i.quantity_in_stock,
    i.reorder_level,
    CASE 
        WHEN i.quantity_in_stock <= i.reorder_level THEN 'Low Stock'
        WHEN i.quantity_in_stock <= (i.reorder_level * 2) THEN 'Warning'
        ELSE 'In Stock'
    END AS stock_status
FROM Clothing_Items ci
INNER JOIN Collections c ON ci.collection_id = c.collection_id
INNER JOIN Designers d ON c.designer_id = d.designer_id
LEFT JOIN Inventory i ON ci.item_id = i.item_id;


-- View 2: Sales Details
-- Purpose: Complete sales transaction information with all related details
--          Essential for sales analysis and reporting
CREATE VIEW vw_Sales_Details AS
SELECT 
    s.sale_id,
    s.sale_date,
    DAYNAME(s.sale_date) AS day_of_week,
    MONTHNAME(s.sale_date) AS month_name,
    YEAR(s.sale_date) AS year,
    st.store_id,
    st.name AS store_name,
    st.location AS store_location,
    st.manager AS store_manager,
    ci.item_id,
    ci.name AS item_name,
    ci.color,
    ci.size,
    ci.price AS unit_price,
    c.name AS collection_name,
    d.name AS designer_name,
    s.quantity_sold,
    s.total_amount,
    s.payment AS payment_method
FROM Sales s
INNER JOIN Stores st ON s.store_id = st.store_id
INNER JOIN Clothing_Items ci ON s.item_id = ci.item_id
INNER JOIN Collections c ON ci.collection_id = c.collection_id
INNER JOIN Designers d ON c.designer_id = d.designer_id;


-- View 3: Designer Performance Summary
-- Purpose: Critical business metrics for each designer
--          Shows collections, items, sales count, and revenue
CREATE VIEW vw_Designer_Performance AS
SELECT 
    d.designer_id,
    d.name AS designer_name,
    d.style,
    d.email,
    d.phone,
    COUNT(DISTINCT c.collection_id) AS total_collections,
    COUNT(DISTINCT ci.item_id) AS total_items_designed,
    IFNULL(AVG(ci.price), 0) AS avg_item_price,
    IFNULL(MIN(ci.price), 0) AS min_item_price,
    IFNULL(MAX(ci.price), 0) AS max_item_price,
    IFNULL(COUNT(s.sale_id), 0) AS total_sales_count,
    IFNULL(SUM(s.quantity_sold), 0) AS total_items_sold,
    IFNULL(SUM(s.total_amount), 0) AS total_revenue
FROM Designers d
LEFT JOIN Collections c ON d.designer_id = c.designer_id
LEFT JOIN Clothing_Items ci ON c.collection_id = ci.collection_id
LEFT JOIN Sales s ON ci.item_id = s.item_id
GROUP BY d.designer_id, d.name, d.style, d.email, d.phone;


-- ============================================================================
-- USAGE EXAMPLES
-- ============================================================================

-- Query the product catalog
-- SELECT * FROM vw_Product_Catalog WHERE stock_status = 'Low Stock';

-- Query sales details for a specific month
-- SELECT * FROM vw_Sales_Details WHERE month_name = 'October' AND year = 2024;

-- Query designer performance
-- SELECT * FROM vw_Designer_Performance ORDER BY total_revenue DESC;
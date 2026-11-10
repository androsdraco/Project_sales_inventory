

USE ROLE SECURITYADMIN;

-- Create a dedicated, least-privilege role for the data pipeline.

CREATE ROLE IF NOT EXISTS database_viewer;
GRANT USAGE ON WAREHOUSE compute_wh TO ROLE database_viewer;

-- Attach the role to the human user who will:
--   • run `dbt build`
--   • authenticate Power BI
GRANT ROLE database_viewer TO USER jesus;


-- ── 2. SOURCE ACCESS (Marketplace share, read-only) ─────────

GRANT IMPORTED PRIVILEGES
    ON DATABASE SALES_AND_INVENTORY_DATA_FOR_RETAIL_BUSINESS_INTELLIGENCE
    TO ROLE database_viewer;


-- ── 3. TARGET DATABASE (where dbt writes) ───────────────────

CREATE DATABASE IF NOT EXISTS DBT_SALES_AND_INVENTORY;

-- Single schema for all dbt output — models, tables, views.
CREATE SCHEMA IF NOT EXISTS DBT_SALES_AND_INVENTORY.PUBLIC;

-- Give the role permission 
GRANT USAGE, CREATE SCHEMA
    ON DATABASE DBT_SALES_AND_INVENTORY
    TO ROLE database_viewer;

-- Give the role permission
GRANT USAGE, CREATE TABLE, CREATE VIEW
    ON SCHEMA DBT_SALES_AND_INVENTORY.PUBLIC
    TO ROLE database_viewer;


-- ── 4. VERIFICATION ─────────────────────────────────────────

SHOW GRANTS TO ROLE database_viewer;
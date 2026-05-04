#!/bin/bash
set -e

echo "Starting PostgreSQL initialization..."

# Create metadata database and user for Airflow
echo "Creating airflow_metadata_db..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d postgres <<-EOSQL
    CREATE DATABASE airflow_metadata_db;
    CREATE USER airflow_meta_user WITH PASSWORD 'VNXkgKEPBn69yYwA';
    ALTER ROLE airflow_meta_user SET client_encoding TO 'utf8';
    ALTER ROLE airflow_meta_user SET default_transaction_isolation TO 'read committed';
    ALTER ROLE airflow_meta_user SET default_transaction_deferrable TO on;
    ALTER ROLE airflow_meta_user SET timezone TO 'UTC';
    GRANT ALL PRIVILEGES ON DATABASE airflow_metadata_db TO airflow_meta_user;
EOSQL

# Create Celery results database
echo "Creating celery_results_db..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d postgres <<-EOSQL
    CREATE DATABASE celery_results_db;
    CREATE USER celery_user WITH PASSWORD 'L4PYpRNq6mxSQfyj';
    ALTER ROLE celery_user SET client_encoding TO 'utf8';
    ALTER ROLE celery_user SET default_transaction_isolation TO 'read committed';
    ALTER ROLE celery_user SET default_transaction_deferrable TO on;
    ALTER ROLE celery_user SET timezone TO 'UTC';
    GRANT ALL PRIVILEGES ON DATABASE celery_results_db TO celery_user;
EOSQL

# Create ELT database for YouTube data
echo "Creating elt_db..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d postgres <<-EOSQL
    CREATE DATABASE elt_db;
    CREATE USER yt_api_user WITH PASSWORD 'X57tmQ846GYP3Jgb';
    ALTER ROLE yt_api_user SET client_encoding TO 'utf8';
    ALTER ROLE yt_api_user SET default_transaction_isolation TO 'read committed';
    ALTER ROLE yt_api_user SET default_transaction_deferrable TO on;
    ALTER ROLE yt_api_user SET timezone TO 'UTC';
    GRANT ALL PRIVILEGES ON DATABASE elt_db TO yt_api_user;
EOSQL

echo "PostgreSQL initialization completed successfully!"

/*PGR-GNU*****************************************************************
File: astar.sql

Generated with Template by:
Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Function's developer: 
Copyright (c) 2015 Celia Virginia Vergara Castillo
Mail: 

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

********************************************************************PGR-GNU*/


--
-- pgr_astarCost subfamily of functions
--

-- one to one
CREATE OR REPLACE FUNCTION pgr_astarCost(
    edges_sql TEXT, -- XY edges sql
    BIGINT, -- start_id
    BIGINT, -- end_id
    directed BOOLEAN DEFAULT true,
    heuristic INTEGER DEFAULT 5,
    factor FLOAT DEFAULT 1.0,
    epsilon FLOAT DEFAULT 1.0,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT agg_cost FLOAT)

RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN query SELECT $2, $3, a.agg_cost
    FROM _pgr_astar(_pgr_get_statement($1), $2, $3, $4, $5, $6, $7, true) a;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100
ROWS 1000;

-- one to many
CREATE OR REPLACE FUNCTION pgr_astarCost(
    edges_sql TEXT, -- XY edges sql
    BIGINT,
    end_vids ANYARRAY,
    directed BOOLEAN DEFAULT true,
    heuristic INTEGER DEFAULT 5,
    factor FLOAT DEFAULT 1.0,
    epsilon FLOAT DEFAULT 1.0,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT agg_cost FLOAT)

RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN query SELECT $2, a.end_vid, a.agg_cost 
    FROM _pgr_astar(_pgr_get_statement($1), $2, $3, $4, $5, $6, $7, true) a;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100
ROWS 1000;

-- many to one
CREATE OR REPLACE FUNCTION pgr_astarCost(
    edges_sql TEXT, -- XY edges sql
    start_vids ANYARRAY,
    BIGINT,
    directed BOOLEAN DEFAULT true,
    heuristic INTEGER DEFAULT 5,
    factor FLOAT DEFAULT 1.0,
    epsilon FLOAT DEFAULT 1.0,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT agg_cost FLOAT)

RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN query SELECT  a.start_vid, $3, a.agg_cost
    FROM _pgr_astar(_pgr_get_statement($1), $2, $3, $4, $5, $6, $7, true) a;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100
ROWS 1000;

-- many to many
CREATE OR REPLACE FUNCTION pgr_astarCost(
    edges_sql TEXT, -- XY edges sql
    start_vids ANYARRAY,
    end_vids ANYARRAY,
    directed BOOLEAN DEFAULT true,
    heuristic INTEGER DEFAULT 5,
    factor FLOAT DEFAULT 1.0,
    epsilon FLOAT DEFAULT 1.0,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT agg_cost FLOAT)

RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN query SELECT a.start_vid, a.end_vid, a.agg_cost
    FROM _pgr_astar(_pgr_get_statement($1), $2, $3, $4, $5, $6, $7, true) a;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100
ROWS 1000;


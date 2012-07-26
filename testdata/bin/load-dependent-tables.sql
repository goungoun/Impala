-- Load tables that depend upon data in the hive test-warehouse already existing

-- Load a mixed-format table. Hive behaves oddly when mixing formats,
-- but the following incantation ensures that the result is a
-- three-partition table. First is text format, second is sequence
-- file, third is RC file.  Must be called after test-warehouse is
-- successfully populated
INSERT OVERWRITE TABLE alltypesmixedformat PARTITION (year=2009, month=1)
SELECT id, bool_col, tinyint_col, smallint_col, int_col, bigint_col, float_col, double_col, date_string_col, string_col, timestamp_col
FROM alltypes WHERE year=2009 and month=1;

ALTER TABLE alltypesmixedformat SET FILEFORMAT SEQUENCEFILE;
LOAD DATA INPATH '/tmp/alltypes_seq/year=2009/month=2/' OVERWRITE INTO TABLE alltypesmixedformat PARTITION (year=2009, month=2);
ALTER TABLE alltypesmixedformat SET FILEFORMAT RCFILE;
LOAD DATA INPATH '/tmp/alltypes_rc/year=2009/month=3/' OVERWRITE INTO TABLE alltypesmixedformat PARTITION (year=2009, month=3);

ALTER TABLE alltypesmixedformat PARTITION (year=2009, month=1) SET FILEFORMAT TEXTFILE;
ALTER TABLE alltypesmixedformat PARTITION (year=2009, month=1) SET SERDEPROPERTIES('field.delim'=',', 'escape.delim'='\\');
ALTER TABLE alltypesmixedformat PARTITION(year=2009, month=2) SET SERDEPROPERTIES('field.delim'='\001');
ALTER TABLE alltypesmixedformat PARTITION (year=2009, month=2) SET FILEFORMAT SEQUENCEFILE;

#!/bin/bash
# Print the sizes of all MySQL databases
mysql -u root -pPASSWORD -e 'select table_schema "Database",round(sum(data_length+index_length)/1024/1024,4) "Size (MB)" from information_schema.tables group by table_schema;'

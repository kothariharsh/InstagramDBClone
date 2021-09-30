# Teh main reason to execute it is to avoid SQL Error 1055

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

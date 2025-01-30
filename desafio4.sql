Realizando backup

  mysqldump -u usuario -p --routines --events --triggers e-commerce > backup_ecommerce.sql


  Compactado:

gunzip < backup_ecommerce.sql.gz | mysql -u usuario -p e-commerce


  Restaurar
  mysql -u usuario -p -e "CREATE DATABASE ecommerce;"
  mysql -u usuario -p ecommerce < backup_ecommerce.sql

SET CLIENT_ENCODING TO 'utf8';
\! echo. \! echo IT Table \! echo ______________
DROP TABLE IF EXISTS InventoryIT
;

create table InventoryIT
             (
                          name text
                        , AppCode text
                        , ChargeableCPU text
                        , Version text
                        , TargetEnv text
                        , M text
                        , uploaddate date
                        , l3 text
                        , group_manager text
                        , appcustodian text
             )
;

\copy InventoryIT(name, AppCode,ChargeableCPU, Version, TargetEnv) from 'F:\Automated Scripts\\ INVENTORY\_FILES\InventoryIT.csv' DELIMITER ',' CSV HEADER;
Delete
from
       InventoryIT
where
       name          = ''
       or name is null
;

Update
       InventoryIT
set    uploaddate = now()::date
;

update
       InventoryIT
set    l3           =a.l3
     , group_manager=a.group_manager
     , appcustodian = a.it_custodian
from
       (
              SELECT
                     app_code
                   , l3_it_head as l3
                   , group_manager
                   , it_custodian
              from
                     glu0_app_view
       )
       AS a
where
       appcode=a.app_code
;

\! echo. \! echo FX Table \! echo ______________
DROP TABLE IF EXISTS InventoryFX
;

create table InventoryFX
             (
                          name text
                        , AppCode text
                        , TargetEnv text
                        , Version text
                        , uploaddate date
                        , l3 text
                        , group_manager text
                        , appcustodian text
             )
;

\copy InventoryFX(name, AppCode, TargetEnv, Version) from 'F:\Automated Scripts\\ INVENTORY\_FILES\InventoryFX.csv' DELIMITER ',' CSV HEADER;
Delete
from
       InventoryFX
where
       name          = ''
       or name is null
;

Update
       InventoryFX
set    uploaddate = now()::date
;

update
       InventoryFX
set    l3           =a.l3
     , group_manager=a.group_manager
     , appcustodian = a.it_custodian
from
       (
              SELECT
                     app_code
                   , l3_it_head as l3
                   , group_manager
                   , it_custodian
              from
                     glu0_app_view
       )
       AS a
where
       appcode=a.app_code
;

\! echo. \! echo HR Table \! echo ______________
DROP TABLE IF EXISTS InventoryHR
;

create table InventoryHR
             (
                          name text
                        , AppCode text
                        , Version text
                        , TargetEnv text
                        , uploaddate date
                        , l3 text
                        , group_manager text
                        , appcustodian text
             )
;

\copy InventoryHR(name, AppCode, TargetEnv, Version) from 'F:\Automated Scripts\\ INVENTORY\_FILES\InventoryHR.csv' DELIMITER ',' CSV HEADER;
Delete
from
       InventoryHR
where
       name          = ''
       or name is null
;

Update
       InventoryHR
set    uploaddate = now()::date
;

update
       InventoryHR
set    l3           =a.l3
     , group_manager=a.group_manager
     , appcustodian = a.it_custodian
from
       (
              SELECT
                     app_code
                   , l3_it_head as l3
                   , group_manager
                   , it_custodian
              from
                     glu0_app_view
       )
       AS a
where
       appcode=a.app_code
;
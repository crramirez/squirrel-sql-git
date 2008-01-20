-- ================================================================================
--   db2 SQL DDL Script File
-- ================================================================================


-- ===============================================================================
-- 
--   Generated by:      tedia2sql -- v1.2.13b2
--                      See http://tedia2sql.tigris.org/AUTHORS.html for tedia2sql author information
-- 
--   Target Database:   db2
--   Generated at:      Sat Dec 18 19:48:25 2004
--   Input Files:       TestERD.dia
-- 
-- ================================================================================



-- Generated SQL Constraints Drop statements
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia

drop index idx_iimd5;
drop index idx_iiid;
drop index idx_siiid;
drop index idx_siips;
drop index idx_iclidnm;
drop index idx_uinm;
drop index idx_uiid;
drop index idx_uauiid;
drop index idx_uiruid;
drop index idx_acid;
drop index idx_usmd5;
alter table subImageInfo drop constraint fk_iisii ;
alter table imageCategoryList drop constraint fk_iiicl ;
alter table imageAttribute drop constraint fk_iiia ;
alter table userImageRating drop constraint fk_uiuir ;
alter table userAttribute drop constraint fk_uiua ;
alter table userSession drop constraint fk_uius ;
alter table imageAttribute drop constraint fk_iaac ;
alter table userAttribute drop constraint fk_acua ;


-- Generated Permissions Drops
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia

revoke all on imageInfo from fmorg ;
revoke select on imageInfo from public ;
revoke all on subImageInfo from fmorg ;
revoke all on imageCategoryList from fmorg ;
revoke select on categoryNames from public ;
revoke all on categoryNames from fmorg ;
revoke all on imageAttribute from fmorg ;
revoke all on userInfo from fmorg ;
revoke all on userAttribute from fmorg ;
revoke all on userImageRating from fmorg ;
revoke all on attributeCategory from fmorg ;
revoke all on userSession from fmorg ;
revoke select on extremes from public ;
revoke all on extremes from fmorg ;


-- Special statements for oracle,postgres,db2:pre databases
-- statements to do BEFORE creating
-- the tables (schema)
drop sequence imageInfo_id;
create sequence imageInfo_id;


-- Generated SQL View Drop Statements
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia

drop view ratings_view ;
drop view whorated_view ;
drop view users_view ;


-- Generated SQL Schema Drop statements
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia

drop table imageInfo ;
drop table subImageInfo ;
drop table imageCategoryList ;
drop table categoryNames ;
drop table imageAttribute ;
drop table userInfo ;
drop table userAttribute ;
drop table userImageRating ;
drop table attributeCategory ;
drop table userSession ;
drop table extremes ;


-- Generated SQL Schema
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia


-- imageInfo
create table imageInfo (
  id                        numeric (18) not null,
  insertionDate             timestamp default now() not null,
  md5sum                    char (32) not null,
  binaryType                varchar (16) default 'jpg' null,
  name                      varchar (64) not null,
  locationList              varchar (128) default '//imgserver.org',
  description               varchar (128) null,
  constraint pk_ImageInfo primary key (id)
) ;

-- subImageInfo
create table subImageInfo (
  imageInfo_id              numeric (18) not null,
  pixSize                   integer not null,
  constraint pk_SubImageInfo primary key (imageInfo_id,pixSize)
) ;

-- imageCategoryList
create table imageCategoryList (
  imageInfo_id              numeric (18) not null,
  name                      varchar (32) not null,
  constraint pk_ImgCtgryLst primary key (imageInfo_id,name)
) ;

-- categoryNames
create table categoryNames (
  name                      varchar (32) not null,
  constraint pk_CategoryNames primary key (name)
) ;

-- imageAttribute
create table imageAttribute (
  imageInfo_id              numeric (18) not null,
  attributeCategory_id      numeric (18) not null,
  numValue                  numeric (8),
  category                  numeric (4),
  constraint pk_ImageAttribute primary key (imageInfo_id,attributeCategory_id)
) ;

-- userInfo
create table userInfo (
  id                        numeric (18) not null,
  insertionDate             timestamp,
  md5sum                    char (32),
  birthDate                 timestamp,
  gender                    char (1),
  name                      varchar (32),
  email                     varchar (96),
  currentCategory           varchar (32),
  lastDebitDate             timestamp,
  acctBalance               numeric (10,2),
  active                    integer,
  constraint pk_UserInfo primary key (id)
) ;

-- userAttribute
create table userAttribute (
  userInfo_id               numeric (18) not null,
  attributeCategory_id      numeric (18) not null,
  numValue                  numeric (5,4),
  constraint pk_UserAttribute primary key (userInfo_id,attributeCategory_id)
) ;

-- userImageRating
create table userImageRating (
  userInfo_id               numeric (18) not null,
  imageInfo_id              numeric (15) not null,
  rating                    integer,
  constraint pk_UserImageRating primary key (userInfo_id,imageInfo_id)
) ;

-- attributeCategory
create table attributeCategory (
  id                        numeric (18) not null,
  attributeDesc             varchar (128),
  constraint pk_AtrbtCtgry primary key (id)
) ;

-- userSession
create table userSession (
  userInfo_id               numeric (18) not null,
  md5sum                    char (32) not null,
  insertionDate             timestamp,
  expireDate                timestamp,
  ipAddress                 varchar (24),
  constraint pk_UserSession primary key (userInfo_id,md5sum)
) ;

-- extremes
create table extremes (
  name                      varchar (32) not null,
  colName                   varchar (64),
  minVal                    numeric (15),
  maxVal                    numeric (15),
  constraint pk_Extremes primary key (name)
) ;













-- Generated SQL Views
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia


-- ratings_view
create view ratings_view as
  select b.name, c.md5sum, a.rating
  from userImageRating a,
    userImageRating z,
    userInfo b,
    imageInfo c
  where (((a.userInfo_id = b.id)
    and (a.imageInfo_id = c.id)
    and (a.userInfo_id = z.userInfo_id))
    and (a.userInfo_id <> z.userInfo_id))
  order by c.md5sum,b.name,a.rating
;

-- whorated_view
create view whorated_view as
  select a.name, count (*) as numRatings
  from userInfo a,
    userImageRating b
  where (a.id = b.userInfo_id)
  group by a.name
;

-- users_view
create view users_view as
  select id, birthDate, name ||'<'|| email ||'>' as whoIsThis, currentCategory, acctBalance, active
  from userInfo
  order by userInfo.name
;


-- Special statements for oracle,postgres,db2:post databases
-- statements to do AFTER creating
-- the tables (schema)
--drop trigger . . . .
--create trigger . . . .


-- Generated Permissions
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia

grant all on imageInfo to fmorg ;
grant select on imageInfo to public ;
grant all on subImageInfo to fmorg ;
grant all on imageCategoryList to fmorg ;
grant select on categoryNames to public ;
grant all on categoryNames to fmorg ;
grant all on imageAttribute to fmorg ;
grant all on userInfo to fmorg ;
grant all on userAttribute to fmorg ;
grant all on userImageRating to fmorg ;
grant all on attributeCategory to fmorg ;
grant all on userSession to fmorg ;
grant select on extremes to public ;
grant all on extremes to fmorg ;


-- Generated SQL Insert statements
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia


-- inserts for categoryNames
insert into categoryNames values ( 'Buildings' ) ;
insert into categoryNames values ( 'Landscapes' ) ;
insert into categoryNames values ( 'Nudes' ) ;
insert into categoryNames values ( 'Life Studies' ) ;
insert into categoryNames values ( 'Portraits' ) ;
insert into categoryNames values ( 'Abstracts' ) ;

-- inserts for attributeCategory
insert into attributeCategory values ( 1,'Blurriness' ) ;
insert into attributeCategory values ( 2,'Contrastiness' ) ;
insert into attributeCategory values ( 3,'Saturation' ) ;
insert into attributeCategory values ( 4,'Size' ) ;
insert into attributeCategory values ( 5,'Relevence' ) ;


-- Generated SQL Constraints
-- --------------------------------------------------------------------
--     Target Database:   db2
--     SQL Generator:     tedia2sql -- v1.2.13b2
--     Generated at:      Sat Dec 18 19:48:17 2004
--     Input Files:       TestERD.dia

create unique index idx_iimd5 on imageInfo  (md5sum) ;
create index idx_iiid on imageInfo  (id) ;
create index idx_siiid on subImageInfo  (imageInfo_id) ;
create index idx_siips on subImageInfo  (pixSize) ;
create index idx_iclidnm on imageCategoryList  (imageInfo_id,name) ;
create unique index idx_uinm on userInfo  (name,md5sum) ;
create index idx_uiid on userInfo  (id) ;
create index idx_uauiid on userAttribute  (userInfo_id) ;
create index idx_uiruid on userImageRating  (userInfo_id) ;
create index idx_acid on attributeCategory  (id) ;
create index idx_usmd5 on userSession  (md5sum) ;
alter table subImageInfo add constraint fk_iisii
  foreign key (imageInfo_id)
  references imageInfo (id) ;
alter table imageCategoryList add constraint fk_iiicl
  foreign key (imageinfo_id)
  references imageInfo (id) ;
alter table imageAttribute add constraint fk_iiia
  foreign key (imageInfo_id)
  references imageInfo (id) ;
alter table userImageRating add constraint fk_uiuir
  foreign key (userInfo_id)
  references userInfo (id) ;
alter table userAttribute add constraint fk_uiua
  foreign key (userInfo_id)
  references userInfo (id) ;
alter table userSession add constraint fk_uius
  foreign key (userInfo_id)
  references userInfo (id) ;
alter table imageAttribute add constraint fk_iaac
  foreign key (attributeCategory_id)
  references attributeCategory (id) ;
alter table userAttribute add constraint fk_acua
  foreign key (attributeCategory_id)
  references attributeCategory (id) ;


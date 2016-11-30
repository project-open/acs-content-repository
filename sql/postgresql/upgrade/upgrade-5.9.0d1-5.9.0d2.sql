-- 
-- Ancient version of PostgreSQL (most likely before pg8) had a
-- bug in the handling of referential integrities (sometimes referred
-- to as the RI bug) which made extra triggers necessary. AFIKT,
-- this bug is gone and now the triggers should be removed as well
-- and replaced by fk constraints (sometimes already done).
-- 
-- 
-- Some old installations (like openacs.org) have still the following
-- functions although the create script do not define this triggers.
-- It seems that an update script was missing.
-- 
DROP TRIGGER if exists cr_folder_del_ri_trg ON cr_items;
DROP FUNCTION if exists cr_folder_del_ri_trg();

DROP TRIGGER if exists cr_folder_ins_up_ri_trg ON cr_folders;
DROP FUNCTION if exists cr_folder_ins_up_ri_trg();

-- 
-- Handle latest_revision and live_revision via foreign keys
--

-- fraber 161128: Delete inconsistent entries
update cr_items set latest_revision = null 
where latest_revision in (select latest_revision from cr_items except select revision_id from cr_revisions);

ALTER TABLE cr_items DROP CONSTRAINT if exists cr_items_latest_fk;
ALTER TABLE cr_items ADD CONSTRAINT cr_items_latest_fk
FOREIGN KEY (latest_revision) REFERENCES cr_revisions(revision_id);

-- fraber 161128: Delete inconsistent entries
update cr_items set live_revision = null 
where live_revision in (select live_revision from cr_items except select revision_id from cr_revisions);

ALTER TABLE cr_items DROP CONSTRAINT if exists cr_items_live_fk;
ALTER TABLE cr_items ADD CONSTRAINT cr_items_live_fk
FOREIGN KEY (live_revision) REFERENCES cr_revisions(revision_id);


DROP TRIGGER if exists cr_revision_del_ri_tr on cr_items;
DROP FUNCTION if exists cr_revision_del_ri_tr();

DROP TRIGGER if exists cr_revision_ins_ri_tr on cr_items;
DROP FUNCTION if exists cr_revision_ins_ri_tr();

DROP TRIGGER if exists cr_revision_up_ri_tr on cr_items;
DROP FUNCTION if exists cr_revision_up_ri_tr();

DROP TRIGGER if exists cr_revision_del_rev_ri_tr on cr_revisions;
DROP FUNCTION if exists cr_revision_del_rev_ri_tr();


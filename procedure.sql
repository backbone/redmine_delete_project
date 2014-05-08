DROP PROCEDURE IF EXISTS update_project_enable_module;
DELIMITER |
CREATE PROCEDURE update_project_enable_module()
BEGIN
    DECLARE c_project_id INT(11);

    DECLARE curs_project_id CURSOR
        FOR SELECT id
        FROM projects
        WHERE id NOT IN (
            SELECT project_id
            FROM enabled_modules
            WHERE name LIKE 'delete_project' );

    OPEN curs_project_id;

    LOOP
        FETCH curs_project_id INTO c_project_id;
        -- SELECT GROUP_CONCAT(name) FROM enabled_modules WHERE project_id=c_project_id;
        INSERT INTO enabled_modules VALUES ( NULL, c_project_id, 'delete_project');
    END LOOP;

    CLOSE curs_project_id;
END|
DELIMITER ;

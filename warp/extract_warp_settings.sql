.mode insert
.output warp_settings.sql
SELECT sql FROM sqlite_master WHERE type='table';
.output warp_themes.sql  
SELECT * FROM themes;
.output warp_keybindings.sql
SELECT * FROM keybindings;
.output warp_workflows.sql
SELECT * FROM workflows;
.output warp_preferences.sql
SELECT * FROM preferences;

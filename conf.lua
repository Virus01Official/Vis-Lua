function love.conf(t)
    t.identity = "vis_lua"                 -- Save directory name
    t.version = "11.4"                    -- LOVE2D version
    
    t.window.title = "Vis-Lua Visual Novel Engine" -- Window title
    t.window.width = 800                  -- Window width
    t.window.height = 600                 -- Window height
    t.window.resizable = true            -- Disable resizing
    t.window.vsync = 1                    -- Enable V-Sync
    t.window.fullscreen = false           -- Disable fullscreen
end

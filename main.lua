-- Load SceneManager
local SceneManager = require("engine.scene_manager")

-- Globals
local sceneManager

function love.load()
    love.graphics.setFont(love.graphics.newFont(24)) -- Set default font

    -- Initialize SceneManager
    sceneManager = SceneManager:new()

    -- Load the first scene
    local firstScene = require("scripts.scene_1")
    sceneManager:loadScene(firstScene)
end

function love.update(dt)
    sceneManager:update(dt)
end

function love.draw()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    -- Draw background
    if sceneManager.background then
        love.graphics.draw(sceneManager.background, 0, 0, 0, 
            windowWidth / sceneManager.background:getWidth(), 
            windowHeight / sceneManager.background:getHeight()
        )
    end

    -- Draw characters
    for name, character in pairs(sceneManager.characters) do
        local x = (character.position == "left" and windowWidth * 0.1) or
                  (character.position == "right" and windowWidth * 0.7) or
                  (windowWidth * 0.4)
        love.graphics.draw(character.sprite, x, windowHeight * 0.4, 0,
            windowWidth / 800,
            windowHeight / 600
        )
    end

    -- Draw dialogue box
    love.graphics.setColor(0, 0, 0, 0.7) -- Semi-transparent black
    love.graphics.rectangle("fill", 0, windowHeight * 0.8, windowWidth, windowHeight * 0.2)

    love.graphics.setColor(1, 1, 1) -- White text

    -- Draw dialogue text
    love.graphics.printf(sceneManager.name .. ": " .. sceneManager.displayedText, 
        windowWidth * 0.02, windowHeight * 0.82, windowWidth * 0.96)

    -- Draw choices
    if #sceneManager.options > 0 then
        for i, option in ipairs(sceneManager.options) do
            love.graphics.printf(i .. ". " .. option.text, 
                windowWidth * 0.02, windowHeight * 0.84 + i * 20, windowWidth * 0.96)
        end
    end
end

function love.keypressed(key)
    if key == "space" then
        if sceneManager.isAnimating then
            sceneManager.isAnimating = false
            sceneManager.displayedText = sceneManager.fullDialogue
        else
            sceneManager:processNext()
        end
    elseif tonumber(key) and sceneManager.options[tonumber(key)] then
        local nextScene = sceneManager.options[tonumber(key)].next
        local newScene = require("scripts." .. nextScene)
        sceneManager:loadScene(newScene)
    end
end

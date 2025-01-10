-- Vis-Lua: Basic Visual Novel Engine

-- Globals
local sceneManager = {}
local assets = {}

-- Load assets
function loadAsset(type, file)
    if type == "image" then
        return love.graphics.newImage("assets/" .. file)
    elseif type == "font" then
        return love.graphics.newFont("assets/fonts/" .. file, 24)
    elseif type == "sound" then
        return love.audio.newSource("assets/sounds/" .. file, "static")
    end
end

-- Load the scene script
local currentScene = require("scripts.scene_1")
local currentIndex = 1

-- Scene manager
function sceneManager:initialize()
    self.background = nil
    self.characters = {}
    self.dialogue = ""
    self.options = {}
    self.name = ""
end

function sceneManager:processNext()
    if currentIndex > #currentScene then return end

    local event = currentScene[currentIndex]
    currentIndex = currentIndex + 1

    if event.type == "background" then
        self.background = loadAsset("image", event.file)
    elseif event.type == "character" then
        self.characters[event.name] = {
            sprite = loadAsset("image", event.expression .. ".png"),
            position = event.position
        }
    elseif event.type == "dialogue" then
        self.dialogue = event.text
        self.name = event.name
    elseif event.type == "choice" then
        self.options = event.options
    end
end

-- Initialize the engine
sceneManager:initialize()
sceneManager:processNext()

function love.load()
    love.graphics.setFont(loadAsset("font", "default.ttf"))
end

-- Draw the scene
function love.draw()
    -- Draw background
    if sceneManager.background then
        love.graphics.draw(sceneManager.background, 0, 0)
    end

    -- Draw characters
    for name, character in pairs(sceneManager.characters) do
        local x = (character.position == "left" and 50) or
                  (character.position == "right" and 750) or 400
        love.graphics.draw(character.sprite, x, 300)
    end

    -- Draw dialogue box
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 500, 800, 100)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(sceneManager.name .. ": " .. sceneManager.dialogue, 10, 510, 780)

    -- Draw choices
    if #sceneManager.options > 0 then
        for i, option in ipairs(sceneManager.options) do
            love.graphics.printf(i .. ". " .. option.text, 10, 520 + i * 20, 780)
        end
    end
end

-- Handle input
function love.keypressed(key)
    if key == "space" then
        sceneManager:processNext()
    end

    if tonumber(key) and sceneManager.options[tonumber(key)] then
        local nextScene = sceneManager.options[tonumber(key)].next
        currentScene = require("scripts." .. nextScene)
        currentIndex = 1
        sceneManager:initialize()
        sceneManager:processNext()
    end
end

-- Example script (scripts/scene_1.lua):
--[[
return {
    { type = "background", file = "bg_forest.png" },
    { type = "character", name = "Alice", expression = "happy", position = "left" },
    { type = "dialogue", name = "Alice", text = "Hello, world!" },
    { type = "choice", options = {
        { text = "Say hello back", next = "scene_hello" },
        { text = "Ignore her", next = "scene_ignore" }
    }}
}
]]

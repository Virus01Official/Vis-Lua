-- scene_manager.lua

local SceneManager = {}

function SceneManager:new()
    local obj = {
        background = nil,
        characters = {},
        dialogue = "",
        name = "",
        options = {},
        fullDialogue = "",
        displayedText = "",
        textTimer = 0,
        textSpeed = 0.05,
        isAnimating = false,
        sounds = {}, -- Table to store character sounds
        currentSound = nil -- Currently playing sound
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function SceneManager:loadSound(characterName, soundFile)
    self.sounds[characterName] = love.audio.newSource("assets/sounds/" .. soundFile, "static")
end

function SceneManager:update(dt)
    if self.isAnimating then
        self.textTimer = self.textTimer + dt
        local numChars = math.floor(self.textTimer / self.textSpeed)

        if numChars >= #self.fullDialogue then
            self.displayedText = self.fullDialogue
            self.isAnimating = false
        else
            self.displayedText = string.sub(self.fullDialogue, 1, numChars)
        end
    end
end

function SceneManager:loadScene(scene)
    self.currentScene = scene
    self.currentIndex = 1
    self:processNext()
end

function SceneManager:initialize()
    self.background = nil
    self.characters = {}
    self.dialogue = ""
    self.name = ""
    self.options = {}
end

function SceneManager:processNext()
    if self.currentIndex > #self.currentScene then return end

    local event = self.currentScene[self.currentIndex]
    self.currentIndex = self.currentIndex + 1

    if event.type == "background" then
        self.background = love.graphics.newImage("assets/" .. event.file)
    elseif event.type == "character" then
        self.characters[event.name] = {
            sprite = love.graphics.newImage("assets/" .. event.expression .. ".png"),
            position = event.position
        }
    elseif event.type == "dialogue" then
        self.name = event.name or ""
        self.fullDialogue = event.text or ""
        self.displayedText = ""
        self.textTimer = 0
        self.isAnimating = true

        -- Play sound for the dialogue if specified
        if event.sound then
            local sound = love.audio.newSource("assets/sounds/" .. event.sound, "static")
            sound:play()
        end
    elseif event.type == "choice" then
        self.options = event.options
    end
end

return SceneManager

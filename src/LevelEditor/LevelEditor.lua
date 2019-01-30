---@class LevelEditor
LevelEditor = Class {__includes = BaseState}

local file = love.filesystem.newFile("level.json", "w")

function LevelEditor:init()
    self._currentShip = 7
    self._enemies = {} ---@type Enemy
    self._enemiesExportTable = {}
    self._chasingPlayer = true
    self._randomMovement = false

    local instructions =
        [=====[
    S to save
    Left or Right to change the type of enemy
    Enter to confirm the position of new enemy
    Num 1 to turn on/off chasing player (Default: on)
    Num 2 to turn on/off random movement (Default: off)
    ]=====]
    print(instructions)
end

function LevelEditor:render()
    love.graphics.draw(gTextures.backgrounds[1], 0, 0, 0, WINDOW_WIDTH / (640 - 1), WINDOW_HEIGHT / (480 - 1))
    love.graphics.draw(gTextures.ships, gFrameQuads.ships[self._currentShip], love.mouse.getPosition())

    for i = 1, #self._enemies do
        self._enemies[i]:render()
    end
end

function LevelEditor:update(dt)
    if (love.keyboard.wasPressed("right")) then
        if (self._currentShip < 10) then
            self._currentShip = self._currentShip + 1
        else
            self._currentShip = 7
        end
    elseif (love.keyboard.wasPressed("left")) then
        if (self._currentShip ~= 7) then
            self._currentShip = self._currentShip - 1
        else
            self._currentShip = 10
        end
    end

    if (love.keyboard.wasPressed("return")) then
        table.insert(self._enemies, Enemy(love.mouse.getX(), love.mouse.getY(), self._currentShip))
        table.insert(
            self._enemiesExportTable,
            {
                x = love.mouse.getX(),
                y = love.mouse.getY(),
                shipID = self._currentShip,
                chasingPlayer = self._chasingPlayer,
                randomMovement = self._randomMovement
            }
        )
    end

    if (love.keyboard.wasPressed("s")) then
        file:write(Json.encode(self._enemiesExportTable))
        print("Saved current level!")
    end

    if (love.keyboard.wasPressed("1")) then
        self._chasingPlayer = not self._chasingPlayer
        print("Chasing player: " .. tostring(self._chasingPlayer))
    elseif (love.keyboard.wasPressed("2")) then
        self._randomMovement = not self._randomMovement
        print("Random movement: " .. tostring(self._randomMovement))
    end
end

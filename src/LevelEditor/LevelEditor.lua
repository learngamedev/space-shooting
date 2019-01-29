---@class LevelEditor
LevelEditor = Class {__includes = BaseState}

local file = love.filesystem.newFile("level.json", "w")

function LevelEditor:init()
    self._currentShip = 1
    self._enemies = {} ---@type Enemy
    self._enemiesExportTable = {}
    self._chasePlayer = true

    print("Editor: S to save, Space to change the type of enemy, Enter to confirm the position of new enemy")
end

function LevelEditor:render()
    love.graphics.draw(gTextures.backgrounds[1], 0, 0, 0, WINDOW_WIDTH / (640 - 1), WINDOW_HEIGHT / (480 - 1))
    love.graphics.draw(gTextures.ships, gFrameQuads.ships[self._currentShip], love.mouse.getPosition())

    for i = 1, #self._enemies do
        self._enemies[i]:render()
    end
end

function LevelEditor:update(dt)
    if (love.keyboard.wasPressed("space")) then
        if (self._currentShip < 10) then
            self._currentShip = self._currentShip + 1
        else
            self._currentShip = 1
        end
    end
    if (love.keyboard.wasPressed("return")) then
        table.insert(
            self._enemies,
            Enemy(
                love.mouse.getX(),
                love.mouse.getY(),
                self._currentShip
            )
        )
        table.insert(
            self._enemiesExportTable,
            {x = love.mouse.getX(), y = love.mouse.getY(), shipID = self._currentShip}
        )
    end
    if (love.keyboard.wasPressed("s")) then
        file:write(Json.encode(self._enemiesExportTable))
        print("Saved current level!")
    end
end

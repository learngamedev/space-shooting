---@class LevelMaker
LevelMaker = {}

---@return Enemy[]
function LevelMaker.getLevel(fileName)
    local jsonFile = love.filesystem.newFile(fileName)
    local encoded = jsonFile:read(jsonFile:getSize())
    local decoded = Json.decode(encoded)

    local enemies = {}
    local enemy
    for i = 1, #decoded do
        enemy = decoded[i]
        if (enemy) then
            table.insert(
            enemies,
            Enemy(
                enemy.x,
                enemy.y,
                enemy.shipID,
                ENEMIES[enemy.shipID].bulletID,
                ENEMIES[enemy.shipID].hp,
                ENEMIES[enemy.shipID].speed,
                enemy.chasingPlayer,
                enemy.randomMovement
            )
        )
        end
    end
    return enemies
end

-- Single keyboard input handling
love.keyboard.keysPressed = {}

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end
--

function displaySystemUsage()
    love.graphics.print("FPS: " .. love.timer.getFPS())
    love.graphics.print("RAM: " .. math.floor(collectgarbage("count")) .. "KB", 0, 15)
end

function getFramesFromJson(jsonFilePath) 
    local jsonFile = love.filesystem.newFile(jsonFilePath)
    local jsonContent = jsonFile:read(jsonFile:getSize())
    return Json.decode(jsonContent)
end

-- Generate a table of quads using json file of a texture
---@param jsonFilePath string
function generateQuads(texture, frames)
    local quads = {}
    local key
    for i = 1, #frames do
        if (frames[i].key) then
            key = frames[i].key
        else
            key = i
        end

        quads[key] =
            love.graphics.newQuad(frames[i].x, frames[i].y, frames[i].width, frames[i].height, texture:getDimensions())
    end
    return quads
end

function getImageFont(fontImgPath)
    return love.graphics.newImageFont(
        fontImgPath,
        ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_ abcdefghijklmnopqrstuvwxyz{|}~'
    )
end
-- AABB collision detection
function checkCollision(x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end
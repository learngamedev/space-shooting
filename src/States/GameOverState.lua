---@class GameOverState : BaseState
GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self._score = 0
    self._scoreText = ""
    self._gameOverText = love.graphics.newText(gFont, "Game over!")
    self._playAgainText = love.graphics.newText(gFont, "Press ESC to quit, R to start over again")
end

function GameOverState:enter(params)
    self._score = params.score
    local scoreString = "Your score: "..self._score
    self._scoreText = love.graphics.newText(gFont, scoreString)
end

function GameOverState:render()
    love.graphics.draw(gTextures.backgrounds[1], 0, 0, 0, WINDOW_WIDTH / (640 - 1), WINDOW_HEIGHT / (480 - 1))
    love.graphics.print("Your score: "..self._score, WINDOW_WIDTH / 2 - math.floor(self._scoreText:getWidth() / 2), WINDOW_HEIGHT / 2 - self._scoreText:getHeight() / 2)
    love.graphics.print("Game over!", WINDOW_WIDTH / 2 - self._gameOverText:getWidth() / 2, WINDOW_HEIGHT / 2 - self._gameOverText:getHeight() / 2 - 100)
    love.graphics.print("Press ECS to quit, R to start over again!", WINDOW_WIDTH / 2 - self._playAgainText:getWidth() / 2, WINDOW_HEIGHT / 2 - self._playAgainText:getHeight() + 100)
end

function GameOverState:update(dt)
    if (love.keyboard.wasPressed("escape")) then
        love.event.quit()
    elseif (love.keyboard.wasPressed("r")) then
        gStateMachine.states.play = function() return PlayState() end
        gStateMachine:change("menu")
    end
end
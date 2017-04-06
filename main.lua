-- modules
local Class = require('lib.middleclass')
local Suit = require('theme') -- Suit with theme

-- source
local Node, Fractal = require('fractal')()
local section = require('section')

function love.update(dt)
    -- gui
    section.control:update()
    section.newFractal:update()
end

function love.draw()
    love.graphics.setBackgroundColor({231, 231, 231})
    if fractal then fractal:draw() end
    Suit.draw()
end

-- TODO
function love.resize(width, height)

end

function love.textinput(t)
    Suit.textinput(t)
end

function love.keypressed(key)
    Suit.keypressed(key)
end


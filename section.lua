local Suit = require('theme')
local Node, Fractal = require('fractal')()

local section = {}
-- Section: Drawing Fractal
section.fractal = {
    x = 0,
    y = 0,
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

function section.fractal:resize(width, height)

end

-- Section: New Fractal
section.newFractal = {
    x = love.graphics.getWidth() / 2 - 125,
    y = (love.graphics.getHeight() - 6*40) / 2, 
    width = 250,
    cellHeight = 40,
    active = false,
    input = {
        length = {text = '150'},
        scale = {text = '0.5'},
        angle = {text = '60'},
        step = {text = '1'},
        branches = {text = '2'}
    }
}

function section.newFractal:update()
    if  self.active then
        Suit.layout:reset(self.x, self.y)

        Suit.Label('New Fractal', Suit.layout:row(self.width, self.cellHeight))
        -- self.input for start length
        Suit.layout:push(Suit.layout:row())
            Suit.Label('Length', {align = 'left'}, Suit.layout:col(self.width * 0.6, 40))
            Suit.Input(self.input.length, Suit.layout:col(self.width * 0.4))
        Suit.layout:pop()

        -- self.input for scale
        Suit.layout:push(Suit.layout:row())
            Suit.Label('Scale', {align = 'left'}, Suit.layout:col(self.width * 0.6, 40))
            Suit.Input(self.input.scale, Suit.layout:col(self.width * 0.4))
        Suit.layout:pop()

        -- self.input for angle
        Suit.layout:push(Suit.layout:row())
            Suit.Label('Angle', {align = 'left'}, Suit.layout:col(self.width * 0.6, 40))
            Suit.Input(self.input.angle, Suit.layout:col(self.width * 0.4))
        Suit.layout:pop()

        -- self.input for branches
        Suit.layout:push(Suit.layout:row())
            Suit.Label('Branches per Iteration', {align = 'left'}, Suit.layout:col(self.width * 0.6, 40))
            Suit.Input(self.input.branches, Suit.layout:col(self.width * 0.4))
        Suit.layout:pop()

        -- button, which creates a new fractal with given scale and angle
        Suit.layout:push(Suit.layout:row())
            if Suit.Button('Create', Suit.layout:col(self.width / 2, 40)).hit then
                fractal = Fractal(section.fractal.x + section.fractal.width / 2, love.graphics.getHeight(), self.input.length.text, self.input.scale.text, math.rad(self.input.angle.text), self.input.branches.text)
                self.active = false
            end
            if Suit.Button('Cancel', Suit.layout:col(self.width / 2, 40)).hit then
                self.active = false
            end
        Suit.layout:pop()

        _, self.height = Suit.layout:nextRow()
        self.height = self.height - self.y
    end
end

function section.newFractal:resize(width, height)

end

-- Section: Control
section.control = {
    x = (love.graphics.getWidth() - 2 * 40) / 2,
    y = 0,
    width = 40,
    image = {
        next = love.graphics.newImage('img/next.png'),
        nextHovered = love.graphics.newImage('img/next-hovered.png'),
        new = love.graphics.newImage('img/new.png'),
        newHovered = love.graphics.newImage('img/new-hovered.png')
    }
}
function section.control:update()
    Suit.layout:reset(self.x, self.y)
    -- Button for creating new Fractal
    if Suit.ImageButton(self.image.new, {hovered = self.image.newHovered}, Suit.layout:col(self.width, 40)).hit then
        section.newFractal.active = not(section.newFractal.active )
    end
    if Suit.ImageButton(self.image.next, {hovered = self.image.nextHovered}, Suit.layout:col()).hit then
        if fractal then
            fractal:iterate()
        end
    end
end

function section.control:resize(width, height)

end

return section
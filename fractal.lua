-- Modules
local Class = require('lib.middleclass')
local Vector = require('lib.vector')
local Timer = require('lib.timer')

-- Objects
-- Node
local Node = Class('Node')
Node.static.color = {0, 0, 0}
Node.static.animation = {}
Node.static.animation.enabled = false
Node.static.animation.duration = 0.5
function Node:initialize(pos, dim, width)
    self.pos = pos:clone()
    self.dim = dim:clone()

    self.dimAnim = {x = 0, y = 0}

    self.width = width or 1
    if Node.static.animation.enabled then
        Timer.tween(Node.animation.duration, self, {dimAnim = {x = dim.x}})
        Timer.tween(Node.animation.duration, self, {dimAnim = {y = dim.y}})
    else
        self.dimAnim = {x = dim.x, y = dim.y}
    end 
end

function Node:unpack()
    return self.pos, self.dim, self.color, self.width
end

function Node:draw()
    love.graphics.setLineWidth(self.width)
    love.graphics.setColor(Node.color)
    love.graphics.line(self.pos.x, self.pos.y, self.pos.x + self.dimAnim.x, self.pos.y + self.dimAnim.y)
end

-- Fractal
local Fractal = Class('Fractal')
function Fractal:initialize(x, y, length, scale, angle)
    self.pos = Vector(x, y)
    self.len = length
    self.scale = scale
    self.angle = angle

    self.iter = 0
    self.nodes = {
        Node(self.pos, Vector(0, -length))
    }
end

local function calcNodeLen(iteration, startLength, scale)
    return startLength * math.pow(scale, iteration)
end

local function calcNodes(iteration)
    return math.pow(2, iteration)
end

function Fractal:calcNodes()
    return calcNodes(self.iter)
end

-- FIXME: improve dimension calculations
local function calcDim(iter, len, scale, angle)
    local width, height = 0, 0
    
    for i = 0, iter - 1 do
        local nodeLen = len * math.pow(scale, i)
        width = width + (i % 2 == 1 and nodeLen * math.sin(angle) or 0)
        height = height + nodeLen * (i % 2 == 1 and math.cos(angle) or 1)
    end

    return 2 * width, height
end

function Fractal:calcDim()
    return calcDim(self.iter, self.len, self.scale, self.angle)
end

function Fractal:iterate()
    local olderNodes = #self.nodes
    for n = 0, calcNodes(self.iter) - 1 do
        local pos, dim = self.nodes[olderNodes - n]:unpack()
        local trimDim = dim:trimmed(dim:len() * self.scale)

        table.insert(self.nodes, Node(pos + dim, trimDim:rotated(self.angle)))
        table.insert(self.nodes, Node(pos + dim, trimDim:rotated(2 * math.pi - self.angle)))
    end
    self.iter = self.iter + 1
end

function Fractal:draw()
    for n = 1, #self.nodes do
        self.nodes[n]:draw()
    end
end

function Fractal:move(x, y)
    self.pos.x, self.pos.y = self.pos.x + x, self.pos.y + y
    for n = 1, #self.nodes do
        local node = self.nodes[n]
        node.pos.x, node.pos.y = node.pos.x + x, node.pos.y + y
    end
end

return function() return Node, Fractal end
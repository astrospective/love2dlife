Gamestate = require "libs.hump.gamestate"
Class = require "libs.hump.class"
Cube =  Class{
	init = function(self, x, y, state)
	self.x = x
	self.y = y
	self.state = state
	self.lastState = 0
	end
}
function Cube:onClick()
	if self.state == 0 then
		self.state = 1
	else self.state = 0
	end
end

function Cube:update()
	self.lastState = self.state
end
Grid = Class{
	init = function(self, x, y)
	self.x = x
	self.y = y
	self.mt = {}
	for i=1,x do
		self.mt[i] = {}
		for j=1,y do
		self.mt[i][j] = Cube(i,j, 0)
		end
	end
end
}

function Grid:draw()
	for i=1,self.x,1 do
		for j=1,self.y,1 do
			if(self.mt[i][j].state == 0) then
				love.graphics.setColor (255, 255, 255)
				love.graphics.rectangle("fill", i*20, j*20, 20, 20)
			elseif(self.mt[i][j].state == 1) then
				love.graphics.setColor (0,0,0)
				love.graphics.rectangle("fill", i*20, j*20, 20, 20)
				end
		end
	end
end

function Grid:check(x,y)
	if x > 20 and x < self.x * 20 then
		if y > 20 and y < self.y * 20 then
			if self.mt[math.floor(x/20)][math.floor(y/20)].state == 0 then	
				self.mt[math.floor(x/20)][math.floor(y/20)].state = 10
			else
				self.mt[math.floor(x/20)][math.floor(y/20)].state = 0
			end
		end
	end
end
Updater = Class{
	init = function(self, x, y)
	self.x = x
	self.y = y
	end
}

local running = {}
local paused = {}
function paused:init()
end

function paused:keyreleased(key)
	if key == 'up' then
	Gamestate.switch(running)
	end
end
function paused:draw()
	love.graphics.print("Press space to begin",10,8)
	lifeLand:draw()
end

function running:init()
end
function running:keyreleased(key)
	if key == 'down' then
	Gamestate.switch(paused)
	end
end
function paused:mousepressed(x,y, mouse_btn)
	if mouse_btn == 'l' then
		lifeLand:check(x,y)
	end
end
function running:draw()
	love.graphics.print("Game Running do stuff here",10,8)
	lifeLand:draw()
end
function love.load()
	Gamestate.registerEvents()
	lifeLand = Grid(30,30)
	Gamestate.switch(paused)
	
end

function love.update(dt)


end



Gamestate = require "libs.hump.gamestate"
Class = require "libs.hump.class"
--Timer = require "libs.hump.timer"

Cell = Class{
	init = function(self,state)
		self.state = state
		self.lastState = 0
		return(self)
	end,
	update = function(self)
		self.lastState = self.state
		--return self.lastState
	end,
	setState = function(self, state)
		self.state = state
	end,
	getState = function(self)
		return self.state
	end;
	getLastState = function(self)
		local value = self.lastState
		return value
	end;
	generate = function(self, count)
		if self.lastState == 1 then
			if count < 2 then	
				self.state = 0
			elseif count > 3 then
				self.state = 0
			end
		end
		if self.lastState == 0 then
			if count == 3 then
				self.state = 1
			end
		end
	end
}

Grid = Class{
	init = function(self, x, y)
		self.x = x
		self.y = y
		self.mt = {}
		for i=1,x do
			self.mt[i] = {}
			for j=1,y do
				self.mt[i][j] = Cell(0)
			end
		end
	end;
	draw = function(self)
		for i=1,self.x,1 do
			for j=1,self.y,1 do
				if(self.mt[i][j]:getState() == 0) then
					love.graphics.setColor (255, 255, 255)
					love.graphics.rectangle("fill", (i*10), (j*10), 8, 8)
				elseif(self.mt[i][j]:getState() == 1) then
					love.graphics.setColor (0,0,0)
					love.graphics.rectangle("fill", (i*10), (j*10), 8, 8)
				end
			end
		end
	end;
	update = function(self)
		for i=1,self.x do
			for j=1,self.y do
				self.mt[i][j]:update()
			end
		end
		--do the corners
		count = 0
		count = count + self.mt[2][2]:getLastState() + self.mt[1][2]:getLastState() + self.mt[2][1]:getLastState()
		self.mt[1][1]:generate(count)
    print(count)
		count = 0
		count = count + self.mt[1][self.y-1]:getLastState() + self.mt[2][self.y]:getLastState() + self.mt[2][self.y-1]:getLastState()
		self.mt[1][self.y]:generate(count)
		count = 0
		count = count + self.mt[self.x-1][1]:getLastState() + self.mt[self.x][2]:getLastState() + self.mt[self.x-1][2]:getLastState()
		self.mt[self.x][1]:generate(count)
		count = 0
		count = count + self.mt[self.x-1][self.y-1]:getLastState() + self.mt[self.x-1][self.y]:getLastState() + self.mt[self.x][self.y-1]:getLastState()
		self.mt[self.x][self.y]:generate(count)
		--do the rest
		--first column
		for	i=1,self.y-2,1 do
			count = 0
			--count = count + self.mt[1][1+i]:getLastState() + self.mt[2][1+i]:getLastState() + self.mt[2][2+i]getLastState() + self.mt[1][3+i]:getLastState() + self.mt[2][3+i]getLastState()
			count = count + self.mt[1][i]:getLastState()
			count = count + self.mt[2][i]:getLastState()
			count = count + self.mt[2][1+i]:getLastState()
			count = count + self.mt[1][2+i]:getLastState()
			count = count + self.mt[2][2+i]:getLastState()
			self.mt[1][1+i]:generate(count)
		end
		--first row
		for i=1,self.y-2,1 do
			count = 0
			count = count + self.mt[i][1]:getLastState() 
			count = count + self.mt[2+i][1]:getLastState() 
			count = count + self.mt[i][2]:getLastState()
			count = count + self.mt[1+i][2]:getLastState()
			count = count + self.mt[2+i][2]:getLastState()
			self.mt[1+i][1]:generate(count)
		end
		--last column
		for i=1,self.y-2,1 do
			count = 0
			count = count + self.mt[self.x-1][i]:getLastState() + self.mt[self.x-1][1+i]:getLastState() + self.mt[self.x-1][2+i]:getLastState() + self.mt[self.x][i]:getLastState() + self.mt[self.x][2+i]:getLastState()
			self.mt[self.x][1+i]:generate(count)
		end
		--last row
		for i=1,self.x-2,1 do
			count = 0
			count = count + self.mt[i][self.y-1]:getLastState() + self.mt[1+i][self.y-1]:getLastState() + self.mt[2+i][self.y-1]:getLastState() + self.mt[i][self.y]:getLastState() + self.mt[2+i][self.y]:getLastState()
			self.mt[1+i][self.y]:generate(count)
		end
		for i=2,self.x-1 do
			for j=2,self.y-1 do
				count = 0
				count = count + self.mt[i-1][j-1]:getLastState()
				count = count + self.mt[i-1][j]:getLastState()
				count = count + self.mt[i-1][j+1]:getLastState() 
				count = count + self.mt[i][j-1]:getLastState() 
				count = count + self.mt[i][j+1]:getLastState() 
				count = count + self.mt[i+1][j-1]:getLastState() 
				count = count + self.mt[i+1][j]:getLastState() 
				count = count + self.mt[i+1][j+1]:getLastState()
				self.mt[i][j]:generate(count)
			end
		end
	return(1)
	end;
	check = function(self,x,y)
		if x >= 10 and x <= (self.x * 10) then
			if y >= 10 and y <= (self.y * 10) then
				if self.mt[math.floor(x/10)][math.floor(y/10)]:getState() == 0 then	
					self.mt[math.floor(x/10)][math.floor(y/10)]:setState(1)
				else
					self.mt[math.floor(x/10)][math.floor(y/10)]:setState(0)
				end
			end
		end
	end;
}

local running = {}
local paused = {}
local mainMenu = {}
function paused:init()
end

function paused:keyreleased(key)
	if key == 'up' then
	Gamestate.switch(running)
	end
end
function paused:draw()
	love.graphics.print("Press up to begin,click to toggle",10,820)
	lifeLand:draw()
end

function running:init()
	--Timer.addPeriodic(1, lifeLand:update())
end
function running:keyreleased(key)
	if key == 'down' then
	Gamestate.switch(paused)
	end
end
function paused:mousepressed(x,y, mouse_btn)
  --print(x)
  --print(y)
	if mouse_btn == 'l' then
		lifeLand:check(x,y)
	end
end
function running:draw()
	love.graphics.print("Press Down to Pause",10,820)
	lifeLand:draw()
end
function love.load()
	Gamestate.registerEvents()
	--love.window.setMode (840, 840)
	lifeLand = Grid(80,80)
	Gamestate.switch(paused)
	
end
time = 0
function running:update(dt)
  time = time + dt
  if time >= .25 then
    time = 0
    lifeLand:update()
  end
end


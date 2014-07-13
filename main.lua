Gamestate = require "libs.hump.gamestate"
Class = require "libs.hump.class"
--Timer = require "libs.hump.timer"

--Cell = Class{
--	init = function(self,state)
--		self.state = state
--		self.lastState = 0
--		return(self)
--	end,
--	update = function(self)
--		self.lastState = self.state
--		--return self.lastState
--	end,
--	setState = function(self, state)
--		self.state = state
--	end,
--	getState = function(self)
--		return self.state
--	end;
--	getLastState = function(self)
--		local value = self.lastState
--		return value
--	end;
offsetX = 0
offsetY = 0
generate = function(state, count)
	if state == 1 then
		if count < 2 then	
			return 0
		elseif count > 3 then
			return 0
		end
	end
	if state == 0 then
		if count == 3 then
			return 1
		end
	end
end
--}

Grid = Class{
	init = function(self, x, y)
		self.x = x
		self.y = y
		self.mt = {}
		self.fmt = {}
    self.display = {}

    
		for i=1,x do
			self.mt[i] = {}
      self.fmt[i] = {}
			for j=1,y do
				self.mt[i][j] = math.random(0,1)
        self.fmt[i][j] = 0
			end
		end
		--self.fmt = self.mt
	end;
	draw = function(self)
		for i=1,80,1 do
			for j=1,80,1 do
				if(self.mt[i+offsetX][j+offsetY] == 0) then
					love.graphics.setColor (255, 255, 255)
					love.graphics.rectangle("fill", (i*10), (j*10), 8, 8)
				elseif(self.mt[i+offsetX][j+offsetY] == 1) then
					love.graphics.setColor (0,0,0)
					love.graphics.rectangle("fill", (i*10), (j*10), 8, 8)
				end
			end
		end
	end;
	update = function(self)
		--for i=1,self.x do
		--	for j=1,self.y do
		--		print("this cell's location is",i," ",j," ","it's value is"," ",self.mt[i][j])
		--	end
		--end
		--do the corners
		count = 0
		count = count + self.mt[2][2] + self.mt[1][2] + self.mt[2][1]
		self.fmt[1][1] = generate(self.mt[1][1],count)
    --print(count)
		count = 0
		count = count + self.mt[1][self.y-1] + self.mt[2][self.y] + self.mt[2][self.y-1]
		self.fmt[1][self.y]=generate(self.mt[1][self.y],count)
		count = 0
		count = count + self.mt[self.x-1][1] + self.mt[self.x][2] + self.mt[self.x-1][2]
		self.fmt[self.x][1] = generate(self.mt[self.x][1],count)
		count = 0
		count = count + self.mt[self.x-1][self.y-1] + self.mt[self.x-1][self.y] + self.mt[self.x][self.y-1]
		self.fmt[self.x][self.y]=generate(self.mt[self.x][self.y],count)
		--do the rest
		--first column
		for	i=1,self.y-2,1 do
			count = 0
			--count = count + self.mt[1][1+i] + self.mt[2][1+i] + self.mt[2][2+i] + self.mt[1][3+i] + self.mt[2][3+i]
      --print(count)
      --print(self.mt[1][i])
			count = count + self.mt[1][i]
			count = count + self.mt[2][i]
			count = count + self.mt[2][1+i]
			count = count + self.mt[1][2+i]
			count = count + self.mt[2][2+i]
			self.fmt[1][1+i]=generate(self.mt[1][1+i],count)
		end
		--first row
		for i=1,self.y-2,1 do
			count = 0
			count = count + self.mt[i][1] 
			count = count + self.mt[2+i][1] 
			count = count + self.mt[i][2]
			count = count + self.mt[1+i][2]
			count = count + self.mt[2+i][2]
			self.fmt[1+i][1]=generate(self.mt[1+i][1],count)
		end
		--last column
		for i=1,self.y-2,1 do
			count = 0
			count = count + self.mt[self.x-1][i] + self.mt[self.x-1][1+i] + self.mt[self.x-1][2+i] + self.mt[self.x][i] + self.mt[self.x][2+i]
			self.fmt[self.x][1+i]=generate(self.mt[self.x][1+i],count)
		end
		--last row
		for i=1,self.x-2,1 do
			count = 0
			count = count + self.mt[i][self.y-1] + self.mt[1+i][self.y-1] + self.mt[2+i][self.y-1] + self.mt[i][self.y] + self.mt[2+i][self.y]
			self.fmt[1+i][self.y]=generate(self.mt[1+i][self.y],count)
		end
		for i=2,self.x-1 do
			for j=2,self.y-1 do
				count = 0
				count = count + self.mt[i-1][j-1]
				count = count + self.mt[i-1][j]
				count = count + self.mt[i-1][j+1] 
				count = count + self.mt[i][j-1] 
				count = count + self.mt[i][j+1] 
				count = count + self.mt[i+1][j-1] 
				count = count + self.mt[i+1][j] 
				count = count + self.mt[i+1][j+1]
				self.fmt[i][j]=generate(self.mt[i][j],count)
			end
		end
	--self.mt = deepcopy(self.fmt)
  for i=1,self.x do
		for j=1,self.y do
			if self.fmt[i][j] == 1 then
        self.mt[i][j] = 1
      elseif self.fmt[i][j] == 0 then
        self.mt[i][j] = 0
      end
      
		end
	end
	return(1)
	end;
	check = function(self,x,y)
		if x >= 10 and x <= (self.x * 10) then
			if y >= 10 and y <= (self.y * 10) then
				if self.mt[math.floor(x/10)][math.floor(y/10)] == 0 then	
					self.mt[math.floor(x/10)][math.floor(y/10)]=1
				else
					self.mt[math.floor(x/10)][math.floor(y/10)]=0
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
	if key == 'p' then
	Gamestate.switch(running)
	end
end
function paused:draw()
	love.graphics.print("Press p to begin,click to toggle",10,820)
	lifeLand:draw()
end

function running:init()
	--Timer.addPeriodic(1, lifeLand:update())
end
function running:keyreleased(key)
	if key == 'p' then
	Gamestate.switch(paused)
end
if key == 'right' then
  if offsetX < 1024 then
    offsetX = offsetX + 10
  end
end
if key == 'left' then
  if offsetX > 10 then
    offsetX = offsetX - 10
  end
end
if key == 'down' then
  if offsetY < 1024 then
    offsetY = offsetY + 10
  end
end
if key == 'up' then
  if offsetY > 10 then
    offsetY = offsetY - 10
  end
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
	love.graphics.print("Press p to Pause",10,820)
	lifeLand:draw()
end
function love.load()
	Gamestate.registerEvents()
	--love.window.setMode (840, 840)
	lifeLand = Grid(1024,1024)
	Gamestate.switch(paused)
	
end
time = 0
function running:update(dt)
  time = time + dt
  print(time)
  if time >= .25 then
    time = 0
    lifeLand:update()
  end
end



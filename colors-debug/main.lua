--colorshapes
--[[todo:
use a shader to make overlapping more significant, eliminate blob highlight]]

local moonshine = require("moonshine")
flux = require("flux")
require("levels")

function love.load()
	width, height = love.graphics.getDimensions() --800, 600

	effectChain = moonshine.chain(moonshine.effects.glow) --glow effect object
	effectChain.glow.strength = 8

		local l = getLevel(1)
			bodies = l.bodies 
			staticBodies = l.staticBodies
			drawables = l.drawables

end

local grabbedPolygon = 0
local mx, my = 0, 0 --mouse location

local handlePoint = {}
	handlePoint.bodyIndex = 1
	handlePoint.vertexIndex = 1
	handlePoint.boxSize = 10

local bindings = {
	quit = function() love.event.quit() end,
	reset = function() for _, b in pairs(bodies) do b:load(b.sv, 1) end end,
	save = function() for _, b in pairs(bodies) do b.sv = b:save() end end
}	

local keys = {
	escape = "quit",
	["return"] = "reset",
	s = "save"
}

function inputHandler( input )
    local action = bindings[input]
    if action then  return action() end -- the two parentheses after it means execute. why is return needed though
end

function love.keypressed( k )
    local binding = keys[k]
    return inputHandler( binding )
end

function love.mousemoved(x, y, dx, dy)
	mx, my = x, y
	if grabbedPolygon > 0 and not handleVisible then --move poly
		local vertices = bodies[grabbedPolygon].vertices
		for i = 1, #vertices, 1 do 
			if i % 2 == 0 then
				vertices[i] = vertices[i] + dy 
			else
				vertices[i] = vertices[i] + dx
			end
		end

	elseif handleVisible and love.mouse.isDown("1") then --move handle
		local handledBody = bodies[handlePoint.bodyIndex] 

		local vx = handledBody.vertices[handlePoint.vertexIndex] 
		local vy = handledBody.vertices[handlePoint.vertexIndex + 1]

		--updating the handledBody will update the table of vertices because they are linked by reference
		handledBody.vertices[handlePoint.vertexIndex] = vx + dx
		handledBody.vertices[handlePoint.vertexIndex + 1] = vy + dy 
	end
end


function love.update(dt)
	flux.update(dt)

	if love.mouse.isDown("1") then
		if grabbedPolygon == 0 then
			for i = 1, #bodies do 
				if isPointInPolygon(mx, my, bodies[i].vertices) and i ~= inPoly then 
					grabbedPolygon = i 
				end
			end
		end
	else grabbedPolygon = 0 
	end

	handleVisible = false
	for k, v in pairs(bodies) do 
		for i = 1, #v.vertices, 2 do
			if (math.abs(v.vertices[i] - mx) < handlePoint.boxSize and 
				math.abs(v.vertices[i + 1] - my) < handlePoint.boxSize) and 
					k ~= inPoly then 

						handleVisible = true
						handlePoint.bodyIndex = k
						handlePoint.vertexIndex = i
					
			end
		end
	end

	handlePoint.x = bodies[handlePoint.bodyIndex].vertices[handlePoint.vertexIndex]
	handlePoint.y = bodies[handlePoint.bodyIndex].vertices[handlePoint.vertexIndex + 1]
end


-- From here: https://love2d.org/forums/viewtopic.php?t=89699
function isPointInPolygon(x, y, poly)
 -- poly is a Lua list of pairs like {x1, y1, x2, y2, ... xn, yn}
	local x1, y1, x2, y2
	local len = #poly
	x2, y2 = poly[len - 1], poly[len] --sets x2, y2 to the last vertex
	local wn = 0
	for idx = 1, len, 2 do --for x values, starting at the first 
		x1, y1 = x2, y2		
		x2, y2 = poly[idx], poly[idx + 1]  --set x1, y1 to x2, y2 then set x2, y2 to the next vertex in the array, starting at the first
											--so x2, y2 will be the vertex that comes after x1, y1
		if y1 > y then 
			if (y2 <= y) and (x1 - x) * (y2 - y) < (x2 - x) * (y1 - y) then  --please try to understand this
				wn = wn + 1
			end
		else
			if (y2 > y) and (x1 - x) * (y2 - y) > (x2 - x) * (y1 - y) then
				wn = wn - 1
			end
		end
	end
	return wn % 2 ~= 0 -- even/odd rule
end


--in the regular window, without blendmode = add, polygons won't render
--but won't render in a canvas with blendmode = add

canvas = love.graphics.newCanvas()
lg = love.graphics

function love.draw()
	lg.setCanvas(canvas)
		lg.clear()

		-- effectChain.draw(function()
		for _, v in ipairs(bodies) do
			love.graphics.setColor(v.color, 1)
			love.graphics.polygon("fill", v.vertices)
		end
		-- end)
	lg.setCanvas()


	lg.setColor(1, 1, 1, 1)
	lg.draw(canvas, 0, 0)

	if handleVisible then
		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.circle("fill", handlePoint.x, handlePoint.y, handlePoint.boxSize)
	end

	for _, o in pairs(drawables.orbs) do 
		love.graphics.draw(o.texture, o.x, o.y)
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print('"enter" to reset \n "s" to save', width - 150, 10)

end


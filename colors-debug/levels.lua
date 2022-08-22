-- [[todo: use lua data storage methods somehow ]]
-- [[pass position of player]]

--function invert(t) end

local orbs = {
		red = {love.graphics.newImage("assets/red.png"), {1, 0, 0}},
		blue = {love.graphics.newImage("assets/blue.png"), {0, 0, 1}},
		green = {love.graphics.newImage("assets/green.png"), {0, 1, 0}}
		}

local function init(levelNumber)
 	L = {}
			L.bodies = {
				newPolyBody({122, 49, 274, 76, 247, 167, 153, 226}, {0, 0, 1}, bod.b1),
				newPolyBody({539, 147, 574, 215, 681, 118, 624, 50}, {0, 1, 0}, bod.b2),
				newPolyBody({516, 358, 512, 489, 565, 488, 612, 339}, {1, 0, 0}, bod.b3)
				}

			L.drawables = {}
				--L3.drawables.background = background
				L.drawables.box = boxImage
				L.drawables.orbs = {
					newOrb(orbs.blue, {x = 400, y = 300}),
					newOrb(orbs.red, {x = 100, y = 100}),
					newOrb(orbs.green, {x = 300, y = 300})
					}

	if levelNumber == 1 then return L end
	
end

--returns square box
function newBox(px, py, r) --top left point, width
	return{px,py, px+r,py, px+r,py+r, px,py+r}
end

function newPolyBody(vertices, color, home)
	local b = {}
	b.vertices = vertices
	b.color = color or {1, 1, 1}

	b.save = function(body)
		local savedPoints = {}
		for i = 1, #body.vertices do 
			savedPoints[i] = body.vertices[i]
		end
		return savedPoints
	end

	b.load = function(body, savedPoints, speed, ease)
		local speed = speed or 4
		local ease = ease or "quadout"
		for i = 1, #savedPoints do
			flux.to(body.vertices, speed, {[i] = savedPoints[i]}):ease(ease)
		end
	end

	b.sv = b:save()
	return b
end

function newOrb(img, pos, home) --home = nextPos
	local o = {}
	o.x, o.y = pos.x, pos.y
	o.texture = img[1]
	return o
end

function getLevel(levelNumber)
	
 	local L = {}
		L.bodies = {
			newPolyBody({122, 49, 274, 76, 247, 167, 153, 226}, {0, 0, 1}),
			newPolyBody({539, 147, 574, 215, 681, 118, 624, 50}, {0, 1, 0}),
			newPolyBody({516, 358, 512, 489, 565, 488, 612, 339}, {1, 0, 0})
			}

		L.drawables = {}
			--L3.drawables.background = background
			L.drawables.box = boxImage
			L.drawables.orbs = {
				newOrb(orbs.blue, {x = 400, y = 300}),
				newOrb(orbs.red, {x = 100, y = 100}),
				newOrb(orbs.green, {x = 300, y = 300})
				}

	if levelNumber == 1 then return L end
	
end


--jeez this is rough

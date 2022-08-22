return
love.graphics.newShader[[uniform Image bgImage;

	vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
	{
		vec2 st = screen_coords/love_ScreenSize.xy;

		vec4 texturecolor = Texel(tex, texture_coords);
		vec4 bgpixel = Texel(bgImage, st);
		return bgpixel - texturecolor * color;
	}
]]
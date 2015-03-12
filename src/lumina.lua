-- uses LuaFileSystem and cqueues
do
	function _err( str )
		error( setmetatable( {}, {__tostring=function() return str end} ) )
	end
	local ok;
	ok, cqueues = pcall( require, "cqueues" )
	if not ok then
		_err( "cqueues library not found!" )
	end
	ok, lfs = pcall( require, "lfs" )
	if not ok then
		_err( "lfs library not found!" )
	end
	local func, err = loadfile( "lib/lumina.lua" )
	if not func then
		_err( "lumina library unloadable:\n" .. err )
	end
	ok, lumina = pcall( func )
	if not ok then
		_err( "lumina module unloadable:\n" .. err)
	end
	if lfs.attributes( "config.json", "mode" ) ~= "file" then
		_err( "unable to locate config.json configuration file!" )
	end
	local f, err = io.open( "config.json" )
	(function()return not f and _err( err )end)()
	json = require( "lib.json" )
	local t = json.decode( f:read( "*a" ) )
	f:close()
	config = {}
	for k, v in pairs( t ) do
		if v['type'] == "configuration" then
			for _k, _v in pairs( v ) do
				if type( _v ) == "table" then
					for __k, __v in pairs( _v ) do
						(config[_k] or (function()config[_k]={}return config[_k]end)())[__k] = __v
					end
				else
					config[_k] = _v
				end
			end
		end
	end
	if config.modified == false then
		_err( "config.json labeled unmodified!" )
	end
	local mkwc = require( "lib.mkwc" )
end

local function getdir()
	local t = {}
	function find( dir )
		for area in lfs.dir( dir .. "/" ) do
			if area:match( "[^.]" ) then
				if lfs.attributes( dir .. "/" .. area, "mode" ) == "file" then
					table.insert( t, dir .. "/" .. area )
				else
					find( dir .. "/" .. area )
				end
			end
		end
	end
	find( "." )
	return t
end
return getdir

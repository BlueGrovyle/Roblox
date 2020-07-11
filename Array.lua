local array_metatable = {
	__tostring = function(array)
		local str = '{'
		for index,value in ipairs(array) do
			str = str .. tostring(value) .. (index < array.length() and ',' or '')
		end
		str = str .. '}'
		return str
	end
}

local Array = {}
Array.from = function(array,mapping_function)
	if not mapping_function then return error() end
	local new_array = Array()
	for index,element in ipairs(array) do
		new_array.push(mapping_function(element))
	end
	return new_array
end
local Array_metatable = {
	__call = function(self,elements)
		local array = setmetatable({},array_metatable)
		array.concat = function(other_array)
			local new_array = Array(array)
			new_array.push(other_array)
			return new_array
		end
		array.length = function()
			return #array
		end
		array.pop = function(number_of_elements)
			if number_of_elements then
				for count = 1,number_of_elements do
					array.pop()
					if array.length() == 0 then return end
				end
			else array[array.length()] = nil end
		end
		array.push = function(new_element)
			if typeof(new_element) == 'table' then
				for index,element in ipairs(new_element) do
					array.push(element)
				end
			else table.insert(array,new_element) end
		end
		if elements then array.push(elements) end
		return array
	end
}

setmetatable(Array,Array_metatable)

return Array

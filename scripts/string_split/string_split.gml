///@function	string_split(str, del)
///@desc			Splits a string by the delimeter
///@author		Evoleo
///@param		{string} str
///@param		{string} del
function string_split(str, del) {
	var ans = []
	var last_pos = 1
	while(true) {
		var pos = string_pos_ext(del, str, last_pos)
		if (pos <= 0) break
		
		var segment = string_copy(str, last_pos, pos - last_pos)
		array_push(ans, segment)
		last_pos = pos + string_length(del)
	}
	array_push(ans, string_copy(str, last_pos, string_length(str) - last_pos + 1))
	
	return ans
}

//show_message(string_split("a, b, c", ", "))
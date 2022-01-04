///@function	validate(val, expected_type)
///@param		{any} val
///@param		{string} expected_type
function validate(val, expected_type) {
	var check = false
	if is_string(expected_type) {
		var checker_func_name1 = "is_" + expected_type
		var checker_func_name2 = "is" + string_upper(string_copy(expected_type, 1, 1)) + string_copy(expected_type, 2, string_length(expected_type)-1)
		// is_type() function
		if variable_global_exists(checker_func_name1) {
			var checker_function = variable_global_get(checker_func_name1)
			check = checker_function(val)
		}
		// isType() function
		else if variable_global_exists(checker_func_name2) {
			var checker_function = variable_global_get(checker_func_name2)
			check = checker_function(val)
		}
		else {
			if is_struct(val)
				check = instanceof(val) == expected_type || typeof(val) == expected_type
			else
				check = typeof(val) == expected_type
		}
	}
	//else if is_real(expected_type) { // instance of a constructor
		
	//}
	else {
		throw "validate(): 'expected_type' should be a string or a contructor reference!"
		check = false
	}
	
	
	if !check {
		throw ("\n#\n# Validation failed! Expected \"" + expected_type + "\", got \"" + typeof(val) + "\". (check the stacktrace below)\n#\n")
		return false
	}
	return true
}

function __validate_tests() {
	validate("a string", "string")
	validate(12, "number")
	validate("string", "number") // supposed to crash here
}

//__validate_tests()
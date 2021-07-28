#macro mouse_check_button __mouse_check_button
#macro mouse_check_button_pressed __mouse_check_button_pressed
#macro mouse_check_button_released __mouse_check_button_released

#macro MOUSE_DEVICE_COUNT 5

function __mouse_check_button(button) {
	for(var i = 0; i < MOUSE_DEVICE_COUNT; i++) {
		if (device_mouse_check_button(i, button))
			return true
	}
	return false
}

function __mouse_check_button_pressed(button) {
	for(var i = 0; i < MOUSE_DEVICE_COUNT; i++) {
		if (device_mouse_check_button_pressed(i, button))
			return true
	}
	return false
}

function __mouse_check_button_released(button) {
	for(var i = 0; i < MOUSE_DEVICE_COUNT; i++) {
		if (device_mouse_check_button_released(i, button))
			return true
	}
	return false
}
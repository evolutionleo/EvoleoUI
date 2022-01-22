#macro mouse_check_button __mouse_check_button
#macro mouse_check_button_pressed __mouse_check_button_pressed
#macro mouse_check_button_released __mouse_check_button_released

// multi-touch
#macro MOUSE_DEVICE_COUNT 5


/**
@ignore
*/
function TouchStruct() constructor {
	x = 0
	y = 0
	left = {
		down: false,
		pressed: false,
		released: false
	}
	right = {
		down: false,
		pressed: false,
		released: false
	}
}

global.touches = []
for(var i = 0; i < MOUSE_DEVICE_COUNT; i++) {
	global.touches[i] = new TouchStruct()
}

/// @context TouchStruct
function update_touch_positions() {
	for(var i = 0; i < MOUSE_DEVICE_COUNT; i++) {
		with(global.touches[i]) {
			self.x = device_mouse_x(i)
			self.y = device_mouse_y(i)
			with(global.touches[i].left) {
				down = device_mouse_check_button(i, mb_left)
				pressed = device_mouse_check_button_pressed(i, mb_left)
				released = device_mouse_check_button_released(i, mb_left)
			}
			with(global.touches[i].right) {
				down = device_mouse_check_button(i, mb_right)
				pressed = device_mouse_check_button_pressed(i, mb_right)
				released = device_mouse_check_button_released(i, mb_right)
			}
		}
	}
}

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
// A script containing all the basic components that come out of the box

function UIRoot(props = {}, children = []) : UIElement(props, children) constructor {
	parent = -1
	
	x = 0
	y = 0
	
	//width = room_width
	//height = room_height
	width = UI_WIDTH
	height = UI_HEIGHT
	
	style = new Style({
		display: "block",
		position: "absolute"
	})
	
	mount = function() {
		trace("UI Root mounted btw")
	}
	
	render = function() {
		trace("UI Root render called?")
		return []
	}
}

function Div(props = {}, children = []) : UIElement(props, children) constructor {}

function Text(props = {}, children = []) : UIElement(props, children) constructor {}

function UIClickable(props = {}, children = []) : UIElement(props, children) constructor {
	hovered = false
	clicked = false
	
	e = false
	
	static _update = function() {
		update()
		
		
		if isHovered() {
			if (!e) {
				//trace("_updatee")
				//trace(__element_type)
				e = true
			}
			onHovered()
			
			if !hovered {
				onHover()
			}
			
			hovered = true
			
			if device_mouse_check_button(0, mb_left) {
				clicked = true
				onHold()
				
				if device_mouse_check_button_pressed(0, mb_left) {
					show_debug_message("clicc")
					show_debug_message(__element_type)
					onClick()
				}
			}
			else {
				if device_mouse_check_button_released(0, mb_left) {
					onRelease()
				}
				
				clicked = false
			}
		}
		else {
			hovered = false
			clicked = false
		}
	}
	
	static isHovered = function() {
		var mx = device_mouse_raw_x(0),
			my = device_mouse_raw_y(0)
		
		return (draw_pos.x <= mx && mx <= draw_pos.x + width)
		   and (draw_pos.y <= my && my <= draw_pos.y + height)
	}
	
	// events
	static onClick = function() {} // when lmb is pressed
	static onRelease = function() {} // when lmb is released
	static onHold = function() {} // when lmb is held
	static onHover = function() {} // just hovered
	static onHovered = function() {} // while being hovered
}


function Button(props = {}, children = []) : UIClickable(props, children) constructor {}

function Sprite(props = {}, children = []) : UIElement(props, children) constructor {
	setState({ spr: 0, img: 0, xscale: 1, yscale: 1, angle: 0, color: c_white, alpha: 1 })
	// inherit
	__merge_structs(state, props)
	variable_struct_remove(state, "style")
	//setState({ spr: props.spr, img: props.img ? props.img : 0 })
	
	
	static draw = function() {
		if (state.xscale == 1 and state.yscale == 1)
			draw_sprite_stretched_ext(state.spr, state.img, x, y, width, height, state.color, state.alpha)
		else
			draw_sprite_ext(state.spr, state.img, x, y, state.xscale, state.yscale, state.angle, state.color, state.alpha)
	}
}

function UIInput(props = {}, children = []) : UIClickable(props, children) constructor {
	setState({ focused: false, value: undefined })
	
	static onFocus = function() {}
	static onUnfocus = function() {}
	
	static updateFocus = function() {
		if (mouse_check_button_pressed(mb_left)) {
			if (hovered) {
				setState({focused: true})
				onFocus()
			}
			else {
				setState({focused: false})
				onUnfocus()
			}
		}
	}
	
	static update = function() {
		updateFocus()
	}
}

function TextBox(props = {}, children = []) : UIInput(props, children) constructor {
	setState({ value: "", pointer: 0 })
	if (variable_struct_exists(props, "value"))
		setState({value: props.value})
	
	setState({ blink: true, blink_timer: 20 })
	
	max_blink_timer = 20
	max_length = 15
	
	
	
	static onFocus = function() {
		setState({ pointer: string_length(state.value) })
	}
	
	static premount = function() {
		default_style = new Style({
			border_width: 2,
			border_color: c_white,
			padding: 10,
			width: 250,
			height: 50,
			font: fNormal,
			cursor_color: c_white, // specific style variables
			cursor_alpha: 1,
			cursor_width: 3,
			color: c_white
		})
	}
	
	
	static drawCursor = function(x, y, h) {
		draw_sprite_stretched_ext(__sEmptySquare, 0, x, y, style.cursor_width, h, style.cursor_color, style.cursor_alpha)
	}
	
	static draw = function() {
		renderText(state.value, x-canvas.scroll.x, y-canvas.scroll.y)
		
		draw_set_font(style.font)
		var pre_string = string_copy(state.value, 1, state.pointer)
		
		if (state.focused and state.blink) {
			drawCursor(x + string_width(pre_string) + 2, y, string_height(state.value))
		}
	}
	
	static clear = function() {
		setState({ value: "" })
		onChange(state.value)
	}
	
	static update = function() {
		updateFocus()
		
		if (state.blink_timer == 0) { // toggle
			setState({ blink: !state.blink, blink_timer: max_blink_timer })
		}
		else { // tick down
			setState({ blink_timer: state.blink_timer - 1 })
		}
		
		if (state.focused) {
			if (keyboard_check_pressed(vk_anykey)) {
				switch(keyboard_key) {
					case vk_backspace: // erase before
						trace(state.pointer)
						
						if (state.pointer > 0) { // +1 because of gosh darn 1-indexing
							setState({ value: string_delete(state.value, state.pointer, 1) })
							setState({ pointer: state.pointer-1 })
							onChange(state.value)
						}
						break
					case vk_delete: // erase after
						trace(state.pointer)
						
						if (state.pointer < string_length(state.value)) {
							setState({ value: string_delete(state.value, state.pointer+1, 1) })
							onChange(state.value)
						}
						break
					case vk_right:
						setState({pointer: state.pointer+1})
						break
					case vk_left:
						setState({pointer: state.pointer-1})
						break
					case vk_up:
						setState({pointer: 0})
						break
					case vk_down:
						setState({pointer: string_length(state.value)})
						break
					case vk_space: // spacebar
						setState({ value: string_insert(" ", state.value, state.pointer+1) })
						setState({ pointer: state.pointer+1 })
						onChange(state.value)
						
						break
					default:
						var k = keyboard_key
						if (ord("A") <= k and k <= ord("Z")) // uppercase letters 
						or (ord("a") <= k and k <= ord("z")) // lowercase letters
						or (ord("0") <= k and k <= ord("9")) // numbers
						{
							if (string_length(state.value) < max_length) {
								setState({ value: string_insert(keyboard_lastchar, state.value, state.pointer+1) })
								setState({ pointer: state.pointer+1 }) // order matters btw
								onChange(state.value)
							}
						}
						break
				}
			}
		}
		
		// clamp the pointer
		setState({ pointer: clamp(state.pointer, 0, string_length(state.value)) })
	}
}

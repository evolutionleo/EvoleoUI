global.__draw_state = {
	halign: fa_left,
	valign: fa_top,
	color: c_white,
	alpha: 1.0,
	font: -1
}

function draw_get() {
	with(global.__draw_state) {
		halign = draw_get_halign()
		valign = draw_get_valign()
		color = draw_get_color()
		alpha = draw_get_alpha()
		font = draw_get_font()
	}
}

function draw_reset() {
	draw_reset_halign()
	draw_reset_valign()
	draw_reset_color()
	draw_reset_alpha()
	draw_reset_font()
}


function draw_set_align(halign, valign) {
	gml_pragma("forceinline")
	draw_set_halign(halign)
	draw_set_valign(valign)
}

function draw_reset_color() {
	gml_pragma("forceinline")
	draw_set_color(global.__draw_state.color)
}

function draw_reset_font() {
	gml_pragma("forceinline")
	draw_set_font(global.__draw_state.alpha)
}

function draw_reset_alpha() {
	gml_pragma("forceinline")
	draw_set_alpha(global.__draw_state.alpha)
}

function draw_reset_halign() {
	gml_pragma("forceinline")
	draw_set_halign(global.__draw_state.halign)
}

function draw_reset_valign() {
	gml_pragma("forceinline")
	draw_set_valign(global.__draw_state.valign)
}
/// @desc

var arr = global.evoui_canvases
var l = array_length(arr)
var i = 0
repeat(l) {
	var canvas = global.evoui_canvases[i]
	canvas.render()
	i++
}

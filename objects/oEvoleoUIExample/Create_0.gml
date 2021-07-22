/// @desc

var div_wrapper = new StyleSheet({
	width: room_width,
	height: room_height,
	display: "block",
})

var div_style = new StyleSheet({
	color: c_white,
	bg_color: c_red,
	bg_alpha: 1,
})

var spr_style = new StyleSheet({
	width: 70,
	height: 70,
	//x: 200,
	//y: 200,
})

var spr_wrapper = new StyleSheet({
	width: 200,
	height: 200,
})


//canvas = new UICanvas([
//	//[Div, {style: div_wrapper}, [
//		[Div, {style: div_style}, ["text"]],
//		[Div, {style: spr_wrapper}, [
//			[Sprite, {style: spr_style, spr: sThing, img: 0}, []]
//		]],
//		[LevelRow, {level_name: "Level 1", author: "Evoleo", width: 400, height: 150}, []],
//		[LevelRow, {level_name: "Level 2", author: "Evoleo", width: 400, height: 150}, []],
//		[LevelRow, {level_name: "Level 3", author: "Evoleo", width: 400, height: 150}, []]
//	//]]
//	////[LevelRow, {level_name: "Level 1", author: "Evoleo", width: 400, height: 150}, []]
//])

canvas = loadUICanvas("Canvases/test_canvas.xml")
show_message(canvas)
//show_message(array_length(canvas.root.children[0].children))
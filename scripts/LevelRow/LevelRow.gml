function LevelRow(props = {}, children = []) : UIClickable(props, children) constructor {
	setState({ img: 0 })
	trace("haha img is 0 again")
	
	mount = function() {
		style = new StyleSheet({
			width: 300,
			height: 100,
			x: 50,
			border_width: 4,
			border_color: c_white,
		})
	}
	
	draw = function() {
		draw_set_font(fNormal)
		draw_text(x, y - 20, string(state))
	}
	
	
	playButton = function() {
		if (state.img == 0)
			setState({img: 1})
		else
			setState({img: 0})
		show_debug_message(state)
		rerender()
	}
	
	static render = function() {
		trace("I'm being rendered with img=%", state.img)
		return [
			[Div, {style: {
				position: "relative",
				display: "inline",
				width: 300,
				height: 100
			}}, [
			  [Div, {style: { display: "block", width: 200, height: 100 }}, [
				[Text, {style: {font: fH4, color: c_white}, width: 200, height: 60}, [props.level_name]],
				[Text, {style: {font: fNormal, color: c_white}, width: 200, height: 40}, ["by: " + string(props.author)]]
			  ]],
			  [Button, {
					onClick: playButton,
					onHover: function() {
						//trace("hover button lol")
					},
					draw: function() {
						draw_text(x, y-10, string(self.state))
					},
					style: {
						width: 100,
						height: 100,
						padding: 10,
						border_width: 4,
						border_color: c_white
					}
				}, [
			    [Sprite, {spr: sIcon, img: state.img}, []]
			  ]]
			]]
		]
	}
}
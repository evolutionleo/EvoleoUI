// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function EvoleoUITests() {
	runner = new TestRunner()
	suite = new TestSuite()
	
	runner.addTestSuite(suite)
	
	suite.addTestCase(new TestCase(function() {
		var style = new StyleSheet({})
		assertTrue(isStyleSheet(style))
	}, "test isStyleSheet"))
	
	suite.addTestCase(new TestCase(function() {
		var element = new UIElement({}, [])
		assertTrue(isUIElement(element))
	}, "test isUIElement()"))
	
	suite.addTestCase(new TestCase(function() {
		var canvas = new UICanvas([])
		assertTrue(isUICanvas(canvas))
		
		UICanvasDelete(canvas)
	}, "test isUICanvas()"))
	
	runner.run()
}

EvoleoUITests()
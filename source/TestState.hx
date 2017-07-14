package;
import flixel.FlxState;
import flixel.FlxG;

class TestState extends FlxState 
{

	override public function create():Void
	{

		//FlxG.log.redirectTraces = true;
		var tetrosFacto = new TetrosFactory();
		
		var grid = new Grid(tetrosFacto.tetrosColor);
		
		//add(grid.drawGrid());
		
		var tailleCarre = Math.round(grid.getCellSize());
		var offsetX = Math.round(grid.getOffsetX());
		
		
		var testIdTetros = 3;

		var tetros = new Tetros(0, 0, testIdTetros, tetrosFacto.tetrosColor[testIdTetros], tetrosFacto.tetrosConfig[testIdTetros], tailleCarre, offsetX);
		
		add(tetros);
		
		super.create();		
	}
	
	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
	}
}
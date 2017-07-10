package;
import flixel.FlxState;
import flixel.FlxG;
import flixel.system.*;

/**
 * ...
 * @author 
 */
class TestState extends FlxState 
{

	override public function create():Void
	{
		super.create();
		
		var tetrosFacto = new TetrosFactory();
		trace(tetrosFacto.tetrosConfig);
		
	}
	
	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
	}
}
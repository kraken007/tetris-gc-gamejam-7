package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import Math;

/**
 * ...
 * @author op
 */
class Tetros extends FlxSprite
{
	public var id:Int = 1;
	public var rotation:Int = 0;
	public var positionX:Int = 0;
	public var positionY:Int = 0;
	public var shape:Array<Array<Int>>;

	public function new(X:Float = 0, Y:Float = 0, pId , pColorTetros:FlxColor = null, pShape:Array<Array<Int>>) 
	{		
		id = pId;
		
		//géré les couleur avec l'id
		//géré la shape avec l'id
		
		
		if(colorTetros == null){
			color = new FlxColor();
			color.setRGB(255, 0, 0, 255);
		}else {
			color = pColorTetros;
		}
		
		shape = pShape;
		
		
		
		
		super(X, Y);
	}
	
	override public function draw(): Void
	{

	}
}
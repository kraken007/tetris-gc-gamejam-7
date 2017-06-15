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
class Tetros 
{
	public var id:Int = 1;
	public var rotation:Int = 0;
	public var positionX:Int = 0;
	public var positionY:Int = 0;
	public var color:FlxColor;
	public var shape:Array<Array<Int>>;

	public function new() 
	{
		color = new FlxColor();
		color.setRGB(255, 0, 0, 255);
	}	
}
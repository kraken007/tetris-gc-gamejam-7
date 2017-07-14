package;
import flixel.util.FlxColor;

//import sys.io.File;
//import flixel.FlxG;
//import flixel.system.FlxAssets;
//import haxe.Json;

/**
 * ...
 * @author op
 */
class TetrosFactory 
{
	public var tetrosConfig:Map<Int, Array<Array<Array<Int>>>>;
	public var tetrosColor:Map<Int, FlxColor>;
	
	public function new() 
	{
		var path = AssetPaths.tetrosConfig__json;
		trace(path);
		//path = "../assets/data/tetrosConfig.json";
		//trace(path); 
		//var content = Assets.getText(path);
		//trace(content); 
		//var content = sys.io.File.getContent(path);
		//tetrosConfig = haxe.Json.parse(content);
		
		tetrosConfig = [
			1 => [
				[
					[0,0,0,0],
					[0,0,0,0],
					[1,1,1,1],
					[0,0,0,0],
				],
				[
					[0,1,0,0],
					[0,1,0,0],
					[0,1,0,0],
					[0,1,0,0],
				]
			],
			2 => [
				[
					[0,0,0,0],
					[0,1,1,0],
					[0,1,1,0],
					[0,0,0,0],
				]
			],
			3 => [
				[
					[0,0,0],
					[1,1,1],
					[0,0,1],
				],
				[
					[0,1,0],
					[0,1,0],
					[1,1,0],
				],
				[
					[1,0,0],
					[1,1,1],
					[0,0,0],
				],
				[
					[0,1,1],
					[0,1,0],
					[0,1,0],
				],
			],
			4 => [
				[
					[0,0,0],
					[1,1,1],
					[1,0,0],
				],
				[
					[1,1,0],
					[0,1,0],
					[0,1,0],
				],
				[
					[0,0,1],
					[1,1,1],
					[0,0,0],
				],
				[
					[1,0,0],
					[1,0,0],
					[1,1,0],
				]
			],
			5 => [
				[
					[0,0,0],
					[0,1,1],
					[1,1,0],
				],
				[
					[0,1,0],
					[0,1,1],
					[0,0,1],
				]
			],
			6 => [
				[
					[0,0,0],
					[1,1,1],
					[0,1,0],
				],
				[
					[0,1,0],
					[1,1,0],
					[0,1,0],
				],
				[
					[0,1,0],
					[1,1,1],
					[0,0,0],
				],
				[
					[0,1,0],
					[0,1,1],
					[0,1,0],
				]
			],
			7 => [
				[
					[0,0,0],
					[1,1,0],
					[0,1,1],
				],
				[
					[0,1,0],
					[1,1,0],
					[1,0,0],
				]
			]
		];
		
		tetrosColor = new Map();
		var color1:FlxColor = new FlxColor();
		tetrosColor.set(1, color1.setRGB(255, 0, 0, 255));
		var color2:FlxColor = new FlxColor();
		tetrosColor.set(2, color2.setRGB(0, 71, 222, 255));
		var color3:FlxColor = new FlxColor();
		tetrosColor.set(3, color3.setRGB(222, 184, 0, 255));
		var color4:FlxColor = new FlxColor();
		tetrosColor.set(4, color4.setRGB(222, 0, 222, 255));
		var color5:FlxColor = new FlxColor();
		tetrosColor.set(5, color5.setRGB(255, 151, 0, 255));
		var color6:FlxColor = new FlxColor();
		tetrosColor.set(6, color6.setRGB(71, 184, 0, 255));
		var color7:FlxColor = new FlxColor();
		tetrosColor.set(7, color7.setRGB(0, 184 ,151, 255));
	}
	
	public function getNewBag():Array<Int>
	{
		var bag:Array<Int> = new Array();
		
		for (i in 1...8)
		{
			bag.push(i);
			bag.push(i);
		}
		return bag;
	}

}
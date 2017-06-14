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
class Grid 
{
	public var width:Int = 10;
	public var height:Int = 20;
	private var cellSize:Float = 0;
	public var cells:Array<Array<Int>>;
	private var offsetX:Float = 0;

	public function new() 
	{
		cellSize = FlxG.height / height;
		offsetX = (FlxG.width / 2) - (cellSize * width / 2);
		
		
		cells = [for (ligne in 0...height) [for (collone in 0...width) 0]];
		
		trace(cells);
	}
	
	public function drawGrid()
	{
		var test = new FlxTypedGroup();
		var currentLine:Int = 0;
		var currentCol:Int = 0;
		for (ligne in cells){
			for(colonne in ligne){
				var sprite:FlxSprite = new FlxSprite(cellSize * currentCol + offsetX, cellSize * currentLine);
				sprite.makeGraphic(Math.round(cellSize) - 1, Math.round(cellSize) - 1, FlxColor.GRAY);
				test.add(sprite);
				currentCol++;
			}
			currentLine++;
			currentCol = 0;
		}
		
		return test;
	}
	
	public function getCellSize(){
		return cellSize;
	}
	
	public function getOffsetX(){
		return offsetX;
	}
	
}
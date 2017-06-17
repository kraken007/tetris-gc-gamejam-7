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
	private var colorTetros:Map<Int, FlxColor>;
	public var displayGrid:FlxTypedGroup<FlxSprite>;

	public function new(ptetrosColor:Map<Int, FlxColor>) 
	{
		colorTetros = ptetrosColor;
		cellSize = FlxG.height / height;
		offsetX = (FlxG.width / 2) - (cellSize * width / 2);
		
		cells = [for (ligne in 0...height) [for (collone in 0...width) 0]];
		
		displayGrid = new FlxTypedGroup();
	}
	
	public function drawGrid()
	{
		//FlxG.watch.addQuick('displayGridElemLive', displayGrid.countLiving());
		if(displayGrid.countLiving() > 0 ) {
			displayGrid.destroy();
			displayGrid = new FlxTypedGroup();
		}
		
		var currentLine:Int = 0;
		var currentCol:Int = 0;
		var color:FlxColor = new FlxColor();
		
		for (ligne in cells){
			for(colonne in ligne){
				var sprite:FlxSprite = new FlxSprite(cellSize * currentCol + offsetX, cellSize * currentLine);
				var id:Int = cells[currentLine][currentCol];
				if(id != 0){
					color = colorTetros[id];
				}else{
					color = new FlxColor();
					color.setRGB(128, 128, 128, 255);
				}
				sprite.makeGraphic(Math.round(cellSize) - 1, Math.round(cellSize) - 1, color);
				displayGrid.add(sprite);
				currentCol++;
			}
			currentLine++;
			currentCol = 0;
		}
		
		return displayGrid;
	}
	
	public function getCellSize(){
		return cellSize;
	}
	
	public function getOffsetX(){
		return offsetX;
	}
	
}
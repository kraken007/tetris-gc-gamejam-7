package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	private var tailleCarre:Int = 8;
	private var offsetX:Int = 0;
	
	private var currentTetros:Int;
	private var currentRotation:Int;
	
	private var tetros:Map<Int, Array<Array<Array<Int>>>>;
	private var shape:FlxTypedGroup<FlxSprite>;
		
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		
		tetros = [
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
					[0,1,1],
					[1,1,0],
				],
				[
					[0,1,0],
					[0,1,1],
					[0,0,1],
				]
			]
		];
		
		var grid:Grid = new Grid();
		
		add(grid.drawGrid());
		
		
		tailleCarre = Math.round(grid.getCellSize());
		offsetX = Math.round(grid.getOffsetX());
		
		currentTetros = 3;
		currentRotation = 1;
		drawShape(currentTetros, currentRotation);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		
		if (FlxG.keys.anyJustPressed([SPACE])){
			
			if((tetros[currentTetros].length -1) == currentRotation){
				currentRotation = 0;
			}else{
				currentRotation += 1;
			}
			drawShape(currentTetros, currentRotation);
		}
		
		if (FlxG.keys.anyJustPressed([R])){
			
			if(currentTetros == 4){
				currentTetros = 1;
			}else{
				currentTetros += 1;
			}
			currentRotation = 0;
			drawShape(currentTetros, currentRotation);
		}
		
		super.update(elapsed);
	}
	
	private function drawShape(pCurrentTetros, pCurrentRotation):Void
	{
		if(shape != null){
			shape.kill();
		}
		shape = new FlxTypedGroup();
		
		var sourceForm = tetros[pCurrentTetros][pCurrentRotation];
		var currentLine:Int = 0;
		var currentColumn:Int = 0;
		for (line in sourceForm) {
			for(column in line){
				if(column == 1){
					var sprite:FlxSprite = new FlxSprite(tailleCarre * currentColumn + offsetX, tailleCarre * currentLine);
					sprite.makeGraphic(tailleCarre -1, tailleCarre - 1);
					shape.add(sprite);
				}
				currentColumn++;
			}
			currentLine++;
			currentColumn = 0;
		}

		add(shape);
	}
}
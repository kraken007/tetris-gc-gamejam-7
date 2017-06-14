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
	private var dropSpeed:Int = 1;
	private var timeDrop:Float = 0;
	
	private var currentTetros:Tetros;
	private var grid:Grid;
	
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
		
		grid = new Grid();
		
		add(grid.drawGrid());
		
		
		tailleCarre = Math.round(grid.getCellSize());
		offsetX = Math.round(grid.getOffsetX());
		
		currentTetros = new Tetros();
		//centrage du tetros x
		var tetrosWidth = tetros[currentTetros.id][currentTetros.rotation][0].length;
		currentTetros.positionX = Math.floor((grid.width - tetrosWidth) / 2) + 1;
		var sourceForm = tetros[currentTetros.id][currentTetros.rotation];
		drawShape(sourceForm, currentTetros.positionX, currentTetros.positionY);
		
		
		//gestion du temps pour faire tombé le tetros
		timeDrop = dropSpeed;
		
		FlxG.watch.add(currentTetros,"rotation");
		FlxG.watch.add(currentTetros, "id");
		FlxG.watch.add(currentTetros,"positionY");
		FlxG.watch.add(currentTetros,"positionX");
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{

		if (FlxG.keys.anyJustPressed([SPACE])){
			
			if((tetros[currentTetros.id].length -1) == currentTetros.rotation){
				currentTetros.rotation = 0;
			}else{
				currentTetros.rotation += 1;
			}
			drawShape(tetros[currentTetros.id][currentTetros.rotation], currentTetros.positionX, currentTetros.positionY);
		}
		
		if (FlxG.keys.anyJustPressed([R])){
			
			if(currentTetros.id == 4){
				currentTetros.id = 1;
			}else{
				currentTetros.id += 1;
			}
			currentTetros.rotation = 0;
			drawShape(tetros[currentTetros.id][currentTetros.rotation], currentTetros.positionX, currentTetros.positionY);
		}
		
		//save old position
		var oldX:Int = currentTetros.positionX;
		var oldY:Int = currentTetros.positionY;
		var oldR:Int = currentTetros.rotation;
		
		if (FlxG.keys.anyJustPressed([RIGHT])){
			
			currentTetros.positionX += 1;
		}
		if (FlxG.keys.anyJustPressed([LEFT])){
			
			currentTetros.positionX -= 1;
		}
		
		if (FlxG.keys.anyJustPressed([UP, DOWN])){
			
			if((tetros[currentTetros.id].length -1) == currentTetros.rotation){
				currentTetros.rotation = 0;
			}else{
				currentTetros.rotation += 1;
			}
			drawShape(tetros[currentTetros.id][currentTetros.rotation], currentTetros.positionX, currentTetros.positionY);
		}
		
		timeDrop -= elapsed;
		
		if (timeDrop <= 0){
			
			currentTetros.positionY += 1;
			
			timeDrop = dropSpeed;
			
			drawShape(tetros[currentTetros.id][currentTetros.rotation],currentTetros.positionX, currentTetros.positionY);
			
		}
		
		if (collide()) {
			
			currentTetros.positionX = oldX;
			currentTetros.positionY = oldY;
			currentTetros.rotation = oldR;
			
			drawShape(tetros[currentTetros.id][currentTetros.rotation], currentTetros.positionX, currentTetros.positionY);
		}
		
		
		super.update(elapsed);
	}
	
	private function drawShape(pSourceForm:Array<Array<Int>>, pX, pY):Void
	{
		if(shape != null){
			shape.kill();
		}
		shape = new FlxTypedGroup();
		
		
		var currentLine:Int = 0;
		var currentColumn:Int = 0;
		for (line in pSourceForm) {
			for(column in line){
				if(column == 1){
					var sprite:FlxSprite = new FlxSprite(tailleCarre * currentColumn + offsetX, tailleCarre * currentLine);
					sprite.makeGraphic(tailleCarre -1, tailleCarre - 1);
					//positionné le sprite dans la bonne colonne.
					sprite.x = sprite.x + (pX - 1) * tailleCarre;
					sprite.y = sprite.y + (pY - 1) * tailleCarre;
					shape.add(sprite);
				}
				currentColumn++;
			}
			currentLine++;
			currentColumn = 0;
		}

		add(shape);
	}
	
	private function collide():Bool
	{
		var tmpShape:Array<Array<Int>>;
		tmpShape = tetros[currentTetros.id][currentTetros.rotation];
		var collideStatus:Bool = false;
		for (l in 0...tmpShape.length) 
		{
			for (c in 0...tmpShape[l].length) 
			{
				var cGrid:Int = c -1 + currentTetros.positionX;
				var lGrid:Int = l -1 + currentTetros.positionY;
				if(tmpShape[l][c] == 1) {
					if(cGrid <= 0 || cGrid > grid.width - 1) {
						collideStatus = true;
						break;
					}
					if(lGrid > grid.height) {
						collideStatus = true;
						break;
					}
					if(grid.cells[lGrid][cGrid] == 1) {
						collideStatus = true;
						break;
					}
				}
			}
		}
		return collideStatus;
	}
}
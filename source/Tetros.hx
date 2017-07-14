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
	public var id:Int;
	public var rotation:Int;
	public var positionX:Int;
	public var positionY:Int;
	public var shape:FlxTypedGroup<FlxSprite>;
	public var configForm:Array<Array<Int>>;
	public var config:Array<Array<Array<Int>>>;
	public var tailleCarre:Int;
	public var offsetX:Int;

	public function new(
		X:Float = 0, 
		Y:Float = 0,
		pId:Int = 1 , 
		pColorTetros:FlxColor = null, 
		pConfig:Array<Array<Array<Int>>>, 
		pTailleCarre:Int, 
		pOffsetX:Int
	) {
		//définir c'est 2 param dans le constructeur
		tailleCarre = pTailleCarre;
		offsetX = pOffsetX;
		
		//ok
		id = pId;
		rotation = 0;
		positionX = 0;
		positionY = 0;
		
		if(pColorTetros == null){
			color = new FlxColor();
			color.setRGB(255, 0, 0, 255);
		}else {
			color = pColorTetros;
		}
		//config du tetros avec toute les rotations
		config = pConfig;
		//config de la forme  de base avec la rotation par défaut
		configForm = config[rotation];
		
		//init Shape
		initShape();
		
		
		super(X, Y);
	}
	
	override public function draw(): Void
	{
		shape.draw();

	}
	public function initShape(): Void
	{
		if(shape != null){
			shape.kill();
		}
		shape = new FlxTypedGroup();
		var currentLine:Int = 0;
		var currentColumn:Int = 0;
		for (line in configForm) {
			for(column in line){
				if(column == 1){
					var sprite:FlxSprite = new FlxSprite(tailleCarre * currentColumn + offsetX, tailleCarre * currentLine);
					sprite.makeGraphic(tailleCarre -1, tailleCarre - 1, color);
					//positionné le sprite dans la bonne colonne.
					sprite.x = sprite.x + (positionX) * tailleCarre;
					sprite.y = sprite.y + (positionY) * tailleCarre;
					shape.add(sprite);
				}
				currentColumn++;
			}
			currentLine++;
			currentColumn = 0;
		}
	}
	
	public function movePlusX():Void
	{
		//evol calcul de la position en fonction de pX
		positionX += 1;
		
		initShape();
	}
	public function moveMoinsX():Void
	{
		//evol calcul de la position en fonction de pX
		positionX -= 1;
		
		initShape();
	}
	public function movePlusY():Void
	{
		//evol calcul de la position en fonction de pY
		positionY += 1;
		
		initShape();
	}
	public function moveMoinsY():Void
	{
		//evol calcul de la position en fonction de pY
		positionY -= 1;
		
		initShape();
	}
}
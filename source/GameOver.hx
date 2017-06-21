package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxAssets;

/**
 * ...
 * @author kraken007
 */
class GameOver extends FlxState 
{

	override public function create():Void
	{
		super.create();
		if (FlxG.sound.music != null) 
		{
			FlxG.sound.destroy(true);
		}
		#if flash
		FlxG.sound.play(AssetPaths.Forward_Brass_game_over__mp3, 0.5, true);
		#else
		FlxG.sound.play(AssetPaths.Forward_Brass_game_over__ogg, 0.5, true);
		#end
		
		//font
		#if html5
			trace("if ok");
		#else
			FlxAssets.FONT_DEFAULT = AssetPaths.blocked__ttf;
			trace("else ok");
		#end
		var gameOverTxt:String = "GAME OVER :(";
		var text = new FlxText(0, 0, 0, gameOverTxt, 50, true);
		var color = new FlxColor();
		color.setRGB(255, 0, 0, 255);
		text.color = color;
		text.setPosition((FlxG.width - text.fieldWidth)/2, (FlxG.height - text.height) /2);
		add(text);
		
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER){
			FlxG.sound.destroy(true);
			FlxG.switchState(new MenuState());
		}

		super.update(elapsed);
	}
	
}
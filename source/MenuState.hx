package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.system.FlxAssets;
import openfl.Assets;
//import openfl.text;
import flixel.text.FlxText;
import flixel.util.FlxColor;
/**
 * ...
 * @author kraken007
 */
class MenuState extends FlxState 
{
	var menuMusic:FlxSound;
	var menuSin:Int = 0;
	override public function create():Void
	{
		super.create();
		FlxG.log.redirectTraces = true;
		//FlxG.mouse.visible = false;
		
		if (FlxG.sound.music != null) 
		{
			FlxG.sound.destroy(true);
		}
		FlxG.sound.play(AssetPaths.kanadaka_pluck_menu__ogg,0.5,true);
		
		//font
		#if html5
			trace("if ok");
		#else
			FlxAssets.FONT_DEFAULT = AssetPaths.blocked__ttf;
			trace("else ok");
		#end
		
		var text = new FlxText(0, 0,0, "ENTER TO START !", 50, true);
		var color = new FlxColor();
		color.setRGB(255, 0, 0, 255);
		text.color = color;
		text.setPosition((FlxG.width - text.fieldWidth) / 2, (FlxG.height - text.height) / 2);
		add(text);
	}
	
	override public function update(elapsed:Float):Void
	{		
		if (FlxG.keys.justPressed.ENTER){
			FlxG.sound.destroy(true);
			FlxG.switchState(new PlayState());
		}

		super.update(elapsed);
	}
	
}
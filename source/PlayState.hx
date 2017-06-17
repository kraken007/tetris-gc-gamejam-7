package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
//import flixel.system.debug.watch.Tracker;
import flixel.system.FlxAssets;


class PlayState extends FlxState
{
	private var tailleCarre:Int = 8;
	private var offsetX:Int = 0;
	private var dropSpeed:Float = 1;
	private var timeDrop:Float = 0;
	private var pauseFroceDrop:Bool = false;
	private var keybordLatency:Int = Math.floor(1000 / 20);
	private var gameTicks:Int = 0;
	private var nextTimeDown = 0;
	private var nextTimeLeft = 0;
	private var nextTimeRight = 0;
	private var score:Int = 0;
	private var scoreTxt:FlxText;
	private var level:Int = 0;
	private var levelTxt:FlxText;
	private var lines:Int = 0;
	private var linesTxt:FlxText;
	
	private var levelUp:FlxSound;
	private var removeLineSon:FlxSound;
	
	private var currentTetros:Tetros;
	private var grid:Grid;
	private var bag:Array<Int>;
	
	private var tetros:Map<Int, Array<Array<Array<Int>>>>;
	private var tetrosColor:Map<Int, FlxColor>;
	
	private var shape:FlxTypedGroup<FlxSprite>;
	
	private var random:FlxRandom;
		
	override public function create():Void
	{
		
		random = new FlxRandom(Math.floor(Math.random() * 100000));
		
		if (FlxG.sound.music != null) 
		{
			FlxG.sound.destroy(true);
		}
		FlxG.sound.play(AssetPaths.walkingpiano_play__ogg,0.5,true);
		levelUp = new FlxSound();
		levelUp.loadEmbedded(AssetPaths.SFX_Powerup_01__ogg, false, false);
		levelUp.volume = 1;
		
		removeLineSon = new FlxSound();
		removeLineSon.loadEmbedded(AssetPaths.SFX_Powerup_03__ogg, false, false);
		removeLineSon.volume = 1;
		
		//FlxG.mouse.visible = false;
		//FlxG.debugger.visible = true;
		//FlxG.log.redirectTraces = true;
		
		//affichage du score, level et lines
		level = 1;
		lines = 0;
		score = 0;
		FlxAssets.FONT_DEFAULT = AssetPaths.blocked__ttf;
		var texteY = 100;
		var texteX = 10;
		
		var h = 30;
		var tmpColor = new FlxColor();
		
		var scoreFixeText = new FlxText(texteX, texteY, 0, "SCORE", 30, true);
		scoreFixeText.color = tmpColor.setRGB(255, 0, 0, 255);
		add(scoreFixeText);
		texteY += h;
		scoreTxt = new FlxText(texteX, texteY, 0, '$score', 30, true);
		scoreTxt.color = tmpColor;
		add(scoreTxt);
		texteY += h;
		texteY += h;
		var linesFixeTxt = new FlxText(texteX, texteY, 0, "LINES", 30, true);
		linesFixeTxt.color = tmpColor.setRGB(255, 0, 0, 255);
		add(linesFixeTxt);
		texteY += h;
		linesTxt = new FlxText(texteX, texteY, 0, '$lines', 30, true);
		linesTxt.color = tmpColor;
		add(linesTxt);
		texteY += h;
		texteY += h;
		var levelFixeText = new FlxText(texteX, texteY, 0, "LEVEL", 30, true);
		levelFixeText.color = tmpColor.setRGB(255, 0, 0, 255);
		add(levelFixeText);
		texteY += h;
		levelTxt = new FlxText(texteX, texteY, 0, '$level', 30, true);
		levelTxt.color = tmpColor;
		add(levelTxt);
		
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
		
		grid = new Grid(tetrosColor);
		
		add(grid.drawGrid());
		
		tailleCarre = Math.round(grid.getCellSize());
		offsetX = Math.round(grid.getOffsetX());
		
		//on remplis le sac d'id de tetrominos
		getNewBag();
		
		//départ on fait spanw un tetrominos
		spanwTetros();		
		
		//gestion du temps pour faire tombé le tetros
		timeDrop = dropSpeed;
		
		//FlxG.watch.add(currentTetros,"rotation");
		//FlxG.watch.add(currentTetros, "id");
		//FlxG.watch.add(currentTetros,"positionY");
		//FlxG.watch.add(currentTetros, "positionX");
		//FlxG.watch.addQuick('stop', stop);
		//FlxG.watch.addQuick('cells', grid.cells);
		//FlxG.watch.addQuick('pauseFroceDrop', pauseFroceDrop);
		
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{		
		//FlxG.watch.addQuick('bag', bag);
		//FlxG.watch.addQuick('bagT', bag.length);
		gameTicks = FlxG.game.ticks;
		
		//save old position
		var oldX:Int = currentTetros.positionX;
		var oldY:Int = currentTetros.positionY;
		var oldR:Int = currentTetros.rotation;
		
		//déplacement tetros
		if (FlxG.keys.pressed.RIGHT && gameTicks > nextTimeRight){
			nextTimeRight = gameTicks + keybordLatency * 2;
			currentTetros.positionX += 1;
		}
		if (FlxG.keys.pressed.LEFT && gameTicks > nextTimeLeft){
			nextTimeLeft = gameTicks + keybordLatency * 2;
			currentTetros.positionX -= 1;
		}
		if (collide()) {
			
			currentTetros.positionX = oldX;
			currentTetros.positionY = oldY;
			currentTetros.rotation = oldR;
			
			drawShape(tetros[currentTetros.id][currentTetros.rotation], currentTetros.positionX, currentTetros.positionY);
		}else{
			drawShape(tetros[currentTetros.id][currentTetros.rotation], currentTetros.positionX, currentTetros.positionY);
		}
		
		//rotation tetros
		if (FlxG.keys.anyJustPressed([UP])){
			
			if((tetros[currentTetros.id].length -1) == currentTetros.rotation){
				currentTetros.rotation = 0;
			}else{
				currentTetros.rotation += 1;
			}
			drawShape(tetros[currentTetros.id][currentTetros.rotation], currentTetros.positionX, currentTetros.positionY);
		}
		
		if (collide()) {
			
			currentTetros.positionX = oldX;
			currentTetros.positionY = oldY;
			currentTetros.rotation = oldR;
			
			drawShape(tetros[currentTetros.id][currentTetros.rotation], currentTetros.positionX, currentTetros.positionY);
		}
		
		//eleve la pause du force down
		if(!FlxG.keys.pressed.DOWN) {
			pauseFroceDrop = false;
		}
		
		
		
		//acceleration du tetros
		if (FlxG.keys.pressed.DOWN && pauseFroceDrop == false && gameTicks > nextTimeDown){
			nextTimeDown = gameTicks + keybordLatency;
			currentTetros.positionY += 1;
			timeDrop = dropSpeed;
			if(collide()){
				currentTetros.positionY -=  1;
				transfer();
				testLigneComplete();
				spanwTetros();
			}else {
				drawShape(tetros[currentTetros.id][currentTetros.rotation],currentTetros.positionX, currentTetros.positionY);
			}
		}
		
		timeDrop -= elapsed;
		
		if (timeDrop <= 0){
			
			currentTetros.positionY += 1;
			timeDrop = dropSpeed;
			
			if(collide()){
				currentTetros.positionY -=  1;
				transfer();
				testLigneComplete();
				spanwTetros();
			}else {
				drawShape(tetros[currentTetros.id][currentTetros.rotation],currentTetros.positionX, currentTetros.positionY);
			}
		}
		
		testLigneComplete();

		super.update(elapsed);
	}
	
	private function drawShape(pSourceForm:Array<Array<Int>>, pX, pY):Void
	{
		if(shape != null){
			shape.kill();
		}
		shape = new FlxTypedGroup();
		currentTetros.shape = pSourceForm;
		var currentLine:Int = 0;
		var currentColumn:Int = 0;
		for (line in pSourceForm) {
			for(column in line){
				if(column == 1){
					var sprite:FlxSprite = new FlxSprite(tailleCarre * currentColumn + offsetX, tailleCarre * currentLine);
					sprite.makeGraphic(tailleCarre -1, tailleCarre - 1, currentTetros.color);
					//positionné le sprite dans la bonne colonne.
					sprite.x = sprite.x + (pX) * tailleCarre;
					sprite.y = sprite.y + (pY) * tailleCarre;
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
		
		for (l in 0...tmpShape.length) 
		{
			for (c in 0...tmpShape[l].length) 
			{
				var cGrid:Int = c  + currentTetros.positionX;
				var lGrid:Int = l  + currentTetros.positionY;
				
				if (tmpShape[l][c] == 1) {
					if(cGrid < 0 || cGrid > grid.width - 1) {
						return true;
					}
					if(lGrid > grid.height -1) {
						return true;
					}
					if(grid.cells[lGrid][cGrid] != 0) {
						return true;
					}
				}
			}
		}
		return false;
	}
	private function transfer():Void 
	{
		var tmpShape:Array<Array<Int>>;
		tmpShape = currentTetros.shape;
		for (l in 0...tmpShape.length) 
		{
			for (c in 0...tmpShape[l].length) 
			{
				var cGrid:Int = c  + currentTetros.positionX;
				var lGrid:Int = l  + currentTetros.positionY;
				if(tmpShape[l][c] != 0) {
					grid.cells[lGrid][cGrid] = currentTetros.id;
					
				}
			}
		}
		add(grid.drawGrid());
	}
	
	private function spanwTetros():Void
	{
		currentTetros = new Tetros();
		var nBag = random.int(0, (bag.length -1));
		currentTetros.id = bag[nBag];
		bag.splice(nBag, 1);
		if(bag.length == 0){
			getNewBag();
		}
		currentTetros.color = tetrosColor[currentTetros.id];
		//centrage du tetros x
		var tetrosWidth = tetros[currentTetros.id][currentTetros.rotation][0].length;
		currentTetros.positionX = Math.floor((grid.width - tetrosWidth) / 2);
		currentTetros.shape = tetros[currentTetros.id][currentTetros.rotation];
		
		pauseFroceDrop = true;
		timeDrop = dropSpeed;
		
		drawShape(currentTetros.shape, currentTetros.positionX, currentTetros.positionY);
		
		if(collide()){
			FlxG.sound.destroy(true);
			FlxG.switchState(new GameOver());
		}
	}
	
	private function removeLineGrid(pLine):Void
	{
		var token:Bool = true;
		var ligne:Int = pLine;
		var colEnd:Int = grid.width;
		FlxG.log.add('remove line y:$pLine');
		while (token) 
		{
			for (col in 0...colEnd) 
			{
				grid.cells[ligne][col] = grid.cells[ligne-1][col];
			}
			ligne--;
			if(ligne == 1){
				token = false;
			}
		}
		add(grid.drawGrid());
	}
	
	private function testLigneComplete():Void
	{
		var ligneComplete:Bool;
		var nbLines:Int = 0;
		for (l in 0...grid.height) 
		{
			ligneComplete = true;
			for (c in 0...grid.width) 
			{
				if (grid.cells[l][c] == 0) 
				{
					ligneComplete = false;
					break;
				}
			}
			if (ligneComplete == true) 
			{
				removeLineGrid(l);
				nbLines++;
			}
		}
		lines += nbLines;
		linesTxt.text = '$lines';
		if(nbLines > 0) {
			//play son removeLine
			removeLineSon.play();
		}
		
		//calcul score
		if(nbLines == 1){
			score += (100 * level);
		}else if(nbLines == 2){
			score += (300 * level);
		}else if(nbLines == 3){
			score += (400 * level);
		}else if(nbLines == 4){
			score += (800 * level);
		}
		scoreTxt.text = '$score';
		manageLevel();
	}
	
	private function manageLevel():Void
	{
		var newLevel = Math.floor(lines / 10) + 1;
		if(newLevel <= 20 && newLevel > level){
			level = newLevel;
			dropSpeed -= 0.08;
			//joue son levelup
			levelUp.play();
			levelTxt.text = '$level';
		}
	}
	
	private function getNewBag():Void
	{
		bag = new Array();
		
		for (i in 1...8)
		{
			bag.push(i);
			bag.push(i);
		}
	}
}
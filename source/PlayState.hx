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
	private var nextTetros:Tetros;
	private var grid:Grid;
	private var bag:Array<Int>;
	
	private var tetros:Map<Int, Array<Array<Array<Int>>>>;	
	private var tetrosFactory:TetrosFactory;
	
	private var shape:FlxTypedGroup<FlxSprite>;
	private var nextShape:FlxTypedGroup<FlxSprite>;
	
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
		FlxG.log.redirectTraces = true;
		
		//affichage du score, level et lines
		level = 1;
		lines = 0;
		score = 0;
		//font
		#if html5
			trace("if ok");
		#else
			FlxAssets.FONT_DEFAULT = AssetPaths.blocked__ttf;
			trace("else ok");
		#end
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
		
		//tetrominos
		tetrosFactory = new TetrosFactory();
		tetros = tetrosFactory.tetrosConfig;
		
		grid = new Grid(tetrosFactory.tetrosColor);
		
		add(grid.drawGrid());
		
		tailleCarre = Math.round(grid.getCellSize());
		offsetX = Math.round(grid.getOffsetX());
		
		//on remplis le sac d'id de tetrominos
		bag = tetrosFactory.getNewBag();

		//on init les 2 tetros current et next
		currentTetros = new Tetros();
		nextTetros = new Tetros();
		//on tire aux hasard un tetros du sac
		var nBag = random.int(0, (bag.length -1));
		// on n'affect l'id au next tetros car il deviendra le current dans le passage dans la methode spawnTetros
		nextTetros.id = bag[nBag];
		//on supprime le tetros du sac
		bag.splice(nBag, 1);
		
		//on dessine le carré pour la affiché le nextTetros
		drawCarre();

		//départ on fait spawn un tetrominos
		spawnTetros();		
		
		//gestion du temps pour faire tombé le tetros
		timeDrop = dropSpeed;
			
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
				spawnTetros();
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
				spawnTetros();
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
	
	private function drawNextShape(pSourceForm:Array<Array<Int>>):Void
	{
		if(nextShape != null){
			nextShape.kill();
		}
		nextShape = new FlxTypedGroup();
		nextTetros.shape = pSourceForm;
		var currentLine:Int = 0;
		var currentColumn:Int = 0;
		//todo centré dans le carré.
		//todo prendre en compte le nb de carré de la shape pour centré dans le carré.
		//										    	offsetGrid + epaisseur + padding	
		var offset = offsetX + grid.getCellSize() * grid.width + 20 + 3 + 5;
		for (line in pSourceForm) {
			for(column in line){
				if(column == 1){
					var sprite:FlxSprite = new FlxSprite(tailleCarre * currentColumn + offset, tailleCarre * currentLine);
					sprite.makeGraphic(tailleCarre -1, tailleCarre - 1, nextTetros.color);
					//positionné le sprite dans la bonne colonne.
					//sprite.x = sprite.x + (pX) * tailleCarre;
					//sprite.y = sprite.y + (pY) * tailleCarre;
					nextShape.add(sprite);
				}
				currentColumn++;
			}
			currentLine++;
			currentColumn = 0;
		}

		add(nextShape);
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
	
	private function spawnTetros():Void
	{
		//next devient current
		currentTetros = nextTetros;
		
		//on tire un nouveau tetros
		
		var nBag = random.int(0, (bag.length -1));
		var idTetros = bag[nBag];
		bag.splice(nBag, 1);
		
		nextTetros = new Tetros(0,0, idTetros, tetrosFactory.tetrosColor[idTetros], tetros[idTetros][nextTetros.rotation]);
		
		//si bag vide on re-remplis
		if(bag.length == 0){
			bag = tetrosFactory.getNewBag();
		}
		currentTetros.color = tetrosFactory.tetrosColor[currentTetros.id];
		//centrage du tetros x
		var tetrosWidth = tetros[currentTetros.id][currentTetros.rotation][0].length;
		currentTetros.positionX = Math.floor((grid.width - tetrosWidth) / 2);
		currentTetros.shape = tetros[currentTetros.id][currentTetros.rotation];
		
		pauseFroceDrop = true;
		timeDrop = dropSpeed;
		
		drawShape(currentTetros.shape, currentTetros.positionX, currentTetros.positionY);
		drawNextShape(nextTetros.shape);
		
		if(collide()){
			FlxG.sound.destroy(true);
			FlxG.switchState(new GameOver());
		}
		trace('end spawn');
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

	private function drawCarre():Void
	{
		var longeur = Math.floor(grid.getCellSize() * 4) + 10;
		var epaisseur = 3;
		var offset = offsetX + grid.getCellSize() * grid.width + 20;
		//déssiné 4 ligne de width 4*cellezise et h idem pour faire un carré!
		var carre = new FlxTypedGroup();
		
		var lineH = new FlxSprite(0 + offset, 0);
		lineH.makeGraphic(longeur, epaisseur);
		carre.add(lineH);
		var lineB = new FlxSprite(0 + offset, longeur);
		lineB.makeGraphic(longeur, epaisseur);
		carre.add(lineB);
		var lineG = new FlxSprite(0 + offset, 0);
		lineG.makeGraphic(epaisseur, longeur);
		carre.add(lineG);
		var lineD = new FlxSprite(longeur + offset, 0);
		lineD.makeGraphic(epaisseur, longeur + epaisseur);
		carre.add(lineD);
		
		add(carre);
	}
}
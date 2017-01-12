package
{//http://blog.csdn.net/touchsnow/article/details/19071961
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import org.bytearray.gif.player.GIFPlayer;
	import org.bytearray.gif.decoder.GIFDecoder;
	import org.bytearray.gif.events.GIFPlayerEvent;
	import org.bytearray.gif.events.FileTypeEvent;
	import org.bytearray.gif.events.FrameEvent;
	import org.bytearray.gif.events.TimeoutEvent;
	
	import flash.events.KeyboardEvent;
	
	/**
	 * 2014/2/16 9:41
	 * @author W.J
	 */
	public class Main extends Sprite
	{
		//使用这个库 必须修改里面gif来得到自己的 因为ps出来的和里面自带的gif配置不一样 会产生重影 还有原因就是时间的原因
		//所以使用的时候最好能够用里面的图自己来改造
		[Embed(source="bird.gif",mimeType="application/octet-stream")] //34*26
		private var gifStream:Class;
		public var gifBytes:ByteArray = new gifStream();
		
		[Embed(source="bg.jpg")]
		private var bg:Class;
		public var backgroundImage:Bitmap = new bg() as Bitmap;
		
		[Embed(source="PipeTop.png")] //30*13
		public static var PipeTop:Class;
		public static var pipeTop:Bitmap = new PipeTop() as Bitmap;
		
		[Embed(source="PipeBody.png")] //30*1
		public static var PipeBody:Class;
		public static var pipeBody:Bitmap = new PipeBody() as Bitmap;
		
		[Embed(source="startButton.png")]
		private var StartButtonPic:Class;
		public var startButtonPic:Bitmap = new StartButtonPic() as Bitmap;
		
		[Embed(source="GameOverPic.png")]
		private var GameOverPic:Class;
		public var gameOverPic:Bitmap = new GameOverPic() as Bitmap;
		public var gameOverBox:Sprite = new Sprite();
		
		[Embed(source="PressStart2P.ttf",fontName="Press_Start_2P",embedAsCFF="false")]
		private var PressStart2P:Class;
		
		public var startButton:MovieClip = new MovieClip();
		public var gameMode:int = -1;
		public var myGIFPlayer:GIFPlayer = new GIFPlayer();
		
		public var GRAVITY:Number = 1.4;
		public var fallTime:Number = 0;
		public var velocity0:Number = 0; //初速度
		
		public var pipeSprite:Sprite = new Sprite();
		
		public var scoreText:TextField = new TextField();
		public var score:int = 0;
		public static var highestScore:int = 0;
		public var highestScoreText:TextField = new TextField();
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			myGIFPlayer.loadBytes(gifBytes);
			
			addChild(backgroundImage);
			
			startButton.addChild(startButtonPic);
			startButton.x = 130;
			startButton.y = 200;
			startButton.buttonMode = true;
			
			addChild(startButton);
			addChild(myGIFPlayer);
			addChild(pipeSprite);
			pipeSprite.visible = false;
			pipeSprite.x = 100;
			initCharacter();
			
			stage.addEventListener(Event.ENTER_FRAME, frameHd);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			scoreText.embedFonts = true;
			scoreText.autoSize = TextFieldAutoSize.LEFT;
			scoreText.defaultTextFormat = new TextFormat("Press_Start_2P", 15, 0xb0fcfb);
			scoreText.text = score.toString();
			scoreText.selectable = false;
			
			highestScoreText.embedFonts = true;
			highestScoreText.autoSize = TextFieldAutoSize.LEFT;
			highestScoreText.defaultTextFormat = new TextFormat("Press_Start_2P", 25, 0xb0fcfb);
			highestScoreText.text = "BEST:"+highestScore.toString();
			highestScoreText.selectable = false;
			
			addChild(scoreText);
			addChild(highestScoreText);
			
			scoreText.visible = false;
			highestScoreText.visible = false;
			highestScoreText.x = 160 - highestScoreText.width/2;
			highestScoreText.y = 330;
			gameOverBox.addChild(gameOverPic);
			addChild(gameOverBox);
			gameOverBox.x = stage.stageWidth / 2 - gameOverBox.width / 2;
			gameOverBox.y = stage.stageHeight / 2 - gameOverBox.height / 2 + 25;
			gameOverBox.visible = false;
			
			startButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					myGIFPlayer.play();
					score = 0;
					scoreText.text = "SCORE:"+score.toString();
					scoreText.x = 100;
					scoreText.y = 25;
					scoreText.visible = true;
					highestScoreText.visible = false;
					gameOverBox.visible = false;
					initCharacter();
					startButton.visible = false;
					gameMode = 1;
					pipeSprite.visible = true;
				
				});
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
				{
					if(gameMode){
					velocity0 = -12;
					fallTime = 0;}
				})
		}
		
		//生成管道
		public function generatePipe():void
		{
			var pipe1:Pipe = new Pipe(0);
			pipeSprite.addChild(pipe1);
			pipe1.y = 400 - pipe1.height;
			pipe1.x = -pipeSprite.x + 360;
			var pipe2:Pipe = new Pipe(pipe1.height);
			pipe2.y = pipe2.height;
			pipe2.x = -pipeSprite.x + 360;
			pipe2.rotation = 180;
			pipeSprite.addChild(pipe2);
			var flag:Flag = new Flag();
			flag.x = -pipeSprite.x + 360;
			flag.y = pipe2.height;
			pipeSprite.addChild(flag);
		}
		
		private function initCharacter():void
		{
			myGIFPlayer.x = 145;
			myGIFPlayer.y = 240;
			velocity0 = -10;
			fallTime = 0;
		}
		
		private var gametime:int = 0;
		
		private function frameHd(e:Event):void
		{
			if (gameMode == 1)
			{
				fallTime++;
				gametime++;
				myGIFPlayer.y += velocity0 + GRAVITY * fallTime;
				//碰撞判断
				
				if (myGIFPlayer.y > 400 || myGIFPlayer.y < 0)
				{
					gameOver();
				}
				//管道碰撞
				for (var i:int = 0; i < pipeSprite.numChildren; i++)
				{
					
					if (myGIFPlayer.hitTestObject(pipeSprite.getChildAt(i)))
					{
						if (!(pipeSprite.getChildAt(i) is Flag))
						{
							gameOver();
							return;
						}
						else
						{
							score++;
							pipeSprite.removeChild(pipeSprite.getChildAt(i));
							scoreText.text = "SCORE:" + score.toString();
							scoreText.x = 160 - scoreText.width/2;
						}
					}
				}
				//trace(pipeSprite.numChildren)
				//移除飞出屏幕的
				for (var j:int = pipeSprite.numChildren - 1; j >= 0; j--)
				{
					
					if (pipeSprite.getChildAt(j).x < -pipeSprite.x - 20)
					{
						pipeSprite.removeChild(pipeSprite.getChildAt(j));
					}
				}
				pipeSprite.x -= 3; //移动管道
				if (gametime >= 60)
				{
					generatePipe();
					gametime = 0;
				}
			}else if(gameMode != -1){ if(myGIFPlayer.y<380)myGIFPlayer.y+=3; }
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 65: //keyLeft
				case 37: 
					break;
				case 68: //keyRight
				case 39: 
					break;
				case 87: //keyup
				case 38: 
				case 32: 
					velocity0 = -12;
					fallTime = 0;
					break;
				case 83: //keyDown
				case 40: 
					break;
			
			}
		}
		
		public function gameOver():void
		{
			//trace("gameover")
			
			gameMode = 0;
			startButton.visible = true;
			pipeSprite.visible = false;
			pipeSprite.x = 100;
			
			for (var temp:int = pipeSprite.numChildren - 1; temp >= 0; temp--) //用 ++移除不干净
			{
				pipeSprite.removeChild(pipeSprite.getChildAt(0));
			}
			myGIFPlayer.stop(); 
			gameOverBox.visible = true;
			scoreText.visible = true;
			highestScoreText.visible = true;
			//trace("score"+score)
			if (score > highestScore)
			{
				highestScore = score;
				//trace(score);
				//trace("ok");
				highestScoreText.x = 160 - highestScoreText.width/2;
				highestScoreText.text = "BEST:"+highestScore.toString();
			}
			addChild(startButton);//前置
			addChild(scoreText);
			scoreText.x = 160 - scoreText.width/2;
			scoreText.y = 300;
			//trace("移除完毕还有"+pipeSprite.numChildren);
		}
	}

}
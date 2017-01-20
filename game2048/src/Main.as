package
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * 2014/5/1 15:34
	 * @author W.J
	 */
	public class Main extends Sprite
	{
		
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
			// entry point
			
			newGame();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyUpHd);
		}
		
		public function KeyUpHd(e:KeyboardEvent)
		{
			switch (e.keyCode)
			{
				case Keyboard.LEFT: 
				case 65: 
					leftMove();
					
					upDateGraphic();
					break;
				case Keyboard.RIGHT: 
				case 68: 
					rightMove();
					//newNum();
					upDateGraphic();
					break;
				case Keyboard.UP: 
				case 87: 
					upMove();
					//newNum();
					upDateGraphic();
					break;
				case Keyboard.DOWN: 
				case 83: 
					downMove();
					//newNum();
					upDateGraphic();
					break;
			}
			
			newNum();
			upDateGraphic();
		}
		public function newNum()
		{
			//var int1:int = Math.random() * 16 % 16;
			//var randomX:int = int1 / 4;
			//var randomY:int = int1 % 4;

			var randomArr:Array = new Array();
			for (var y:int = 0; y < 4; y++)
			{
				for (var x:int = 0; x < 4; x++)
				{
					if (gameArray[y][x] == 0) randomArr.push((y*4+x));//选出数字为0的项
				}
			}
			if (randomArr.length == 0) return;
			var randomNum:int = randomArr[int(randomArr.length*Math.random())];
			gameArray[int(randomNum / 4)][randomNum % 4] = 2;
			
		}
		public function leftMove()//都是从最基本的扩展而来
		{
			var canMove:Boolean = false;
			//判断是否能移动
			for (var y:int = 0; y < 4; y++)
			{
				for (var x:int = 1; x < 4; x++)
				{
					if (if2n(gameArray[y][x] + gameArray[y][x - 1]) == 1)
						canMove = true;
				}
			}
			if (!canMove)
				return;
			//序列化 非0的全部移动最左边
			for (var y:int = 0; y < 4; y++)
			{
				var isInOrder:Boolean = false;
				while (!isInOrder)
				{
					//如果发现有一个没有排好 那就排了再重新判断
					for (var x:int = 1; x < 4; x++)
					{
						if (gameArray[y][x - 1] == 0 && gameArray[y][x] != 0)
						{
							gameArray[y][x - 1] = gameArray[y][x];
							gameArray[y][x] = 0;
							break;
						}else if(x==3)isInOrder = true;//如果到最后一个为止都满足 那就是排好了
					}
				}
			}
			//加法
			for (var y:int = 0; y < 4; y++)
			{
				for (var x:int = 1; x < 4; x++)
				{
					if (gameArray[y][x] == gameArray[y][x - 1])
					{
						gameArray[y][x - 1] += gameArray[y][x];
						gameArray[y][x] = 0;
					}
				}

			}
			//再次序列化 非0的全部移动最左边
			for (var y:int = 0; y < 4; y++)
			{
				var isInOrder:Boolean = false;
				while (!isInOrder)
				{
					//如果发现有一个没有排好 那就排了再重新判断
					for (var x:int = 1; x < 4; x++)
					{
						if (gameArray[y][x - 1] == 0 && gameArray[y][x] != 0)
						{
							gameArray[y][x - 1] = gameArray[y][x];
							gameArray[y][x] = 0;
							break;
						}else if(x==3)isInOrder = true;//如果到最后一个为止都满足 那就是排好了
					}
				}
			}
		}
		public function upMove()
		{
			var canMove:Boolean = false;
			//判断是否能移动
			for (var x:int = 0; x < 4; x++)
			{
				for (var y:int = 1; y < 4; y++)
				{
					if (if2n(gameArray[y][x] + gameArray[y - 1][x]) == 1)
						canMove = true;
				}
			}
			if (!canMove)
				return;
			
			//序列化 非0的全部移动最上边
			for (var x:int = 0; x < 4; x++)
			{
				var isInOrder:Boolean = false;
				while (!isInOrder)
				{
					//如果发现有一个没有排好 那就排了再重新判断
					for (var y:int = 1; y < 4; y++)
					{
						if (gameArray[y - 1][x] == 0 && gameArray[y][x] != 0)
						{
							gameArray[y - 1][x] = gameArray[y][x];
							gameArray[y][x] = 0;
							break;
						}else if(y==3)isInOrder = true;//如果到最后一个为止都满足 那就是排好了
					}
				}
			}
			
			//加法
			for (var x:int = 0; x < 4; x++)
			{
				for (var y:int = 1; y < 4; y++)
				{
					if (gameArray[y][x] == gameArray[y - 1][x])
					{
						gameArray[y - 1][x] += gameArray[y][x];
						gameArray[y][x] = 0;
					}
				}
			}
			//再次序列化 非0的全部移动最上边
			for (var x:int = 0; x < 4; x++)
			{
				var isInOrder:Boolean = false;
				while (!isInOrder)
				{
					//如果发现有一个没有排好 那就排了再重新判断
					for (var y:int = 1; y < 4; y++)
					{
						if (gameArray[y - 1][x] == 0 && gameArray[y][x] != 0)
						{
							gameArray[y - 1][x] = gameArray[y][x];
							gameArray[y][x] = 0;
							break;
						}else if(y==3)isInOrder = true;//如果到最后一个为止都满足 那就是排好了
					}
				}
			}
		}
		public function rightMove()
		{
			var canMove:Boolean = false;
			//判断是否能移动
			for (var y:int = 0; y < 4; y++)
			{
				for (var x:int = 0; x < 3; x++)
				{
					if (if2n(gameArray[y][x] + gameArray[y][x + 1]) == 1)
						canMove = true;
				}
			}
			if (!canMove)
				return;
			//序列化 非0的全部移动最右边
			for (var y:int = 0; y < 4; y++)
			{
				var isInOrder:Boolean = false;
				while (!isInOrder)
				{
					//如果发现有一个没有排好 那就排了再重新判断
					for (var x:int = 2; x >=0; x--)
					{
						if (gameArray[y][x + 1] == 0 && gameArray[y][x] != 0)
						{
							gameArray[y][x + 1] = gameArray[y][x];
							gameArray[y][x] = 0;
							break;
						}else if(x==0)isInOrder = true;//如果到第一个为止都满足 那就是排好了
					}
				}
			}
			
			//加法 与左边反向 防止一次加完
			for (var y:int = 0; y < 4; y++)
			{
				for (var x:int = 2; x >= 0; x--)
				{
					if (gameArray[y][x] ==gameArray[y][x + 1])
					{
						gameArray[y][x + 1] += gameArray[y][x];
						gameArray[y][x] = 0;
					}
				}
			}
			//再次序列化 非0的全部移动最右边
			for (var y:int = 0; y < 4; y++)
			{
				var isInOrder:Boolean = false;
				while (!isInOrder)
				{
					//如果发现有一个没有排好 那就排了再重新判断
					for (var x:int = 2; x >=0; x--)
					{
						if (gameArray[y][x + 1] == 0 && gameArray[y][x] != 0)
						{
							gameArray[y][x + 1] = gameArray[y][x];
							gameArray[y][x] = 0;
							break;
						}else if(x==0)isInOrder = true;//如果到第一个为止都满足 那就是排好了
					}
				}
			}
		}
		public function downMove()
		{
			var canMove:Boolean = false;
			//判断是否能移动
			for (var x:int = 0; x < 4; x++)
			{
				for (var y:int = 0; y < 3; y++)
				{
					if (if2n(gameArray[y][x] + gameArray[y + 1][x]) == 1)
						canMove = true;
				}
			}
			if (!canMove)
				return;
			//序列化 非0的全部移动最下边
			for (var x:int = 0; x < 4; x++)
			{
				var isInOrder:Boolean = false;
				while (!isInOrder)
				{
					//如果发现有一个没有排好 那就排了再重新判断
					for (var y:int = 2; y >=0; y--)
					{
						if (gameArray[y + 1][x] == 0 && gameArray[y][x] != 0)
						{
							gameArray[y + 1][x] = gameArray[y][x];
							gameArray[y][x] = 0;
							break;
						}else if(y==0)isInOrder = true;//如果到第一个为止都满足 那就是排好了
					}
				}
			}
			
			//加法 与上边反向 防止一次加完
			for (var x:int = 0; x < 4; x++)
			{
				for (var y:int = 2; y >= 0; y--)
				{
					if (gameArray[y][x] == gameArray[y + 1][x])
					{
						gameArray[y + 1][x] += gameArray[y][x];
						gameArray[y][x] = 0;
					}
				}
			}
			//再次序列化 非0的全部移动最下边
			for (var x:int = 0; x < 4; x++)
			{
				var isInOrder:Boolean = false;
				while (!isInOrder)
				{
					//如果发现有一个没有排好 那就排了再重新判断
					for (var y:int = 2; y >=0; y--)
					{
						if (gameArray[y + 1][x] == 0 && gameArray[y][x] != 0)
						{
							gameArray[y + 1][x] = gameArray[y][x];
							gameArray[y][x] = 0;
							break;
						}else if(y==0)isInOrder = true;//如果到第一个为止都满足 那就是排好了
					}
				}
			}
		}
		
		var gameArray:Array = new Array(3); //数字的矩阵
		var graphicArray:Array = new Array(3); //图形对应的矩阵
		var N:int = 1; //2的n次方的n
		
		public function newGame():void
		{
			for (var y:int = 0; y < 4; y++)
			{
				gameArray[y] = new Array(3);
				graphicArray[y] = new Array(3);
				for (var x:int = 0; x < 4; x++)
				{
					gameArray[y][x] = 0;
					
					var sprite:Sprite = new Sprite();
					sprite.x = x * 70;
					sprite.y = y * 70;
					var textField:TextField = new TextField();
					textField.scaleX = textField.scaleY = 4;
					//textField.text = x.toString() +" "+ y.toString();
					textField.text = gameArray[y][x].toString();
					sprite.addChild(textField);
					stage.addChild(sprite);
					graphicArray[y][x] = sprite;
				}
			}
			
			//第一次初始化两个为1的块
			var int1:int = Math.random() * 16 % 16;
			var int2:int = Math.random() * 16 % 16;
			while (int2 == int1)
				int2 = Math.random() * 16 % 16;
			gameArray[int(int1 / 4)][int1 % 4] = 2;
			gameArray[int(int2 / 4)][int2 % 4] = 2;
			gameArray[0][0] = 8;
			gameArray[1][0] = 4;
			gameArray[2][0] = 2;
			gameArray[3][0] = 2;	
			
			gameArray[0][0] = 2;
			gameArray[0][1] = 2;
			gameArray[0][2] = 2;
			gameArray[0][3] = 2;
			
		upDateGraphic();
		}
		
		//更新图形显示
		public function upDateGraphic():void
		{
			for (var y:int = 0; y < 4; y++)
			{
				for (var x:int = 0; x < 4; x++)
				{
					graphicArray[y][x].getChildAt(0).text = gameArray[y][x].toString();
				}
			}
		}
		
		public function if2n(x:int):int //判断x是否是2的n次方 如果是返回比它大的第一个
		{
			var flag:int = 0;
			for (var n:int = 1; n <= 11; n++)
			{
				if (x == Math.pow(2, n))
				{
					flag = 1;
					if (n > N)
						N = n;
					return flag;
				}
			}
			return flag;
		}
	}

}
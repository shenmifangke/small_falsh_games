package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 2014/2/16 11:58
	 * @author W.J
	 */
	
	public class Pipe extends Sprite
	{
		public var pipeHeight:int;
		
		public function Pipe(size:int)
		{
			var pipeTop:Bitmap = new Main.PipeTop() as Bitmap;
			var pipeBody:Bitmap = new Main.PipeBody() as Bitmap;
			pipeBody.x = -15; //一半的宽度 就是中心 旋转的时候保持在中间的位置
			pipeTop.x = -15;
			addChild(pipeBody);
			addChild(pipeTop);
			//110是中间间隔
			if (size == 0)
			{ //往下的
				pipeHeight = Math.floor(Math.random() * 250+30);
				pipeBody.height = pipeHeight;
			}
			else
			{
				pipeHeight = 400 - 120 - size;
				pipeBody.height = pipeHeight;
			}
		
		}
	
	}

}
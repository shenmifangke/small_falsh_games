package  
{
	import flash.display.Sprite;
	
	/**
	 * 2014/2/16 15:30
	 * @author W.J
	 */
	public class Flag extends Sprite 
	{
		
		public function Flag() 
		{
			this.graphics.beginFill(0xffff0000);
			this.graphics.drawRect( 15, 0, 1, 110);
			this.graphics.endFill();
		}
		
	}

}
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
			this.graphics.drawRect( 0, 0, 1, 120);
			this.graphics.endFill();
		}
		
	}

}
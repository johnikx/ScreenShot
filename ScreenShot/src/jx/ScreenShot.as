/*
 ScreenShot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package jx
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class ScreenShot
	{
		
		public static var dictionary:Dictionary;
		public static var uploader:Uploader;
		
		public function ScreenShot()
		{
			throw new IllegalOperationError("Can't be instantiated.");
		}
		
		/**
		 * Compare screen shot with component.
		 * 
		 * <p>Before use this method you have to set <code>screenLoader</code> property.</p>
		 * 
		 * @return Return true when the component looks exactly the same as is on screen shot.
		 */
		
		public static function compare(name:String, component:DisplayObject):Boolean
		{
			var screen:BitmapData = new BitmapData(component.width, component.height);
				screen.draw(component);
			
			if (uploader)
			{
				uploader.upload(name + ".png", screen);
				return true;
			}
			
			if (!dictionary) throw new IllegalOperationError("You have to set the dictionary first.");
			
			var originalScreen:BitmapData = dictionary[name];
			
			if (!originalScreen) return false;
			
			return compareBitmapData(originalScreen, screen);
		}
		
		/**
		 * Compare two bitmap data, pixel by pixel.
		 * @return Return true when bitmap data are exactly the same.
		 */
		
		public static function compareBitmapData(original:BitmapData, test:BitmapData):Boolean
		{
			var originalPixels:Vector.<uint> = original.getVector(original.rect);
			var testPixels:Vector.<uint> = test.getVector(test.rect);
			
			if (originalPixels.length == testPixels.length)
			{
				for (var i:uint = 0; i < originalPixels.length; i++)
				{
					if (originalPixels[i] != testPixels[i])
					{
						return false;
					}
				}
				
				return true;
			}
			
			return false;
		}
		
	}
}
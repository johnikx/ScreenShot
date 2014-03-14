/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.com.jx.screenshot
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	import com.jx.screenshot.LoadQueue;
	
	import org.flexunit.async.Async;
	import tests.TestCase;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class LoadQueueTest extends TestCase
	{
		
		private var loader:LoadQueue;
		
		[Before]
		public function setUp():void
		{
			loader = new LoadQueue("../data/");
		}
		
		[After]
		public function tearDown():void
		{
			loader = null;
		}
		
		[Test(expects="ArgumentError")]
		public function emptyQueueArgument():void
		{
			loader.load(null);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function loadWhileLoading():void
		{
			var queue:Vector.<String> = new <String>["a", "b"];
			loader.load(queue);
			loader.load(queue);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function getFromNonready():void
		{
			loader.dictionary;
		}
		
		[Test(async)]
		public function completeEvent():void
		{
			Async.handleEvent(this, loader, Event.COMPLETE, completeEvent_asyncHandler);
			
			var queue:Vector.<String> = new <String>["a", "b"];
			loader.load(queue);
		}
		
		private function completeEvent_asyncHandler(event:Event, data:Object):void
		{
			Assert.assertTrue(loader.dictionary["a"] is BitmapData);
			Assert.assertNull(loader.dictionary["undefinedScreen"]);
		}
		
		[Test(async)]
		public function completeEventWhenEmptyQueueGiven():void
		{
			Async.handleEvent(this, loader, Event.COMPLETE, null);
			loader.load(new <String>[]);
		}
		
	}
}
/*
 Screenshot util for integration testing of ui components
 Copyright 2013 Jan Břečka. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it
 in accordance with the terms of the accompanying license agreement.
*/

package tests.com.jx.screenshot
{
	import com.jx.screenshot.LoadQueue;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	
	import tests.TestCase;

	/**
	 * @author Jan Břečka
	 * @langversion 3.0
	 */
	
	public class LoadQueueTest extends TestCase
	{
		
		private var queue:LoadQueue;
		
		[Before]
		public function setUp():void
		{
			queue = new LoadQueue("../fixtures/");
		}
		
		[Test(expects="ArgumentError")]
		public function emptyQueueArgument():void
		{
			queue.load(null);
		}
		
		[Test(async)]
		public function multipleLoads():void
		{
			Async.handleEvent(this, queue, Event.COMPLETE, function(event:Event, data:Object):void
			{
				Assert.assertTrue(queue.dictionary["a"]);
				Assert.assertTrue(queue.dictionary["b"]);
			});
			queue.load(new <String>["a"]);
			queue.load(new <String>["a", "b"]);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function getFromNonready():void
		{
			queue.dictionary;
		}
		
		[Test(async)]
		public function completeEvent():void
		{
			Async.handleEvent(this, queue, Event.COMPLETE, function(event:Event, data:Object):void
			{
				Assert.assertTrue(queue.dictionary["a"] is BitmapData);
				Assert.assertNull(queue.dictionary["undefinedScreen"]);
			});
			queue.load(new <String>["a", "b"]);
		}
		
		[Test(async)]
		public function completeEventWhenEmptyQueueGiven():void
		{
			Async.handleEvent(this, queue, Event.COMPLETE, function(event:Event, data:Object):void
			{
				Assert.assertNotNull(queue.dictionary);
			});
			queue.load(new <String>[]);
		}
		
		[Test(async)]
		public function loadBadFixture():void
		{
			Async.handleEvent(this, queue, Event.COMPLETE, function(event:Event, data:Object):void
			{
				Assert.assertNull(queue.dictionary["bad"]);
			});
			queue.load(new <String>["bad"]);
		}
		
	}
}
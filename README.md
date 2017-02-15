# SWFCacheIOS v1.0.0
>Author: Wenderson Pires - wpdas@yahoo.com.br

Using SWFCacheIOS you can load more than once a single SWF file. It is known that this is not possible in the iOS operating system. Here is the solution to applications iOS AIR!

## Apps/Games using this source:
[App Store](https://itunes.apple.com/mx/developer/360e1-entretenimento/id1170254384).

## How to use
Example: [MainExample.as](https://github.com/Wpdas/Physic_AS3/tree/master/example).
	
```actionscript
package 
{
	import com.wpdas.cache.SWFCacheIOS;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	/**
	 * Use example
	 * @author Wenderson Pires da Silva
	 */
	public class MainExample extends Sprite
	{
		
		public function MainExample() 
		{
			/**
			 * Load/Reload SWF File
			 * Shoot the type COMPLETE event every time the file is loaded or reloaded.
			 */
			SWFCacheIOS.instance.addEventListener(Event.COMPLETE, onLoadSWFComplete);
			
			loadButton.addEventListener(MouseEvent.CLICK, onTapLoadButton);
			unloadButton.addEventListener(MouseEvent.CLICK, onTapUnloadButton);
		}
		
		private function onTapLoadButton(e:MouseEvent):void 
		{
			//First remove the last SWF loaded
			onTapUnloadButton(null);
			
			//Load new SWF file
			SWFCacheIOS.instance.load(new URLRequest("UIContent.swf"));
		}
		
		private function onTapUnloadButton(e:MouseEvent):void 
		{
			//If added on stage, remove it
			if (SWFCacheIOS.instance.getLoadedSWF != null && SWFCacheIOS.instance.getLoadedSWF.content.stage) {
				
				removeChild(SWFCacheIOS.instance.getLoadedSWF.content);
				
				//Clear memory (IMPORTANT)
				SWFCacheIOS.instance.getLoadedSWF.content.loaderInfo.loader.stopAllMovieClips();
				
				try {
					SWFCacheIOS.instance.getLoadedSWF.close();
				} catch ( e : * ) {};
			}
		}
		
		/**
		 * When SWF file loaded/reloaded
		 * @param	e
		 */
		private function onLoadSWFComplete(e:Event):void 
		{
			/**
			 * Add the element
			 * 
			 * Possibilities:
			 * addChild(SWFCacheIOS.instance.getLoadedSWF); Loader
			 * addChild(SWFCacheIOS.instance.getLoadedSWF.content); DisplayObject context (First level to access and manipulate the source class)
			 */
			addChild(SWFCacheIOS.instance.getLoadedSWF.content);
		}
	}

}

```


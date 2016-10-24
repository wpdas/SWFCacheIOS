package com.wpdas.cache 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * Controla o Cache de arquivos SWF carregados (Usado para projetos iOS)
	 * @author Wenderson Pires da Silva
	 * 
	 * @version 1.0.0
	 */
	public class SWFCacheIOS extends EventDispatcher
	{
		//Instancia
		private static var _instance:SWFCacheIOS;
		
		//Vars
		private var swfList:Vector.<SWFCache> = new Vector.<SWFCache>();
		
		//Current Load
		private var currentLoadedSWF:Loader;
		
		//LoaderContext
		private var loaderContext:LoaderContext;
		
		public function SWFCacheIOS() 
		{
			if (SWFCacheIOS._instance != null){
				throw new Error("Esta é uma classe singleton, não pode ser instanciada.");
			} else {
				
				loaderContext = new LoaderContext();
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				loaderContext.allowCodeImport = true;
			}
		}
		
		/**
		 * SWFCacheIOS
		 */
		public static function get instance():SWFCacheIOS {
			if (_instance == null) {
				_instance = new SWFCacheIOS();
			}
			
			return _instance;
		}
		
		/**
		 * Solicita a carga de um objeto SWF
		 * @param	url	URLRequest
		 */
		public function load(url:URLRequest):void {
			
			var existOnCache:Boolean = false;
			var restoreCache:SWFCache;
			
			//Verifica se já foi instanciado um SWF com esse endereço, se sim, retorna ele, se não.. instancia e guarda
			for each(var cache:SWFCache in swfList){
				
				if (cache.urlID == url.url){
					existOnCache = true;
					restoreCache = cache;
					currentLoadedSWF = cache.swf;
					
					break;
				}
			}
			
			if (!existOnCache){
				
				//Gera instancia e guarda
				var loader:Loader = new Loader();
				
				function onLoadSWF(e:Event):void 
				{
					//Registra esse SWF para recarga
					var swfCache:SWFCache = new SWFCache(loader, url.url);
					swfList.push(swfCache);
					
					//Seta SWF carregado
					currentLoadedSWF = loader;
					
					//Remove evento
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadSWF);
					
					//Dispara evento informando que foi carregado
					dispatchEvent(e);
				}
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSWF);
				loader.load(url, loaderContext);
				
			} else {
				
				//Cria copia dos dados para nao alterar o original
				var copySwf:Loader = new Loader();
				
				function onCopyGame(e:Event):void {
					copySwf.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCopyGame);
					
					//Seta Loader
					currentLoadedSWF = copySwf;
					
					//Dispara evento informando que o arquivo foi recarregado
					dispatchEvent(new Event(Event.COMPLETE));
				}
				
				copySwf.contentLoaderInfo.addEventListener(Event.COMPLETE, onCopyGame);
				copySwf.loadBytes((SWFCacheIOS.instance.getLoadedSWF as Loader).contentLoaderInfo.bytes, loaderContext);
			}
		}
		
		/**
		 * Retorna o arquivo SWF carregato
		 */
		public function get getLoadedSWF():Loader {
			
			return currentLoadedSWF;
		}
		
	}
}



/**
 * Classe interna do tipo SWFCache
 */
import flash.display.Loader;

class SWFCache
{
	//Loader
	//public var swf:DisplayObject;
	public var swf:Loader;
	//URL que servira como identificação
	public var urlID:String;
	
	/**
	 * SWFCache
	 * @param	swf		Conteúdo SWF
	 * @param	urlID	URL para identificação
	 */
	//public function SWFCache(swf:DisplayObject, urlID:String) {
	public function SWFCache(swf:Loader, urlID:String) {
		this.swf = swf;
		this.urlID = urlID;
	}
}
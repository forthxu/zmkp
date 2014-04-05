package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import socket.ClientSocket;
	
	import view.TestView;


	[SWF(width = "600", height = "600")]
	/**
	 *
	 * @author Jason
	 */
	public class ClientTest extends Sprite
	{
		private var _testView : TestView;
		private var _socket:ClientSocket;

		public function ClientTest()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(evt : Event) : void
		{
			_testView = TestView.getInstance();
			this.addChild(_testView);
			_socket=ClientSocket.getInstance();
			
		}
	}
}

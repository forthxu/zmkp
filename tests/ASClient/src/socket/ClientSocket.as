package socket
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	
	import view.TestView;

	/**
	 *
	 * @author Jason
	 */
	public class ClientSocket extends Socket
	{
		private static var _this : ClientSocket;
		private static var _ip : String = "192.168.137.3";

		private var _testView : TestView;

		public function ClientSocket(host : String = null, port : uint = 0)
		{
			super();
			_testView = TestView.getInstance();
			configureListeners();
			if(host && port)
			{
//				Security.loadPolicyFile("http://192.168.54.227/ServerTest/crossdomain.xml");
				Security.loadPolicyFile("xmlsocket://192.168.54.227:8866");
//				Security.loadPolicyFile("xmlsocket://localhost:8866");
				this.connect(host, port);
			}
		}

		public static function getInstance() : ClientSocket
		{
			if(!_this)
				_this = new ClientSocket(_ip, 10101);
			return _this;
		}

		private function configureListeners() : void
		{
			this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.addEventListener(Event.CLOSE, closeHandler);
			this.addEventListener(Event.CONNECT, connectHandler);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
			this.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}

		protected function socketDataHandler(event : ProgressEvent) : void
		{
			var str : String = readUTF();
			_testView.appendInfo("收到："+str);
		}

		public function sendMessage(data : Object) : void
		{
			if(!data)
				return;
			if(data is String)
			{
				try
				{
					writeUTF(data as String);
				}
				catch(error : Error)
				{
					_testView.appendInfo(error.message);
					return;
				}
			}
			this.flush();
			_testView.appendInfo(data+" 已发送");
			_testView.clearInput();
		}

		protected function securityErrorEventHandler(event : SecurityErrorEvent) : void
		{
			_testView.appendInfo("securityErrorEventHandler: " + event+"\n");
		}

		protected function connectHandler(evt : Event) : void
		{
			_testView.appendInfo("连接到服务器: " + _ip + "成功！\n");
			
		}

		protected function closeHandler(event : Event) : void
		{
			_testView.appendInfo("与服务端断开连接: " + event+"\n");
		}

		protected function ioErrorHandler(event : IOErrorEvent) : void
		{
			_testView.appendInfo("iOErrorEvent: " + event+"\n");
		}
	}
}
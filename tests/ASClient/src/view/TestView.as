package view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import socket.ClientSocket;

	/**
	 *
	 * @author Jason
	 */
	public class TestView extends Sprite
	{
		private static var _this:TestView;
		
		private var _outputPanel : TextField;
		private var _inputPanel : TextField;
		private var _clientSocket:ClientSocket;

		public function TestView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, initView);
		}

		protected function initView(evt : Event) : void
		{
			_outputPanel = new TextField();
			_outputPanel.width = 595;
			_outputPanel.height = 498;
			_outputPanel.border = true;
			_outputPanel.type = TextFieldType.DYNAMIC;
			_outputPanel.defaultTextFormat = new TextFormat(null, 15, 0x0000FF, true);
			_outputPanel.wordWrap=true;
			this.addChild(_outputPanel);
			_outputPanel.x = 2;
			_outputPanel.y = 2;

			_inputPanel = new TextField();
			_inputPanel.width = 595;
			_inputPanel.height = 85;
			_inputPanel.border = true;
			_inputPanel.type = TextFieldType.INPUT;
			_inputPanel.defaultTextFormat = new TextFormat(null, 15, 0x00000, true);
			this.addChild(_inputPanel);
			_inputPanel.x = 2;
			_inputPanel.y = 510;
			_inputPanel.addEventListener(KeyboardEvent.KEY_DOWN,fuSendString);
			
			_clientSocket=ClientSocket.getInstance();
		}
		
		protected function fuSendString(evt:KeyboardEvent):void
		{
			if(evt.keyCode==Keyboard.ENTER)
			{
				if(_inputPanel.text!="")
				{
					_clientSocket.sendMessage(_inputPanel.text);
				}
				else
				{
					appendInfo("内容不能为空！");
				}
			}
		}
		
		public function appendInfo(str:String):void
		{
			_outputPanel.appendText(str+"\n");
			_outputPanel.scrollV=_outputPanel.maxScrollV;
		}
		
		public function clearInput():void
		{
			_inputPanel.text="";
		}
		
		public static function getInstance():TestView
		{
			if(!_this)
				_this=new TestView();
			return _this;
		}
	}
}

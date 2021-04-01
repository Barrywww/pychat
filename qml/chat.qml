import QtQuick 2.13
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Universal 2.4
import QtQuick.Controls.Material 2.4
import QtCharts 2.2

ApplicationWindow {
  visible: true
  minimumHeight: 900
  minimumWidth: 1200
	maximumHeight: 900
  maximumWidth: 1200
  Material.theme: Material.Dark
  Material.accent: Material.Purple
  Material.primary: Material.Orange
	FontLoader{ id: localFont; source: "ABG.otf" }
	property string msg : "++++ Choose one of the following commands\n
time: calendar time in the system\n
who: to find out who else are there\n
c _peer_: to connect to the _peer_ and chat\n
? _term_: to search your chat logs where _term_ appears\n
p _#_: to get number <#> sonnet\n
q: to leave the chat system\n"


	property var component
	property var object
	property var grp
	property var grpobj
	property var materialColors: [
	'Red', 'Pink', 'Purple', 'DeepPurple', 'Indigo', 'Blue',
	'LightBlue', 'Cyan', 'Teal', 'Green', 'Amber', 'Orange', 'DeepOrange', 'Brown'
	]
	
	function msg_in(m){
		msg_text.text += m
	}
	function printit(){
		con.printit()
	}
	function new_user(usr){
		component = Qt.createComponent("users.qml")
		if(Component.Ready === component.status){
			object = component.createObject(usrlayout,{id:usr,objectName:usr,"Material.accent":materialColors[Math.floor(Math.random()*14)]})
		}
	}
	function new_grp(grp_id,grp_name){
		grp = Qt.createComponent("grppol.qml")
		if(Component.Ready === grp.status){
			grpobj = grp.createObject(grplayout,{id:"grp"+grp_id,objectName:grp_name})
		}
	}
	function logout_usr(usr){
		usr.text = "123"
	}
	function send_msg(msg){
		con.recvmsg(msg)
		msg += "\n"
		msg_in(msg)
		msg_send.text = ""
	}
	function update_usr(){
		con.update_usr()
	}
	function connect_usr(usr){
		if (con.checkstatus() != 3){
			send_msg("c"+usr)
		}
		else{
			msg_in("Cannot Connect to Others While Chatting\n")
		}
	}
	Loader{
		id:loader
	}
	RowLayout{
		width : parent.width
		height : parent.height
		//Layout.leftMargin : 20
		ColumnLayout{
			width : 150
			height:parent.height
			Layout.leftMargin : 20
			Layout.topMargin : 30
			Layout.alignment : Qt.AlignTop
				RoundButton {
					id : self_icon
					Material.accent:materialColors[Math.floor(Math.random()*16)]
					//anchors.top : parent.top
					anchors.horizontalCenter : parent.horizontalCenter
					highlighted : true
					implicitWidth:100
					implicitHeight:100
						Text {
							id : self_name
							objectName : "self_name"
							anchors.centerIn:parent
							text : "B"
							color: 'white'
							font { family: localFont.name; pixelSize: 32;}
						}
					onClicked : new_grp("1","Tina,Barry,Max...")
				}
				Text{
					topPadding : 20
					//anchors.top : self_icon.bottom
					anchors.horizontalCenter : parent.horizontalCenter
					objectName : "username"
					text : ""
					color: 'white'
					font { family: localFont.name; pixelSize: 32;}
				}
			Pane {
				id : usrlst
				objectName : "usrlst"
				width : 100
				//Layout.topMargin : 30
				//Layout.alignment : Qt.AlignBottom
				Layout.fillHeight: true
				ColumnLayout{
					id :usrlayout
					width : parent.width
				}
			}
      ToolButton {
        icon.source: '../images/baseline-more_vert-24px.svg'
        onClicked: menu.open()
        Menu {
          id: menu
          y: parent.height
          MenuItem { 
						text: '&Refresh Online Users' 
						onTriggered: update_usr()
						}
          MenuItem { 
						text: '&Exit' 
						onTriggered: {
							send_msg("q")
						}
						}
        }
      }			
		}
		ColumnLayout{
			id:grplayout
			width : 300
			Layout.minimumWidth:300
			Layout.maximumWidth:300
			Layout.leftMargin : 20
			Layout.topMargin : 30
			Layout.alignment : Qt.AlignTop
			Text{
				Layout.alignment : Qt.AlignTop
				topPadding : 20
				//anchors.top : self_icon.bottom
				anchors.horizontalCenter : parent.horizontalCenter
				text : "Chat Groups"
				color: 'white'
				font { family: localFont.name; pixelSize: 32;}
			}
		}
		ColumnLayout{
			objectName : "lout"
			width : 500
			Layout.leftMargin : 20
			Layout.rightMargin : 20
			Layout.topMargin : 30
			Layout.alignment : Qt.AlignLeft
			GroupBox {
				id : msg_gpbx
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.minimumWidth: 500
				clip: true
				  ScrollView {
						id : msgbox
            width: parent.width
						height: 650
						ScrollBar.vertical.interactive: true
						TextArea{
						id : msg_text
						text : msg
						font { family: localFont.name; pixelSize: 20;}
						color : "white"
						readOnly: true
						persistentSelection: true
						}
          }
					ScrollView {
						id :scro
						anchors.top : msgbox.bottom
            width: parent.width
            height: 200
            TextArea {
							id : msg_send
							font { family: localFont.name; pixelSize: 20;}
              placeholderText: 'Multi-line text editor...'
              //selectByMouse: true
              persistentSelection: true
          }
         }
			}
		}	
	}
	Button{
	x : 1100
	y : 820
	text: 'SEND'
	font { family: localFont.name; pixelSize: 16;}
	Material.theme : Material.Light
	Material.accent: Material.DeepOrange
	highlighted: true
	onClicked : send_msg(msg_send.text)
	}
	Button{
		visible : true
		Material.theme : Material.Light
		Material.accent: Material.Red
		x : 1070
		y : 40
		highlighted : true
		implicitWidth:100
		implicitHeight:40
			Text {
				anchors.centerIn:parent
				text : "DISCONNECT"
				color: 'white'
				font { family: localFont.name; pixelSize: 16;}
			}	
		onClicked : {
			if (con.checkstatus() == 3){
			send_msg("bye")}
		}
	}
	footer: RowLayout {
    width: parent.width
    RowLayout {
      Layout.margins: 10
      Layout.alignment: Qt.AlignHCenter
      Label {
				visible:false
        id: qtquick2Themes
				text : "Material"
        objectName: 'qtquick2Themes'
        Layout.fillWidth: true
      }
    }
  }
 }
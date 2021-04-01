import QtQuick 2.13
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Universal 2.4
import QtQuick.Controls.Material 2.4
import QtCharts 2.2

ApplicationWindow {
	id : login_app
  visible: true
  minimumHeight: 900
  minimumWidth: 600
	maximumHeight: 900
  maximumWidth: 600
  Material.theme: Material.Dark
  Material.accent: Material.Purple
  Material.primary: Material.Orange
	FontLoader{ id: localFont; source: "ABG.otf" }
	function regischeck(){
	if (reg_pswd.text != reg_cpswd.text){
		regis_label.text = "Passwords NOT Match"
		regis_rslt.open()
	}
	else if (con.register(reg_usr.text,reg_cpswd.text) == 1){
		regis_label.text = "Username Already Exists"
		regis_label.color = "red"
		regis_rslt.open()		
	}
	else{
		regis_label.text = "Success!"
		regis_label.color = "green"
		regis_rslt.open()
	}
	}
	
	function login(){
			if (!con.login(username.text,password.text)){
				regis_label.text = "Username Or Password WRONG!"
				regis_label.color = "red"
				regis_rslt.width = 350
				regis_rslt.open()
			}
	}
	Text{
		width:600
		height:200
		y: 150
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		text:'ICS Chat'
		color:'white'
		font { family: localFont.name; pixelSize: 80; weight: Font.Bold;}
	}

	TextField {
		id : username
		x:200
		y:350
		width : 200
		height:60
		placeholderText: 'Username'
		font.pixelSize : 20
		selectByMouse: true
	}
	TextField {
		id : password
		x:200
		y:425
		width : 200
		height:60
		placeholderText: 'Password'
		font.pixelSize : 20
		echoMode : TextInput.Password
		selectByMouse: true
	}
  RoundButton {
	x : 250
	y : 550
	highlighted : true
	implicitWidth:100
	implicitHeight:100
	onClicked: login()
	Text {
		anchors.centerIn:parent
	  text : ">"
		color: 'white'
		font.bold : true
	  font.pixelSize: 28
	}
  }  
	Text{
		x:200
		y:700
		width : 200
		height : 50
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		text : "DON'T HAVE ACCOUNT?"
		color : "white"
		font { family: localFont.name; pixelSize: 18;}
	}
	Button {
		x:260
		y:750
		text: 'REGISTER'
		Layout.fillWidth: true
		Material.accent: Material.BlueGrey
		highlighted: false
		onClicked: register.open()
	}
	Popup {
	id: register
	width:400
	height:300
	modal: true
	anchors.centerIn : parent
	ColumnLayout {
		anchors.left:parent.left
		anchors.right:parent.right
		Label { 
			text: 'Regsiter' 
			font.pixelSize : 24
		}
		
		RowLayout{
			Layout.alignment : Qt.AlignCenter
			Label{
				//anchors.left:parent.left
				text: "Username"
				font.pixelSize:18
				}
			TextField{
				id : reg_usr
				Layout.alignment : Qt.AlignRight
				Layout.fillWidth : true
				//placeholderText: 'Username'
				font.pixelSize : 18
				selectByMouse: true
			}
		}
		RowLayout{
			Layout.alignment : Qt.AlignCenter
			Label{
				text: "Password"
				font.pixelSize:18
				}
			TextField{
				id : reg_pswd
				//placeholderText: 'Password'
				Layout.alignment : Qt.AlignRight
				Layout.fillWidth : true
				echoMode: TextInput.Password
				font.pixelSize : 18
				selectByMouse: true
			}
		}
		RowLayout{
			Layout.alignment : Qt.AlignCenter
			Label{
				text: " Confirm\nPassword"
				font.pixelSize:18
				}
			TextField{
				id : reg_cpswd
				//placeholderText: 'Confirm Password'
				Layout.alignment : Qt.AlignRight
				Layout.fillWidth : true
				echoMode: TextInput.Password
				font.pixelSize : 18
				selectByMouse: true
			}
		}

		Button{
			text: 'CONFIRM'
			Layout.alignment : Qt.AlignCenter
			Material.accent: Material.BlueGrey
			highlighted: true
			onClicked: regischeck()
		}
	}
	}
	Popup{
	id: regis_rslt
	width:250
	height:80
	modal: true
	anchors.centerIn : parent
	Label{
		Layout.alignment : Qt.AlignHCenter
		anchors.centerIn : parent
		id : regis_label
		text:'Passwords NOT Identical'
		font.bold : true
		color : 'red'
		font.pixelSize : 20
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
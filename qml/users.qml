import QtQuick 2.13
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Universal 2.4
import QtQuick.Controls.Material 2.4

RoundButton{
	id: newuser
	objectName: "newuser"
	Material.accent: "DeepOrange"
	highlighted : true
	implicitWidth:80
	implicitHeight:80
		Text {
			anchors.centerIn:parent
			text : parent.objectName[0]
			color: 'white'
			font { family: localFont.name; pixelSize: 28;}
		}	
	onClicked : {
		connect_usr(objectName)
		}
}
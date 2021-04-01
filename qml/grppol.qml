import QtQuick 2.13
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Universal 2.4
import QtQuick.Controls.Material 2.4
RoundButton{
	id: newgrp
	objectName:"newgrps"
	Material.accent: Material.Blue
	highlighted : true
	implicitWidth:80
	implicitHeight:80
		Text {
			anchors.centerIn:parent
			text : parent.objectName[0]
			color: 'white'
			font { family: localFont.name; pixelSize: 28;}
		}
	Label{
			anchors.left : parent.right
			topPadding:25
			leftPadding:10
			text : parent.objectName
			color: 'white'
			font { family: localFont.name; pixelSize: 28;}
	}		
}
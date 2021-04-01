import os
import argparse
from chat_client_class import *
from chat_utils import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *
from PyQt5.QtQml import QQmlApplicationEngine, QQmlComponent

MODEL_INDICATOR = 0


class PyConsole(QObject):
    def __init__(self,socket):
        super().__init__()
        self.socket = socket
        self.state = S_OFFLINE
        self.system_msg = ""
        self.usrlst = []
        self.grplst = {}

    sendsignal = pyqtSignal(str)
    new_user = pyqtSignal(str)
    new_grp = pyqtSignal(str, str)

    def sendmsg(self,msg):
        self.sendsignal.emit(msg)

    def send(self,msg):
        # send needs to send a dic in form of a dump
        mysend(self.socket, msg)

    def recv(self):
        return myrecv(self.socket)

    @pyqtSlot(str, str,result = int)
    def register(self, u, p):
        reg_info = json.dumps({"action": "reg", "name": u, "password": p})
        self.send(reg_info)
        response = json.loads(self.recv())
        if response["status"] == "success":
            return 0
        elif response["status"] == "exist":
            return 1

    @pyqtSlot(str, str,result=bool)
    def login(self,u,p):
        lgn_info = json.dumps({"action": "login", "name": u, "password": p})
        self.send(lgn_info)
        response = json.loads(self.recv())
        print(response)
        if response["status"] == "success":
            self.usrlst.append(u)
            self.load_chat(u)
            return True
        else:
            return False

    @pyqtSlot(str)
    def recvmsg(self, m):
        self.client.GUI_input.append(m)

    @pyqtSlot()
    def load_chat(self,u):
        u = u[0:6] + "..." if len(u) > 7 else u
        engine_chat.load(QUrl('../qml/chat.qml'))
        engine_chat.rootObjects()[0].findChild(QObject, "self_name").setProperty("text", u[0])
        engine_chat.rootObjects()[0].findChild(QObject, "username").setProperty("text", u)
        self.sendsignal.connect(engine_chat.rootObjects()[0].msg_in)
        self.new_user.connect(engine_chat.rootObjects()[0].new_user)
        self.new_grp.connect(engine_chat.rootObjects()[0].new_grp)
        context1 = engine_chat.rootContext()
        context1.setContextProperty("con", con)
        self.state = S_LOGGEDIN
        self.name = u
        self.k_input = []
        self.client = Client(self.socket, u, con)
        self.client.run_chat()
        log = engine_login.rootObjects()[0]
        log.setProperty("visible", False)
        self.update_usr()

    @pyqtSlot()
    def printit(self):
        print("123456")

    @pyqtSlot()
    def update_usr(self):
        # self.client.main_thread.quit()
        update_info = json.dumps({"action":"guilist"})
        self.send(update_info)
        x = self.recv()
        recv = json.loads(x)
        print(recv)
        # self.client.main_thread.start()
        lst = engine_chat.rootObjects()[0].findChild(QObject, "usrlst").findChildren(QObject)
        try:
            for i in recv["users"]:
                if i not in self.usrlst:
                    self.usrlst.append(i)
                    self.new_user.emit(i)
        except:
            pass

        try:
            for k,v in recv["groups"].items():
                if k not in self.grplst.keys():
                    grp_name = ",".join(v)
                    if len(grp_name) > 13:
                        grp_name = grp_name[0:13] + "..."
                    self.grplst[k] = grp_name
                    self.new_grp.emit(k, grp_name)
                    print("emitted",k,grp_name)
                else:
                    pass
            local_keys = set(self.grplst.keys())
            remote_keys = set(recv["groups"].keys())
            dif = local_keys - remote_keys
            if len(dif) > 0:
                for k in local_keys - remote_keys:
                    engine_chat.rootObjects()[0].findChild(QObject, self.grplst[k]).deleteLater()
                    self.grplst.pop(k)
                    print("delete")
        except:
            pass


    @pyqtSlot(result=int)
    def checkstatus(self):
        print(self.client.state)
        return self.client.sm.state

    @pyqtSlot()
    def logout_usr(self,username):
        self.usrlst.remove(username)
        engine_chat.rootObjects()[0].findChild(QObject, username).deleteLater()



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='chat client argument')
    parser.add_argument('-d', type=str, default=None, help='server IP addr')
    args = parser.parse_args()

    socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    svr = SERVER if args.d == None else (args.d, CHAT_PORT)
    socket.connect(svr)

    app = QApplication(sys.argv)
    # app1 = QApplication(sys.argv)
    os.environ['QT_QUICK_CONTROLS_STYLE'] = "Material"


    # Create QML engine
    engine_login = QQmlApplicationEngine()
    engine_chat = QQmlApplicationEngine()
    component = QQmlComponent(engine_chat)
    # Load the qml file into the engine
    engine_login.load(QUrl('../qml/login.qml'))


    con = PyConsole(socket)
    context = engine_login.rootContext()
    context.setContextProperty("con", con)


    sys.exit(app.exec_())
    # sys.exit(app1.exec_())

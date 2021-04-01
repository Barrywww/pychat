import time
import socket
import select
import sys
import json
from chat_utils import *
import client_state_machine as csm
from PyQt5.QtCore import *


global con

class mainthread(QThread):
    def __init__(self,client,console):
        QThread.__init__(self)
        self.client = client
        self.console = console
        self.check = False

    signal = pyqtSignal()

    def sendsignal(self):
        self.signal.emit()

    def run(self):
        while self.client.sm.get_state() != S_OFFLINE:
            self.client.proc()
            if len(self.client.system_msg) > 0:
                self.sendsignal()
            time.sleep(CHAT_WAIT)


class Client(QObject):
    def __init__(self, soc, name, console):
        super().__init__()
        self.peer = ''
        self.name = name
        self.console = console
        self.console_input = []
        self.state = S_OFFLINE
        self.system_msg = ''
        self.local_msg = ''
        self.peer_msg = ''
        self.socket = soc
        self.GUI_input = []
        self.main_thread = mainthread(self,self.console)
        self.main_thread.signal.connect(self.output)

    def quit(self):
        self.socket.shutdown(socket.SHUT_RDWR)
        self.socket.close()

    def get_name(self):
        return self.name

    def init_chat(self):
        self.sm = csm.ClientSM(self.socket,self.console)
        self.state = S_LOGGEDIN
        self.sm.set_state(S_LOGGEDIN)
        self.sm.set_myname(self.name)

    def shutdown_chat(self):
        return

    def send(self, msg):
        mysend(self.socket, msg)

    def recv(self):
        return myrecv(self.socket)

    def get_msgs(self):
        read, write, error = select.select([self.socket], [], [], 0)
        my_msg = ''
        peer_msg = []
        #peer_code = M_UNDEF    for json data, peer_code is redundant
        if len(self.GUI_input) > 0:
            my_msg = self.GUI_input.pop(0)
        if self.socket in read:
            peer_msg = self.recv()
        self.GUI_input = []
        return my_msg, peer_msg

    def output(self):
        if len(self.system_msg) > 0:
            # print(self.system_msg)
            self.system_msg += "\n"
            self.console.sendmsg(self.system_msg)
            self.system_msg = ''

    def login(self):
        my_msg, peer_msg = self.get_msgs()
        if len(my_msg) > 0:
            self.name = my_msg
            msg = json.dumps({"action":"login", "name":self.name,"password":"123"})
            self.send(msg)
            response = json.loads(self.recv())
            if response["status"] == 'success':
                self.state = S_LOGGEDIN
                self.sm.set_state(S_LOGGEDIN)
                self.sm.set_myname(self.name)
                self.print_instructions()
                return (True)
            elif response["status"] == 'duplicate':
                self.system_msg += 'Duplicate username, try again'
                return False
        else:               # fix: dup is only one of the reasons
           return(False)


    def read_input(self):
        while True:
            text = sys.stdin.readline()[:-1]
            self.console_input.append(text) # no need for lock, append is thread safe

    def print_instructions(self):
        self.system_msg += menu

    def run_chat(self):
        self.init_chat()
        self.system_msg += 'Welcome, ' + self.get_name() + '!\n'
        self.output()
        self.main_thread.start()

#==============================================================================
# main processing loop
#==============================================================================
    def proc(self):
        my_msg, peer_msg = self.get_msgs()
        self.system_msg += self.sm.proc(my_msg, peer_msg)

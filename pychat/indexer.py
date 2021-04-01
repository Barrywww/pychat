# -*- coding: utf-8 -*-
"""
Created on Sat Jul  5 11:38:58 2014

@author: zzhang
"""
import pickle

class Index:
    def __init__(self, name):
        self.name = name
        self.msgs = [];
        self.index = {}
        self.total_msgs = 0
        self.total_words = 0
        
    def get_total_words(self):
        return self.total_words
        
    def get_msg_size(self):
        return self.total_msgs
        
    def get_msg(self, n):
        return self.msgs[n]
        
    def add_msg(self, m):
        self.msgs.append(m)
        self.total_msgs += 1
        
    def add_msg_and_index(self, m):
        self.add_msg(m)
        line_at = self.total_msgs - 1
        self.indexing(m, line_at)
 
    def indexing(self, m, l):
        words = m.split()
        self.total_words += len(words)
        for wd in words:
            if wd not in self.index:
                self.index[wd] = [l,]
            else:
                self.index[wd].append(l)
                                     
    def search(self, term):
        msgs = []
        if (term in self.index.keys()):
            indices = self.index[term]
            msgs = [(i, self.msgs[i]) for i in indices]
        return msgs

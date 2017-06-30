#!/usr/bin/python3

import sys
import os
import time

class ADC:
    
    chan = 1
    adcpath = 'testadc'#'/dev/adc'
    adcfile = None
    
    
    def read(self):
        if self.adcfile is not None:
            val = int(self.adcfile.readline())
            self.adcfile.seek(0)
            return val
        

    
    def __init__(self, channum):
        self.chan = channum
        
        dir_path = os.path.dirname(os.path.realpath(__file__))
        fname = dir_path + os.path.sep + self.adcpath
        
        print("ADC file: ", fname);
        
        self.adcfile = open(fname,'r')


def main(argv):
    print("Start")
    adc = ADC(1)
    
    
    
    
    while True:
        
        v = adc.read()
        print(v)
        time.sleep(1)
        
    

if __name__ == "__main__":
    main(sys.argv)

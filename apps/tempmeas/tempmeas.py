#!/usr/bin/python3

import sys
import os
import time
import csv
import datetime

class Button:

    last_pressed = None
    
    def __init__(self, channum):
        pass

    def check(self):
        self.last_pressed = datetime.datetime.now()

class ADC:

    chan = 1
    adcpath = 'testadc'  # '/dev/adc'
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

        print("ADC file: ", fname)

        self.adcfile = open(fname, 'r')


def main(argv):
    print("Start")
    adc = ADC(1)
    button = Button(1)

    button.check()

    with open('tprofile.csv', 'r') as f:
        reader = csv.reader(f)
        tprofile = dict(reader)
        tprofile = {int(old_key): float(val) for old_key, val in tprofile.items()}
        del reader

    
    start = datetime.datetime.now()
    tp = 0

    while True:
        v = adc.read()

        dt = (datetime.datetime.now() - start).seconds
        
        if dt in tprofile:
            tp = tprofile[dt]      
        
        print('ADC: %d  Profile: %d  %d' % (v, tp, dt))
        time.sleep(0.5)


if __name__ == "__main__":
    main(sys.argv)

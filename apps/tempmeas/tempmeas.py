#!/usr/bin/python3

import sys
import os
import time
import csv
import datetime
import threading
import select
import fcntl


class Button:

    last_pressed = None

    # Pin to work with
    pin = '144'
    pin_file = None

    @staticmethod
    def write_once(path, value):
        with open(path, 'w') as f:
            f.write(value)

    def __init__(self, channum):
        path = '/sys/class/gpio/'
        self.pin_file = os.path.join(path, 'gpio' + self.pin)

        if os.path.exists(self.pin_file) == False:
            Button.write_once(os.path.join(path, 'export'), self.pin)

        Button.write_once(os.path.join(self.pin_file, 'direction'), 'in')
        Button.write_once(os.path.join(self.pin_file, 'active_low'), '1')
        Button.write_once(os.path.join(self.pin_file, 'edge'), 'falling')

        self.f = open(os.path.join(self.pin_file, 'value'), 'r')

        t = threading.Thread(target=self.poller, daemon=True)
        t.start()

    def poller(self):

        po = select.poll()
        po.register(self.f, select.POLLPRI)
        self.f.read()

        while True:
            events = po.poll(10000)
            if events:
                self.f.seek(0)
                self.f.read()
                self.last_pressed = datetime.datetime.now()
                print("Starting over...")


class ADC:

    chan = 1
    adcpath = '/dev/adc'
    adcfile = None

    setchan_cmd = 0xc000fa01

    def read(self):
        if self.adcfile is not None:
            val = int(self.adcfile.readline())
            if DEBUG_MODE:
                self.adcfile.seek(0)
            return val

    def __init__(self, channum):
        self.chan = channum

        dir_path = os.path.dirname(os.path.realpath(__file__))
        if DEBUG_MODE:
            self.adcpath = 'testadc'
            self.fname = dir_path + os.path.sep + self.adcpath
        else:
            self.fname = self.adcpath

        print("ADC file: ", self.fname)

     
    def __enter__(self):
        self.adcfile = open(self.fname, 'r')
        rv = fcntl.ioctl(self.adcfile, self.setchan_cmd, self.chan)
        print("Setting chan to %d Response: %d" %(self.chan, rv))

    def __exit__(self, exc_type, exc_value, traceback):
        self.adcfile.close()


def main(argv):
    intro = "Start"

    global DEBUG_MODE

    DEBUG_MODE = False
    if len(argv) > 0:
        DEBUG_MODE = argv[0] == "DEBUG"
        intro += " (" + argv[0] + ")"

    print(intro)

    button = Button(1)

    tprofile = os.path.dirname(os.path.realpath(__file__)) + os.path.sep + 'tprofile.csv'

    with open(tprofile, 'r') as f:
        reader = csv.reader(f)
        tprofile = dict(reader)
        tprofile = {int(old_key): float(val)
                    for old_key, val in tprofile.items()}
        del reader


    tr = os.path.dirname(os.path.realpath(__file__)) + os.path.sep + 'tr.csv'

    temp_c = ()
    res_ohm = ()
    
    with open(tr, 'r') as f:
        reader = csv.reader(f)
        cols = list(zip(*reader))
        del reader

        temp_c = cols[0]
        res_ohm = cols[4]

    
    tp = 0

    adc = ADC(1)
    dt = 0

    r1_ohm = 1000

    with adc:
        while True:
            v = adc.read()
            if v == 0: v = 1

            rt = r1_ohm*(1024/v-1)
            rt = min(res_ohm, key=lambda x:abs(float(x)-rt))
                        
            index = res_ohm.index(rt)
            temp = temp_c[index]

            if button.last_pressed is not None:
                dt = (datetime.datetime.now() - button.last_pressed).seconds
                if dt in tprofile:
                    tp = tprofile[dt]

            print('ADC: %d Res: %s Temp: %s Profile: %d  %d' % (v, rt, temp, tp, dt))
            time.sleep(0.5)


if __name__ == "__main__":
    main(sys.argv[1:])

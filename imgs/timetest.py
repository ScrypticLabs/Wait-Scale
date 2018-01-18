#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Abhi
# @Date:   2015-08-14 00:30:28
# @Last Modified by:   Abhi
# @Last Modified time: 2015-08-14 00:38:41

import datetime
startTime = datetime.datetime.utcnow()

while True:
	if input("Enter value: ") == "0":	break

currentTime = datetime.datetime.utcnow()

print((currentTime-startTime)/datetime.timedelta(minutes=1))
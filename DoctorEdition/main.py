#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Abhi
# @Date:   2015-08-13 20:36:59
# @Last Modified by:   Abhi
# @Last Modified time: 2015-08-15 14:33:12

from functions import *

server = Server()
prompt = CommandLine()

homeTask = ''
home = True
main = False
action = ''

while True:
	if home:
		prompt.clear()
		print("\n======================================================\n=== CITY CENTRE WALK-IN CLINIC - PATIENT OCCUPANCY ===\n======================================================\n")
		homeTask = input("\nLogin or Sign up?\n").lower()
		home = False

	if homeTask == 'login' and home == False and main == False:
		credentials = prompt.logIn()

		if credentials != 'exit':
			server.logInCredentials['userID'], server.logInCredentials['password'] = credentials
			server.logIn()
			if server.logInSuccessful:
				main = True
			else:
				home = True
		else:
			home = True

	elif homeTask == 'sign up' and home == False and main == False:
		credentials = prompt.signUp()

		if credentials != 'exit':
			server.signUpCredentials['full_name'], server.signUpCredentials['email'], server.signUpCredentials['userID'], server.signUpCredentials['password'] = credentials
			server.signUp()
			if server.signUpSuccessful:
				main = True
			else:
				home = True
		else:
			home = True
	
	if main:
		action = input("\nChoose what action to perform (Type 'exit' to Log Out:) \nA - Add new patient to waiting list\nB - Delete patient from waiting list\nC - View patient waiting list\n").upper()

		if action == 'A':
			name = input("Enter the patient's full name: ").title()
			if name == 'Exit':
				action = ''
			else:
				server.addPatient(name)
				server.refreshWaitedTime()
				action = ''
		elif action == 'B':
			name = input("Enter the patient's full name: ").title()
			if name == 'Exit':
				action = ''
			else:
				server.deletePatient(name)
				server.refreshWaitedTime()
				action = ''
		elif action == 'C':
			server.viewWaitingList()
		elif action == 'EXIT':
			server.logOut()
			server.refreshWaitedTime()
			main = False
			home = True
			action = ''
			prompt.clear()



#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Abhi Gupta
# @Date:   2015-08-13 20:31:09
# @Last Modified by:   Abhi
# @Last Modified time: 2015-08-16 19:12:51

from parse_rest.connection import register # imports the module neccesarry to register the app with the author's credentials
from parse_rest.datatypes import ACL
from parse_rest.user import User 		   # imports the module to sign up, log in, add and delete users
from parse_rest.datatypes import Object
from parse_rest.connection import ParseBatcher
from parse_rest.connection import SessionToken

import urllib.request 						# Email verification to send HTTP requests
import json
import getpass
import os
import time
import datetime

class Server:
	"""Contains all of the API SID Keys and verifys the auth. Token in order to save data to our own server"""
	def __init__(self):
		register("husLce98tepIAM9pl40MqechizNwsmWx5WNBSAPn", "gLYbSDZhJBAX4dNU0gl3sr8DFOVPEG5cBsLCzigM") # Parse Core APP Key
		self.emailKey = "2bc1e17c8d1ca087d01292a5aa5e11c652ccb48b38e3e2c8e455d66710a324d9"				 # Kickbox APP Key
		
		self.signUpCredentials = {
					'full_name'	:	'',
					'email'		:	'',
					'userID'	:	'',
					'password'	:	'',
			}

		self.signUpKeys = ['full_name', 'email', 'userID', 'password']
		self.signUpSuccessful = None

		self.logInCredentials = {
					'userID'	:	'',
					'password'	:	'',
			}

		self.logInKeys = ['userID', 'password']
		self.logInSuccessful = None

		self.user = 0
		self.token = None
		self.full_name = ''

		self.response = 'Email Verification'
		self.emailVerfication = 'Invalid'

		#-------------------------------------------

		self.patientClass = Object.factory("Patients") 
		self.patients = self.patientClass.Query.all()


	def signUp(self):
		"""Sends a HTTP request to verify email address and attemps to create a new user in the database if all of the credentials are valid"""
		self.response = json.loads(urllib.request.urlopen("https://api.kickbox.io/v2/verify?email="+self.signUpCredentials['email']+"&apikey="+self.emailKey).read().decode("utf-8"))
		if self.response['result'] != 'deliverable' and self.response['reason'] != 'accepted_email':
			self.emailVerfication = 'Invalid'
			print("\nInvalid Email.\n")
			time.sleep(1)
		else:
			self.emailVerfication = 'Valid'
		try:
			if self.emailVerfication == 'Valid':
				self.user = User.signup(self.signUpCredentials['userID'], self.signUpCredentials['password'], email=self.signUpCredentials['email'], full_name=self.signUpCredentials['full_name'])	  # creates a new user in the database (user, password, other records)
				self.signUpSuccessful = True
				self.full_name = self.signUpCredentials['full_name']
				print("\nSigned up successfully!\n")
		except:
		 	self.signUpSuccessful = False
		 	print("\nInvalid Email.\n")
		 	time.sleep(1)
		return self.signUpSuccessful

	def logIn(self):
		"""Attempts to log in the user with the given credentials by checking if the user exits within the database"""
		try:
			self.user = User.login(self.logInCredentials['userID'], self.logInCredentials['password'])
			self.token = self.user.sessionToken
			self.full_name = self.user.full_name
			self.logInSuccessful = True
			print("\nLogged in successfully!\n")
		except:
			self.logInSuccessful = False
			print("\nAuthorization Failed.\n")
			time.sleep(1)
		return self.logInSuccessful

	def logOut(self):
		#self.user.delete()
		pass

	def getFullName(self):
		"""Returns the full name of the logged in user"""
		return self.full_name

	def addPatient(self, full_name):
		"""Adds a new patient to the Patient Class"""
		self.retrievePatients()
		repeat = False
		for pat in self.patients:
			if pat.name == full_name:
				repeat = True
				break
		if repeat == False:
			patient = self.patientClass(name=full_name, waitedTime=0, topPriority=False)
			patient.ACL.set_user(self.user, read=True, write=True)
			patient.ACL.set_default()
			patient.save()
			print("\n%s is now in the waiting list.\n" % full_name)
		else:
			print("\n%s is already in the waiting list.\n" % full_name)
		time.sleep(1)

	def deletePatient(self, full_name):
		"""Adds a new patient to the Patient Class"""
		self.retrievePatients()
		found = False
		for patient in self.patients:
			if patient.name == full_name:
				found = True
				print("\n%s is no longer waiting.\n" % full_name)
				patient.delete()
				time.sleep(1)
				break
		if found == False:
			print("%s isn't an existing patient in the waiting list" % full_name)
			time.sleep(1)

	def retrievePatients(self):
		with SessionToken(self.token):
			self.patients = self.patientClass.Query.all().order_by("-waitedTime")
			for patient in self.patients:
				currentTime = datetime.datetime.utcnow()
				patient.waitedTime = (currentTime-patient.createdAt)/datetime.timedelta(minutes=1)
				patient.save()
			return self.patients

	def viewWaitingList(self):
		self.retrievePatients()
		print("%15s	 -  %.15s" %("PATIENT", "WAIT"))
		print("-"*35)
		for patient in self.patients:
			print("%15s	 -  %.1d minute(s)" %(patient.name, round(patient.waitedTime,1)))
		if len(self.patients) == 0:
			print('The waiting list is empty!')
		time.sleep(1)

	def refreshWaitedTime(self):
		with SessionToken(self.token):
			self.patients = self.patientClass.Query.all().order_by("-waitedTime")
			for patient in self.patients:
				currentTime = datetime.datetime.utcnow()
				patient.waitedTime = (currentTime-patient.createdAt)/datetime.timedelta(minutes=1)
				patient.save()


class CommandLine:
	def __init__(self):
		pass

	def signUp(self):
		print("\n")
		# print("\n======================================================\n===== CITY CENTRE WALK-IN CLINIC - SIGN UP FORUM =====\n=================(Type 'exit' to Exit)================\n")
		full_name = input("Enter your full name: ").title()
		if full_name == 'Exit':
			return 'exit'
		email = input("Enter company email: ").lower()
		if email == 'exit':
			return 'exit'
		userID = input("Create a User ID: ")
		if userID.lower() == 'exit':
			return 'exit'
		password = getpass.getpass("Create a password (case sensistive): ")
		if password.lower() == 'exit':
			return 'exit'
		return (full_name, email, userID, password)

	def logIn(self):
		print("\n")
		# print("\n======================================================\n======= CITY CENTRE WALK-IN CLINIC - Log FORUM =======\n======================================================\n")
		userID = input("Enter User ID: ")
		if userID.lower() == 'exit':
			return 'exit'
		password = getpass.getpass("Enter password: ")
		if password.lower() == 'exit':
			return 'exit'
		return (userID, password)

	def clear(self):
		os.system('cls' if os.name == 'nt' else 'clear')
		return ''










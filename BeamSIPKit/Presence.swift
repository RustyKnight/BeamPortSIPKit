//
// Created by Shane Whitehead on 8/6/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation

public protocol SIPPresence {
	var name: String {get}
	var number: String {get}
}

public protocol SIPPresenceSubscription: SIPPresence {
	var id: Int {get}
	var subject: String {get}
}

public protocol SIPPresenceOnline: SIPPresence {
	var stateText: String {get}
}

struct DefaultSIPPresence: SIPPresence {
	let name: String
	let number: String
}

struct DefaultSIPPresenceSubscription: SIPPresenceSubscription {
	let id: Int
	let subject: String
	let name: String
	let number: String
}

struct DefaultSIPPresenceOnline: SIPPresenceOnline {
	let stateText: String
	let name: String
	let number: String
}
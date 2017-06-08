//
// Created by Shane Whitehead on 8/6/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation

public protocol SIPReferral {
	var id: Int {get}
	var to: String {get}
	var from: String {get}
	var message: String {get}
}

class DefaultSIPReferral: SIPReferral {
	let id: Int
	let to: String
	let from: String
	let message: String

	init(id: Int, to: String, from: String, message: String) {
		self.id = id
		self.to = to
		self.from = from
		self.message = message
	}
}

//
// Created by Shane Whitehead on 8/6/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation

public protocol SIPWaitingMessage {
	var messageAccount: String {get}
	var urgentNewMessageCount: Int32 {get}
	var urgentOldMessageCount: Int32 {get}
	var newMessageCount: Int32 {get}
	var oldMessageCount: Int32 {get}
}

struct DefaultSIPWaitingMessage: SIPWaitingMessage {
	let messageAccount: String
	let urgentNewMessageCount: Int32
	let urgentOldMessageCount: Int32
	let newMessageCount: Int32
	let oldMessageCount: Int32
}

public protocol SIPMessage {
	var mimeType: String {get}
	var subMimeType: String {get}
	var data: Data {get}
}

struct DefaultSIPMessage: SIPMessage {
	let mimeType: String
	let subMimeType: String
	let data: Data
}

public protocol SIPMessageWithID {
	var id: Int {get}
}

public protocol SIPOutOfDialogMessage {
	var fromName: String {get}
	var fromNumber: String {get}
	var toName: String {get}
	var toNumber: String {get}
}

public protocol SIPOutOfDialogMessageWithData: SIPOutOfDialogMessage, SIPMessage {
}

struct DefaultSIPOutOfDialogMessageWithData: SIPOutOfDialogMessageWithData {
	let fromName: String
	let fromNumber: String
	let toName: String
	let toNumber: String
	let mimeType: String
	let subMimeType: String
	let data: Data
}

struct DefaultSIPOutOfDialogMessage: SIPMessageWithID, SIPOutOfDialogMessage {
	let id: Int
	let fromName: String
	let fromNumber: String
	let toName: String
	let toNumber: String
}

public protocol SIPMessageReason: SIPReason, SIPMessageWithID {
}

struct DefaultSIPMessageReason: SIPMessageReason {
	let id: Int
	let reason: String
	let code: Int32
}
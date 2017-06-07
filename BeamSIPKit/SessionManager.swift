//
// Created by Shane Whitehead on 9/3/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public enum SIPSessionStatus {
	case none
	case outgoingInvite
	case incomingInvite
	case outgoingActive
	case incomingActive
}

public enum DTMFTone: Int32 {
	case number0 = 0
	case number1
	case number2
	case number3
	case number4
	case number5
	case number6
	case number7
	case number8
	case number9
	case star
	case hash
	case toneA
	case toneB
	case toneC
	case toneD
	case flash
}

public enum SIPSessionType {
	case incoming
	case outgoing
}

public protocol SIPSession {
	var type: SIPSessionType { get }
	var timeOfCall: Date? { get }
	var durationOfCall: TimeInterval { get }
	var name: String { get }
	var number: String { get }
	var isOnHold: Bool { get set }
	var id: Int { get }

	func send(_ tone: DTMFTone)

	var includesAudio: Bool { get }
	var includesVideo: Bool { get }

	func answer(withVideo: Bool)

	func end()

	func reject(withReason code: SIPResponseCode.ClientFailure)

	func rejectWithBusyHere()

	func rejectWithUnavailable()
}

class DefaultSIPSession: DefaultSIPSupportManager, SIPSession {

	let type: SIPSessionType
	var timeOfCall: Date?
	var durationOfCall: TimeInterval {
		return 0
	}

	let id: Int
	var name: String
	var number: String
	var includesAudio: Bool
	var includesVideo: Bool

	var isOnHold: Bool = false {
		didSet {
			if isOnHold {
				portSIPSDK.hold(id)
			} else {
				portSIPSDK.unHold(id)
			}
		}
	}

	init(portSIPSDK: PortSIPSDK, id: Int, type: SIPSessionType, name: String, number: String, includesAudio: Bool, includesVideo: Bool) {
		self.id = id
		self.type = type
		self.number = number
		self.includesAudio = includesAudio
		self.includesVideo = includesVideo
		self.name = name
		super.init(portSIPSDK: portSIPSDK)
	}

	func answer(withVideo: Bool) {
		portSIPSDK.answerCall(id, videoCall: includesVideo && withVideo)
	}

	func end() {
		portSIPSDK.hangUp(id)
	}

	func reject(withReason code: SIPResponseCode.ClientFailure) {
		portSIPSDK.rejectCall(id, code: code.rawValue)
	}

	func rejectWithBusyHere() {
		reject(withReason: .busyHere)
	}

	func rejectWithUnavailable() {
		reject(withReason: .temporarilyUnavailable)
	}

	func send(_ tone: DTMFTone) {
		portSIPSDK.sendDtmf(
				id,
				dtmfMethod: SIPDTMF.rfc2833.type,
				code: tone.rawValue,
				dtmfDration: 160,
				playDtmfTone: true)
	}

}

public enum SIPSessionManagerError: Error {
	case sessionAlreadyExists(withID: Int)
}

public protocol SIPSessionManager {

	func makeCall(to number: String, sendSDP: Bool, videoCall: Bool) throws -> SIPSession

	func session(byID: Int) -> SIPSession?
	var count: Int { get }
	var sessions: [SIPSession] { get }

	func update(
			session: SIPSession,
			callerDisplayName: String,
			caller: String,
			calleeDisplayName: String,
			callee: String,
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession

	func update(
			session: SIPSession,
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession
}

protocol MutableSIPSessionManager {
	func addSession(
			id: Int,
			type: SIPSessionType,
			callerDisplayName: String,
			caller: String,
			calleeDisplayName: String,
			callee: String,
			includesAudio: Bool,
			includesVideo: Bool) throws -> SIPSession

	func remove(_ session: SIPSession)
}

class DefaultSIPSessionManager: DefaultSIPSupportManager, SIPSessionManager, MutableSIPSessionManager {

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	func makeCall(to number: String, sendSDP: Bool, videoCall: Bool) throws -> SIPSession {
		let id = portSIPSDK.call(number, sendSdp: sendSDP, videoCall: videoCall)
		fatalError("Not yet implemented")
	}

	func session(byID: Int) -> SIPSession? {
		return sessions.first {
			$0.id == byID
		}
	}

	var count: Int {
		return sessions.count
	}

	private(set) var sessions: [SIPSession] = []

	func addSession(
			id: Int,
			type: SIPSessionType,
			callerDisplayName: String,
			caller: String,
			calleeDisplayName: String,
			callee: String,
			includesAudio: Bool,
			includesVideo: Bool) throws -> SIPSession {
		guard session(byID: id) == nil else {
			throw SIPSessionManagerError.sessionAlreadyExists(withID: id)
		}
		let sipSession = DefaultSIPSession(
				portSIPSDK: portSIPSDK,
				id: id,
				type: .incoming,
				name: callerDisplayName,
				number: caller,
				includesAudio: includesAudio,
				includesVideo: includesVideo)
		sessions.append(sipSession)
		return sipSession
	}

	func update(
			session: SIPSession,
			callerDisplayName: String,
			caller: String,
			calleeDisplayName: String,
			callee: String,
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession {
		guard var sessionValue = session as? DefaultSIPSession else {
			// Do I care?
			return session
//			var newSession = addSession(
//					id: session.id,
//					type: session.type,
//					callerDisplayName: callerDisplayName,
//					caller: caller,
//					calleeDisplayName: calleeDisplayName,
//					callee: callee,
//					includesAudio: includesAudio,
//					includesVideo: includesVideo)
//			return newSession
		}

		sessionValue.name = callerDisplayName
		sessionValue.number = caller
		sessionValue.includesAudio = includesAudio
		sessionValue.includesVideo = includesVideo

		return sessionValue
	}

	func remove(_ session: SIPSession) {
		let tmpIndex = sessions.index { $0.id == session.id  }
		guard let index = tmpIndex else {
			return
		}
		sessions.remove(at: index)
	}


}
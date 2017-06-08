//
// Created by Shane Whitehead on 9/3/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public enum SIPSessionStatus {
	case none
	case active
	case inactive
	case onHold
	case ringing
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
	var status: SIPSessionStatus { get }
	var timeOfCall: Date? { get }
	var durationOfCall: TimeInterval { get }
	var callerName: String { get }
	var callerNumber: String { get }
	var calleeName: String { get }
	var calleeNumber: String { get }
	var isOnHold: Bool { get set }
	var id: Int { get }

	var audioCodecs: [SIPAudioCodec] {get}
	var videoCodecs: [SIPVideoCodec] {get}

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

	var status: SIPSessionStatus
	let type: SIPSessionType
	var timeOfCall: Date?
	var durationOfCall: TimeInterval {
		return 0
	}

	let id: Int
	var callerName: String
	var callerNumber: String
	var calleeName: String
	var calleeNumber: String
	var includesAudio: Bool
	var includesVideo: Bool
	var includesEarlyMedia: Bool = false

	var audioCodecs: [SIPAudioCodec] = []
	var videoCodecs: [SIPVideoCodec] = []

	var isOnHold: Bool = false {
		didSet {
			if isOnHold {
				portSIPSDK.hold(id)
			} else {
				portSIPSDK.unHold(id)
			}
		}
	}

	init(
			portSIPSDK: PortSIPSDK,
			id: Int,
			type: SIPSessionType,
			status: SIPSessionStatus,
			callerName: String,
			callerNumber: String,
			calleeName: String,
			calleeNumber: String,
			audioCodes: [SIPAudioCodec],
			videoCodes: [SIPVideoCodec],
			includesAudio: Bool,
			includesVideo: Bool) {
		self.id = id
		self.type = type
		self.callerName = callerName
		self.callerNumber = callerNumber
		self.calleeName = calleeName
		self.calleeNumber = calleeNumber
		self.includesAudio = includesAudio
		self.includesVideo = includesVideo
		self.audioCodecs = audioCodes
		self.videoCodecs = videoCodes
		self.status = status
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

}

protocol MutableSIPSessionManager: SIPSessionManager {
	func addSession(
			id: Int,
			type: SIPSessionType,
			status: SIPSessionStatus,
			callerDisplayName: String,
			caller: String,
			calleeDisplayName: String,
			callee: String,
			audioCodecs: [SIPAudioCodec],
			videoCodecs: [SIPVideoCodec],
			includesAudio: Bool,
			includesVideo: Bool) throws -> SIPSession

	func remove(_ session: SIPSession)

	@discardableResult
	func update(
			session: SIPSession,
			callerDisplayName: String,
			caller: String,
			calleeDisplayName: String,
			callee: String,
			audioCodecs: [SIPAudioCodec],
			videoCodecs: [SIPVideoCodec],
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession

	@discardableResult
	func update(
			session: SIPSession,
			audioCodecs: [SIPAudioCodec],
			videoCodecs: [SIPVideoCodec],
			includesEarlyMedia: Bool,
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession

	@discardableResult
	func update(
			session: SIPSession,
			audioCodecs: [SIPAudioCodec],
			videoCodecs: [SIPVideoCodec],
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession

	@discardableResult
	func update(
			session: SIPSession,
			status: SIPSessionStatus) -> SIPSession
}

class DefaultSIPSessionManager: DefaultSIPSupportManager, SIPSessionManager, MutableSIPSessionManager {

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	func makeCall(to number: String, sendSDP: Bool, videoCall: Bool) throws -> SIPSession {
		let id = portSIPSDK.call(number, sendSdp: sendSDP, videoCall: videoCall)

		return try addSession(
				id: id,
				type: .outgoing,
				status: .ringing,
				callerDisplayName: "",
				caller: "",
				calleeDisplayName: "",
				callee: "",
				audioCodecs: [],
				videoCodecs: [],
				includesAudio: false,
				includesVideo: videoCall)
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
			status: SIPSessionStatus,
			callerDisplayName: String,
			caller: String,
			calleeDisplayName: String,
			callee: String,
			audioCodecs: [SIPAudioCodec],
			videoCodecs: [SIPVideoCodec],
			includesAudio: Bool,
			includesVideo: Bool) throws -> SIPSession {
		guard session(byID: id) == nil else {
			throw SIPSessionManagerError.sessionAlreadyExists(withID: id)
		}
		let sipSession = DefaultSIPSession(
				portSIPSDK: portSIPSDK,
				id: id,
				type: .incoming,
				status: status,
				callerName: callerDisplayName,
				callerNumber: caller,
				calleeName: calleeDisplayName,
				calleeNumber: callee,
				audioCodes: audioCodecs,
				videoCodes: videoCodecs,
				includesAudio: includesAudio,
				includesVideo: includesVideo)
		sessions.append(sipSession)
		return sipSession
	}

	@discardableResult
	func update(
			session: SIPSession,
			callerDisplayName: String,
			caller: String,
			calleeDisplayName: String,
			callee: String,
			audioCodecs: [SIPAudioCodec],
			videoCodecs: [SIPVideoCodec],
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession {
		guard let sessionValue = session as? DefaultSIPSession else {
			// Do I care?
			return session
		}

		sessionValue.callerName = callerDisplayName
		sessionValue.callerNumber = caller
		sessionValue.calleeName = calleeDisplayName
		sessionValue.calleeNumber = callee
		sessionValue.includesAudio = includesAudio
		sessionValue.includesVideo = includesVideo
		sessionValue.audioCodecs = audioCodecs
		sessionValue.videoCodecs = videoCodecs

		return sessionValue
	}

	@discardableResult
	func update(
			session: SIPSession,
			audioCodecs: [SIPAudioCodec],
			videoCodecs: [SIPVideoCodec],
			includesEarlyMedia: Bool,
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession {

		update(
				session: session,
				audioCodecs: audioCodecs,
				videoCodecs: videoCodecs,
				includesAudio: includesAudio,
				includesVideo: includesVideo)
		guard let sessionValue = session as? DefaultSIPSession else {
			// Do I care?
			return session
		}

		sessionValue.includesEarlyMedia = includesEarlyMedia

		return sessionValue
	}

	@discardableResult
	func update(
			session: SIPSession,
			audioCodecs: [SIPAudioCodec],
			videoCodecs: [SIPVideoCodec],
			includesAudio: Bool,
			includesVideo: Bool) -> SIPSession {
		guard let sessionValue = session as? DefaultSIPSession else {
			// Do I care?
			return session
		}

		sessionValue.includesAudio = includesAudio
		sessionValue.includesVideo = includesVideo
		sessionValue.audioCodecs = audioCodecs
		sessionValue.videoCodecs = videoCodecs

		return sessionValue
	}

	@discardableResult
	func update(session: SIPSession, status: SIPSessionStatus) -> SIPSession {
		guard let sessionValue = session as? DefaultSIPSession else {
			// Do I care?
			return session
		}
		sessionValue.status = status
		return session
	}

	func remove(_ session: SIPSession) {
		let tmpIndex = sessions.index { $0.id == session.id  }
		guard let index = tmpIndex else {
			return
		}
		sessions.remove(at: index)
	}

}
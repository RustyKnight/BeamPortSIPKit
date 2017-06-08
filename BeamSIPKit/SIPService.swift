//
//  SIPService.swift
//  BeamSIPKit
//
//  Created by Shane Whitehead on 1/03/2017.
//  Copyright © 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public struct SIPNotification {

	public struct Call {
		// When the call is coming, this event will be triggered.
		public static let incoming = Notification.Name("SIP.call.incoming")
		// If the outgoing call is being processed, this event will be triggered.
		public static let outgoing = Notification.Name("SIP.call.outgoing")
		// Once the caller received the "183 session in progress" message, this event will be triggered.
		public static let progress = Notification.Name("SIP.call.progress")
		// If the outgoing call is ringing, this event will be triggered.
		public static let outgoingRinging = Notification.Name("SIP.call.outgoingRinging")
		// If the remote party is answering the call, this event will be triggered.
		public static let answered = Notification.Name("SIP.call.answered")
		// If the outgoing call fails, this event will be triggered.
		public static let failed = Notification.Name("SIP.call.failed")
		// This event will be triggered when remote party updates this call.
		public static let updated = Notification.Name("SIP.call.updated")
		// This event will be triggered when UAC sent/UAS receives ACK (the call is connected).
		// Some functions (hold, updateCall etc...) can be called only after the call is connected,
		// otherwise it will return error.
		public static let connected = Notification.Name("SIP.call.connected")
		// If the enableCallForward method is called and a call is incoming, the call will be forwarded
		// automatically and this event will be triggered.
		public static let beginningForward = Notification.Name("SIP.call.beginningForward")
		// This event will be triggered once remote side closes the call.
		public static let closed = Notification.Name("SIP.call.closed")
		// If the remote side has placed the call on hold, this event will be triggered.
		public static let remoteHold = Notification.Name("SIP.call.hold")
		// If the remote side un-holds the call, this event will be triggered.
		public static let remoteUnHold = Notification.Name("SIP.call.unhold")

		public static let sessionError = Notification.Name("SIP.call.sessionError")

		public struct Key {
			public static let session = "SIP.call.session"
			public static let error = "SIP.call.error"
			public static let reason = "SIP.call.reason"
		}
	}

	public struct Register {
		public static let success = Notification.Name("SIP.register.success")
		public static let failure = Notification.Name("SIP.register.failure")

		public struct Key {
			public static let status = "SIP.register.status"
		}
	}

	public struct Refer {
		public static let received = Notification.Name("SIP.refer.received")
		public static let accepted = Notification.Name("SIP.refer.accepted")
		public static let rejected = Notification.Name("SIP.refer.rejected")
		public static let transferTrying = Notification.Name("SIP.refer.transferTrying")
		public static let transferRinging = Notification.Name("SIP.refer.transferRinging")
		public static let success = Notification.Name("SIP.refer.success")
		public static let failure = Notification.Name("SIP.refer.failure")

		public struct Key {
			public static let referral = "SIP.refer.referral"
			public static let reason = "SIP.refer.reason"
		}
	}

	// Messaging?

	public struct Signaling {
		public static let received = Notification.Name("SIP.signaling.received")
		public static let sending = Notification.Name("SIP.signaling.sending")
		public struct Key {
			public static let message = "SIP.signaling.message"
		}
	}

	// MWI

	public struct MessageWaitingIndicator {
		public static let voiceMessage = Notification.Name("SIP.mwi.voice")
		public static let faxMessage = Notification.Name("SIP.mwi.fax")
		public struct Key {
			public static let status = "SIP.mwi.status"
		}
	}

	public struct DTMF {
		public static let received = Notification.Name("SIP.dtmf.received")
		public struct Key {
			public static let tone = "SIP.dtmf.code"
		}
	}

	public struct Info {
		public static let received = Notification.Name("SIP.info.received")
		public struct Key {
			public static let message = "SIP.info.message"
		}
	}

	public struct Options {
		public static let received = Notification.Name("SIP.options.received")
		public struct Key {
			public static let message = "SIP.options.message"
		}
	}

	public struct Presence {
		public static let receivedSubscription = Notification.Name("SIP.presence.receivedSubscription")
		public static let online = Notification.Name("SIP.presence.online")
		public static let offline = Notification.Name("SIP.presence.offline")
		public struct Key {
			public static let message = "SIP.presence.message"
		}
	}

	public struct Message {
		public static let received = Notification.Name("SIP.message.received")
		public static let receivedOutOfDialog = Notification.Name("SIP.message.receivedOutOfDialog")
		public static let sendSuccessful = Notification.Name("SIP.message.sendSuccessful")
		public static let sendFailure = Notification.Name("SIP.message.sendFailure")
		public static let sendOutOfDialogSuccess = Notification.Name("SIP.message.sendOutOfDialogSuccess")
		public static let sendOutOfDialogFailure = Notification.Name("SIP.message.sendOutOfDialogFailure")

		struct Key {
			public static let status = "SIP.message.status"
			public static let id = "SIP.message.id"
			public static let message = "SIP.message.message"
			public static let reason = "SIP.message.reason"
		}
	}

	public struct Play {
		public static let audioFileFinished = Notification.Name("SIP.play.audioFileFinished")
		public static let videoFileFinished = Notification.Name("SIP.play.videoFileFinished")
		struct Key {
			public static let fileName = "SIP.play.fileName"
		}
	}

	public struct RTP {
		public static let received = Notification.Name("SIP.rtp.audioFileFinished")
		public static let sending = Notification.Name("SIP.rtp.videoFileFinished")
		struct Key {
			public static let data = "SIP.rtp.data"
		}
	}

	public struct Stream {
		public static let audio = Notification.Name("SIP.stream.audio")
		public static let video = Notification.Name("SIP.stream.video")
		public static let videoDecoded = Notification.Name("SIP.stream.videoDecoded")
		struct Key {
			public static let videoInfo = "SIP.stream.videoInfo"
		}
	}

}

public protocol SIPServiceConfiguration {
	var transportProtocol: SIPTransportProtocol { get }
	var logLevel: SIPLogLevel { get }
	var logFilePath: String { get }
	var maxCallLines: Int32 { get }
	var sipAgent: String { get }
	var audioDeviceLayer: SIPDeviceLayer { get }
	var videoDeviceLayer: SIPDeviceLayer { get }
	var srtp: SIPSRTP { get }
	var licenseKey: String { get }
}

public protocol SIPServiceCredentials {
	var userName: String { get }
	var password: String { get }
	var authName: String { get }
	var displayName: String { get }
}

public protocol SIPServer {
	var address: String { get }
	var port: Int32 { get }
}

public protocol SIPServiceAccountConfiguration {

	var sipServer: SIPServer { get }
	var credentials: SIPServiceCredentials { get }
	var localServer: SIPServer { get }
	var userDomain: String { get }
	var stunServer: SIPServer { get }
	var outboundServer: SIPServer { get }
}

public struct DefaultSIPServiceCredentials: SIPServiceCredentials {
	public let userName: String
	public let password: String
	public let authName: String
	public let displayName: String
}

public struct DefaultSIPServer: SIPServer {
	public let address: String
	public let port: Int32

	public init(address: String = "", port: Int32 = 0) {
		self.address = address
		self.port = port
	}
}

public struct DefaultLocalServer: SIPServer {
	public let address: String
	public let port: Int32

	public init(address: String = "0.0.0.0", port: Int32 = (Int32(10000 + arc4random()) % 1000)) {
		self.address = address
		self.port = port
	}
}

public struct DefaultSIPServiceConfiguration: SIPServiceAccountConfiguration {
	public let sipServer: SIPServer
	public let credentials: SIPServiceCredentials

	public let localServer: SIPServer
	public let userDomain: String
	public let stunServer: SIPServer
	public let outboundServer: SIPServer

	public init(
			sipServer: SIPServer,
			credentials: SIPServiceCredentials,
			localServer: SIPServer = DefaultLocalServer(),
			userDomain: String = "",
			stunServer: SIPServer = DefaultSIPServer(),
			outboundServer: SIPServer = DefaultSIPServer()) {
		self.sipServer = sipServer
		self.credentials = credentials
		self.localServer = localServer
		self.userDomain = userDomain
		self.stunServer = stunServer
		self.outboundServer = outboundServer
	}

}

public enum SIPServiceStatus {
	case disconnected
	case connecting
	case connected
	case disconnecting
}

public protocol SIPService {

	// MARK: Initialisation and registration

	func initialise(withConfiguration config: SIPServiceConfiguration) throws
	func deinitialise()
	func authenticate(_ account: SIPServiceAccountConfiguration) throws

	func register(expires: Int32, retries: Int32) throws
	func unregister() throws

	var isInitialised: Bool { get }
	func refreshInterval(_ interval: Int32) throws
	var isRegistered: Bool { get }

	var status: SIPServiceStatus { get }

//	var isConnected: Bool { get set }

	var nicManager: SIPNICManager { get }
	var sessionManager: SIPSessionManager { get }

	// MARK: Codec support

	var audioCodeManager: AudioCodecManager { get }
	var videoCodeManager: VideoCodecManager { get }

	var isSpeakerOn: Bool { get set }
	var isKeepAwake: Bool { get set }
	var isMicroPhoneMuted: Bool { get set }
	var isSpeakerMuted: Bool { get set }

}

public struct SIPServiceManager {
	public static let shared: SIPService = MutableSIPServiceManager.shared
}

/**
This is a mutable service manager designed to provide a testable entry point
*/
public struct MutableSIPServiceManager {
	public static var shared: SIPService = DefaultSIPService()
}

public enum SIPError: Error {
	case initializationError(code: Int32)
	case authenticationFailed(code: Int32)
	case apiCallFailedWith(code: Int32)
	case notInitialisedYet

}

public protocol SIPReason {
	var reason: String {get}
	var code: Int32 {get}
}

struct DefaultSIPReason: SIPReason {
	let reason: String
	let code: Int32
}

protocol SIPSupportManager {
	var portSIPSDK: PortSIPSDK { get }
}

public class DefaultSIPSupportManager: SIPSupportManager {
	let portSIPSDK: PortSIPSDK

	init(portSIPSDK: PortSIPSDK) {
		self.portSIPSDK = portSIPSDK
	}
}

class DefaultSIPService: NSObject, SIPService {

	var portSIPSDK: PortSIPSDK!

	override init() {
		super.init()
		portSIPSDK = PortSIPSDK()
	}

	private(set) var isInitialised: Bool = false

	func initialise(withConfiguration config: SIPServiceConfiguration) throws {
		guard !isInitialised else {
			return
		}

		var ret = portSIPSDK.initialize(
				config.transportProtocol.type,
				loglevel: config.logLevel.type,
				logPath: config.logFilePath,
				maxLine: config.maxCallLines,
				agent: config.sipAgent,
				audioDeviceLayer: config.audioDeviceLayer.rawValue,
				videoDeviceLayer: config.videoDeviceLayer.rawValue)
		guard ret == 0 else {
			throw SIPError.initializationError(code: ret)
		}

		portSIPSDK.setSrtpPolicy(config.srtp.type);

		ret = portSIPSDK.setLicenseKey(config.licenseKey)
		guard ret == 0 else {
			deinitialise()
			throw SIPError.initializationError(code: ret)
		}

		isInitialised = true
	}

	func deinitialise() {
		defer {
			isInitialised = false
		}
		status = .disconnected
		portSIPSDK.unInitialize()
	}

	func authenticate(_ account: SIPServiceAccountConfiguration) throws {
		let ret = portSIPSDK.setUser(
				account.credentials.userName,
				displayName: account.credentials.displayName,
				authName: account.credentials.authName,
				password: account.credentials.password,
				localIP: account.localServer.address,
				localSIPPort: account.localServer.port,
				userDomain: account.userDomain,
				sipServer: account.sipServer.address,
				sipServerPort: account.sipServer.port,
				stunServer: account.stunServer.address,
				stunServerPort: account.stunServer.port,
				outboundServer: account.outboundServer.address,
				outboundServerPort: account.outboundServer.port);

		if (ret != 0) {
			throw SIPError.authenticationFailed(code: ret)
		}
	}

	private(set) var isRegistered: Bool = false

	func register(expires: Int32, retries: Int32) throws {
		guard isInitialised else {
			status = .disconnected
			throw SIPError.notInitialisedYet
		}
		status = .connecting
		let result = portSIPSDK.registerServer(expires, retryTimes: retries)
		guard result == 0 else {
			deinitialise()
			throw SIPError.apiCallFailedWith(code: result)
		}
		status = .connected
		isRegistered = true
	}

	func unregister() throws {
		status = .disconnecting
		let result = portSIPSDK.unRegisterServer()
		status = .disconnected
		guard result == 0 else {
			deinitialise()
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func refreshInterval(_ interval: Int32) throws {
		let result = portSIPSDK.refreshRegisterServer(interval)
		guard result == 0 else {
			deinitialise()
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	var status: SIPServiceStatus = .disconnected

	var nicManager: SIPNICManager {
		return DefaultSIPNICManager(portSIPSDK: portSIPSDK)
	}
	var sessionManager: SIPSessionManager {
		return DefaultSIPSessionManager(portSIPSDK: portSIPSDK)
	}

	var audioCodeManager: AudioCodecManager {
		return AudioCodecManager(portSIPSDK: portSIPSDK)
	}

	var videoCodeManager: VideoCodecManager {
		return VideoCodecManager(portSIPSDK: portSIPSDK)
	}

	var isSpeakerOn: Bool = false {
		didSet {
			if portSIPSDK.setLoudspeakerStatus(isSpeakerOn) != 0 && isSpeakerOn {
				isSpeakerOn = false
			}
		}
	}

	var isKeepAwake: Bool = false {
		didSet {
			if isKeepAwake {
				isKeepAwake = portSIPSDK.startKeepAwake()
			} else {
				portSIPSDK.stopKeepAwake()
			}
		}
	}

	var isMicroPhoneMuted: Bool = false {
		didSet {
			portSIPSDK.muteMicrophone(isMicroPhoneMuted)
		}
	}

	var isSpeakerMuted: Bool = false {
		didSet {
			portSIPSDK.muteSpeaker(isSpeakerMuted)
		}
	}

}

public protocol SIPRegistrationStatus {
	var text: String { get }
	var code: Int32 { get }
}

struct DefaultSIPRegistrationStatus: SIPRegistrationStatus {
	let text: String
	let code: Int32
}

extension DefaultSIPService: PortSIPEventDelegate {

	func string(from text: UnsafeMutablePointer<Int8>!) -> String {
		return String.init(validatingUTF8: text)!
	}

	func audioCodecsFrom(_ text: UnsafeMutablePointer<Int8>!) -> [SIPAudioCodec] {
		let items = string(from: text)
		return audioCodecsFrom(items)
	}

	func audioCodecsFrom(_ text: String) -> [SIPAudioCodec] {
		let items = text.characters.split(separator: "#").map(String.init)
		return SIPAudioCodec.from(items)
	}

	func videoCodecsFrom(_ text: UnsafeMutablePointer<Int8>!) -> [SIPVideoCodec] {
		let items = string(from: text)
		return videoCodecsFrom(items)
	}

	func videoCodecsFrom(_ text: String) -> [SIPVideoCodec] {
		let items = text.characters.split(separator: "#").map(String.init)
		return SIPVideoCodec.from(items)
	}

	func notify(_ status: SIPRegistrationStatus, with name: NSNotification.Name) {
		let userInfo: [String: Any] = [
			SIPNotification.Register.Key.status: status
		]

		NotificationCenter.default.post(
				name: name,
				object: self,
				userInfo: userInfo)
	}

	public func onRegisterSuccess(_ statusText: UnsafeMutablePointer<Int8>!, statusCode: Int32) {
		let status = DefaultSIPRegistrationStatus(
				text: String.init(validatingUTF8: statusText)!,
				code: statusCode)

		notify(status, with: SIPNotification.Register.success)
	}

	public func onRegisterFailure(_ statusText: UnsafeMutablePointer<Int8>!, statusCode: Int32) {
		let status = DefaultSIPRegistrationStatus(
				text: String.init(validatingUTF8: statusText)!,
				code: statusCode)

		notify(status, with: SIPNotification.Register.failure)
	}

	public func onInviteIncoming(
			_ sessionId: Int,
			callerDisplayName: UnsafeMutablePointer<Int8>!,
			caller: UnsafeMutablePointer<Int8>!,
			calleeDisplayName: UnsafeMutablePointer<Int8>!,
			callee: UnsafeMutablePointer<Int8>!,
			audioCodecs: UnsafeMutablePointer<Int8>!,
			videoCodecs: UnsafeMutablePointer<Int8>!,
			existsAudio: Bool,
			existsVideo: Bool) {
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}

		let audioCodecItems = audioCodecsFrom(audioCodecs)
		let videoCodecItems = videoCodecsFrom(videoCodecs)

		do {
			let session = try manager.addSession(
					id: sessionId,
					type: .incoming,
					status: .ringing,
					callerDisplayName: string(from: callerDisplayName),
					caller: string(from: caller),
					calleeDisplayName: string(from: calleeDisplayName),
					callee: string(from: callee),
					audioCodecs: audioCodecItems,
					videoCodecs: videoCodecItems,
					includesAudio: existsAudio,
					includesVideo: existsVideo)

			let userInfo: [String: Any] = [
				SIPNotification.Call.Key.session: session
			]

			NotificationCenter.default.post(
					name: SIPNotification.Call.incoming,
					object: self,
					userInfo: userInfo)
		} catch let error {
			let userInfo: [String: Any] = [
				SIPNotification.Call.Key.error: error
			]
			NotificationCenter.default.post(
					name: SIPNotification.Call.sessionError,
					object: self,
					userInfo: userInfo)
		}
	}

	internal func post(
			name: Notification.Name,
			session: SIPSession? = nil,
			info: [String: Any]? = nil) {

		var userInfo: [String: Any] = [:]

		if let session = session {
			userInfo[SIPNotification.Call.Key.session] = session
		}
		if let info = info {
			for value in info {
				userInfo[value.key] = value.value
			}
		}

		NotificationCenter.default.post(
				name: name,
				object: self,
				userInfo: userInfo)
	}

	// Out going call is been processed
	public func onInviteTrying(_ sessionId: Int) {
		// The session should already exist, otherwise people are doing the wrong thing
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		manager.update(session: session, status: .ringing)
		post(name: SIPNotification.Call.outgoing, session: session)
	}

	// Session in progress
	public func onInviteSessionProgress(
			_ sessionId: Int,
			audioCodecs: UnsafeMutablePointer<Int8>!,
			videoCodecs: UnsafeMutablePointer<Int8>!,
			existsEarlyMedia: Bool,
			existsAudio: Bool,
			existsVideo: Bool) {

		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}

		let audioList = audioCodecsFrom(audioCodecs)
		let videoList = videoCodecsFrom(videoCodecs)

		manager.update(
				session: session,
				audioCodecs: audioList,
				videoCodecs: videoList,
				includesEarlyMedia: existsEarlyMedia,
				includesAudio: existsAudio,
				includesVideo: existsAudio)

		post(name: SIPNotification.Call.progress, session: session)
	}

	// Outgoing call is ringing
	public func onInviteRinging(
			_ sessionId: Int,
			statusText: UnsafeMutablePointer<Int8>!,
			statusCode: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		manager.update(session: session, status: .ringing)
		let status = string(from: statusText)
		let reason = DefaultSIPReason(reason: status, code: statusCode)
		let statusInfo: [String: Any] = [
			SIPNotification.Call.Key.reason: reason,
		]
		post(
				name: SIPNotification.Call.outgoingRinging,
				session: session,
				info: [SIPNotification.Call.Key.session: statusInfo])
	}

	// Remote party is answering the call
	public func onInviteAnswered(
			_ sessionId: Int,
			callerDisplayName: UnsafeMutablePointer<Int8>!,
			caller: UnsafeMutablePointer<Int8>!,
			calleeDisplayName: UnsafeMutablePointer<Int8>!,
			callee: UnsafeMutablePointer<Int8>!,
			audioCodecs: UnsafeMutablePointer<Int8>!,
			videoCodecs: UnsafeMutablePointer<Int8>!,
			existsAudio: Bool,
			existsVideo: Bool) {
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		manager.update(
				session: session,
				callerDisplayName: string(from: callerDisplayName),
				caller: string(from: caller),
				calleeDisplayName: string(from: calleeDisplayName),
				callee: string(from: callee),
				audioCodecs: audioCodecsFrom(audioCodecs),
				videoCodecs: videoCodecsFrom(videoCodecs),
				includesAudio: existsAudio,
				includesVideo: existsVideo)
		post(name: SIPNotification.Call.answered, session: session)
	}

	public func onInviteFailure(_ sessionId: Int, reason: UnsafeMutablePointer<Int8>!, code: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		let info: [String: Any] = [
			SIPNotification.Call.Key.reason: DefaultSIPReason(reason: string(from: reason), code: code)
		]
		post(name: SIPNotification.Call.failed, session: session, info: info)
	}

	public func onInviteUpdated(
			_ sessionId: Int,
			audioCodecs: UnsafeMutablePointer<Int8>!,
			videoCodecs: UnsafeMutablePointer<Int8>!,
			existsAudio: Bool,
			existsVideo: Bool) {
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		manager.update(
				session: session,
				audioCodecs: audioCodecsFrom(audioCodecs),
				videoCodecs: videoCodecsFrom(videoCodecs),
				includesAudio: existsAudio,
				includesVideo: existsVideo)
		post(name: SIPNotification.Call.updated, session: session)
	}

	public func onInviteConnected(_ sessionId: Int) {
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		manager.update(session: session, status: .active)
		post(name: SIPNotification.Call.connected, session: session)
	}

	public func onInviteBeginingForward(_ forwardTo: UnsafeMutablePointer<Int8>!) {
		post(name: SIPNotification.Call.beginningForward)
	}

	public func onInviteClosed(_ sessionId: Int) {
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		manager.update(session: session, status: SIPSessionStatus.inactive)
		manager.remove(session)
		post(name: SIPNotification.Call.closed, session: session)
	}

	public func onRemoteHold(_ sessionId: Int) {
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		manager.update(session: session, status: SIPSessionStatus.onHold)
		post(name: SIPNotification.Call.remoteHold, session: session)
	}

	public func onRemoteUnHold(_ sessionId: Int, audioCodecs: UnsafeMutablePointer<Int8>!, videoCodecs: UnsafeMutablePointer<Int8>!, existsAudio: Bool, existsVideo: Bool) {
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		manager.update(session: session, status: SIPSessionStatus.active)
		post(name: SIPNotification.Call.remoteUnHold, session: session)
	}

	public func onReceivedRefer(
			_ sessionId: Int,
			referId: Int,
			to: UnsafeMutablePointer<Int8>!,
			from: UnsafeMutablePointer<Int8>!,
			referSipMessage: UnsafeMutablePointer<Int8>!) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let info: [String: Any] = [
			SIPNotification.Refer.Key.referral:
			DefaultSIPReferral(
					id: referId,
					to: string(from: to),
					from: string(from: from),
					message: string(from: referSipMessage))
		]
		post(name: SIPNotification.Refer.received, session: session, info: info)
	}

	public func onReferAccepted(_ sessionId: Int) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		post(name: SIPNotification.Refer.accepted, session: session)
	}

	public func onReferRejected(_ sessionId: Int, reason: UnsafeMutablePointer<Int8>!, code: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let info: [String: Any] = [
			SIPNotification.Refer.Key.reason: DefaultSIPReason(reason: string(from: reason), code: code)
		]
		post(name: SIPNotification.Refer.accepted, session: session, info: info)
	}

	public func onTransferTrying(_ sessionId: Int) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		manager.update(session: session, status: .ringing)
		post(name: SIPNotification.Refer.transferTrying, session: session)
	}

	public func onTransferRinging(_ sessionId: Int) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		manager.update(session: session, status: .ringing)
		post(name: SIPNotification.Refer.transferRinging, session: session)
	}

	public func onACTVTransferSuccess(_ sessionId: Int) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		manager.update(session: session, status: .active)
		post(name: SIPNotification.Refer.success, session: session)
	}

	public func onACTVTransferFailure(_ sessionId: Int, reason: UnsafeMutablePointer<Int8>!, code: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		guard let manager = sessionManager as? MutableSIPSessionManager else {
			return
		}
		manager.update(session: session, status: .active) //?
		let info: [String: Any] = [
			SIPNotification.Refer.Key.reason: DefaultSIPReason(reason: string(from: reason), code: code)
		]
		post(name: SIPNotification.Refer.failure, session: session, info: info)
	}

	public func onReceivedSignaling(_ sessionId: Int, message: UnsafeMutablePointer<Int8>!) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let info: [String: Any] = [
			SIPNotification.Signaling.Key.message: string(from: message)
		]
		post(name: SIPNotification.Signaling.received, session: session, info: info)
	}

	public func onSendingSignaling(_ sessionId: Int, message: UnsafeMutablePointer<Int8>!) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let info: [String: Any] = [
			SIPNotification.Signaling.Key.message: string(from: message)
		]
		post(name: SIPNotification.Signaling.sending, session: session, info: info)
	}

	public func onWaitingVoiceMessage(
			_ messageAccount: UnsafeMutablePointer<Int8>!,
			urgentNewMessageCount: Int32,
			urgentOldMessageCount: Int32,
			newMessageCount: Int32,
			oldMessageCount: Int32) {
		let message = DefaultSIPWaitingMessage(
				messageAccount: string(from: messageAccount),
				urgentNewMessageCount: urgentNewMessageCount,
				urgentOldMessageCount: urgentOldMessageCount,
				newMessageCount: newMessageCount,
				oldMessageCount: oldMessageCount)
		let info: [String: Any] = [
			SIPNotification.MessageWaitingIndicator.Key.status: message
		]
		post(name: SIPNotification.MessageWaitingIndicator.voiceMessage, info: info)
	}

	public func onWaitingFaxMessage(
			_ messageAccount: UnsafeMutablePointer<Int8>!,
			urgentNewMessageCount: Int32,
			urgentOldMessageCount: Int32,
			newMessageCount: Int32,
			oldMessageCount: Int32) {
		let message = DefaultSIPWaitingMessage(
				messageAccount: string(from: messageAccount),
				urgentNewMessageCount: urgentNewMessageCount,
				urgentOldMessageCount: urgentOldMessageCount,
				newMessageCount: newMessageCount,
				oldMessageCount: oldMessageCount)
		let info: [String: Any] = [
			SIPNotification.MessageWaitingIndicator.Key.status: message
		]
		post(name: SIPNotification.MessageWaitingIndicator.faxMessage, info: info)
	}

	public func onRecvDtmfTone(_ sessionId: Int, tone: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		guard let dtmfTone = DTMFTone(rawValue: tone) else {
			return
		}
		let info: [String: Any] = [
			SIPNotification.DTMF.Key.tone: dtmfTone
		]
		post(name: SIPNotification.DTMF.received, session: session, info: info)
	}

	public func onRecvOptions(_ optionsMessage: UnsafeMutablePointer<Int8>!) {
		let message = string(from: optionsMessage)
		let info: [String: Any] = [
			SIPNotification.Options.Key.message: message
		]
		post(name: SIPNotification.Options.received, info: info)
	}

	public func onRecvInfo(_ infoMessage: UnsafeMutablePointer<Int8>!) {
		let message = string(from: infoMessage)
		let info: [String: Any] = [
			SIPNotification.Info.Key.message: message
		]
		post(name: SIPNotification.Info.received, info: info)
	}

	public func onPresenceRecvSubscribe(
			_ subscribeId: Int,
			fromDisplayName: UnsafeMutablePointer<Int8>!,
			from: UnsafeMutablePointer<Int8>!,
			subject: UnsafeMutablePointer<Int8>!) {

		let message = DefaultSIPPresenceSubscription(
				id: subscribeId,
				subject: string(from: subject),
				name: string(from: fromDisplayName),
				number: string(from: from))
		let info: [String: Any] = [
			SIPNotification.Presence.Key.message: message
		]
		post(name: SIPNotification.Presence.receivedSubscription, info: info)
	}

	public func onPresenceOnline(
			_ fromDisplayName: UnsafeMutablePointer<Int8>!,
			from: UnsafeMutablePointer<Int8>!,
			stateText: UnsafeMutablePointer<Int8>!) {
		let message = DefaultSIPPresenceOnline(
				stateText: string(from: stateText),
				name: string(from: fromDisplayName),
				number: string(from: from))
		let info: [String: Any] = [
			SIPNotification.Presence.Key.message: message
		]
		post(name: SIPNotification.Presence.online, info: info)
	}

	public func onPresenceOffline(
			_ fromDisplayName: UnsafeMutablePointer<Int8>!,
			from: UnsafeMutablePointer<Int8>!) {
		let message = DefaultSIPPresence(
				name: string(from: fromDisplayName),
				number: string(from: from))
		let info: [String: Any] = [
			SIPNotification.Presence.Key.message: message
		]
		post(name: SIPNotification.Presence.offline, info: info)
	}

	public func onRecvMessage(
			_ sessionId: Int,
			mimeType: UnsafeMutablePointer<Int8>!,
			subMimeType: UnsafeMutablePointer<Int8>!,
			messageData: UnsafeMutablePointer<UInt8>!,
			messageDataLength: Int32) {
		let data = Data(bytes: messageData, count: Int(messageDataLength))
		let message = DefaultSIPMessage(
				mimeType: string(from: mimeType),
				subMimeType: string(from: subMimeType),
				data: data)
		let info: [String: Any] = [
			SIPNotification.Message.Key.message: message
		]
		post(name: SIPNotification.Message.received, info: info)
	}

	public func onRecvOutOfDialogMessage(
			_ fromDisplayName: UnsafeMutablePointer<Int8>!,
			from: UnsafeMutablePointer<Int8>!,
			toDisplayName: UnsafeMutablePointer<Int8>!,
			to: UnsafeMutablePointer<Int8>!,
			mimeType: UnsafeMutablePointer<Int8>!,
			subMimeType: UnsafeMutablePointer<Int8>!,
			messageData: UnsafeMutablePointer<UInt8>!,
			messageDataLength: Int32) {
		let data = Data(bytes: messageData, count: Int(messageDataLength))
		let message = DefaultSIPOutOfDialogMessageWithData(
				fromName: string(from: fromDisplayName),
				fromNumber: string(from: from),
				toName: string(from: toDisplayName),
				toNumber: string(from: to),
				mimeType: string(from: mimeType),
				subMimeType: string(from: subMimeType),
				data: data)
		let info: [String: Any] = [
			SIPNotification.Message.Key.message: message
		]
		post(name: SIPNotification.Message.receivedOutOfDialog, info: info)
	}

	public func onSendMessageSuccess(_ sessionId: Int, messageId: Int) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let info: [String: Any] = [
			SIPNotification.Message.Key.id: messageId
		]
		post(name: SIPNotification.Message.sendSuccessful, session: session, info: info)
	}

	public func onSendMessageFailure(
			_ sessionId: Int,
			messageId: Int,
			reason: UnsafeMutablePointer<Int8>!,
			code: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let reason = DefaultSIPMessageReason(
				id: messageId,
				reason: string(from: reason),
				code: code)
		let info: [String: Any] = [
			SIPNotification.Message.Key.reason: reason
		]
		post(name: SIPNotification.Message.sendFailure, session: session, info: info)
	}

	public func onSendOutOfDialogMessageSuccess(
			_ messageId: Int,
			fromDisplayName: UnsafeMutablePointer<Int8>!,
			from: UnsafeMutablePointer<Int8>!,
			toDisplayName: UnsafeMutablePointer<Int8>!,
			to: UnsafeMutablePointer<Int8>!) {
		let message = DefaultSIPOutOfDialogMessage(
				id: messageId,
				fromName: string(from: fromDisplayName),
				fromNumber: string(from: from),
				toName: string(from: toDisplayName),
				toNumber: string(from: to))
		let info: [String: Any] = [
			SIPNotification.Message.Key.message: message
		]
		post(name: SIPNotification.Message.sendOutOfDialogSuccess, info: info)
	}

	public func onSendOutOfDialogMessageFailure(
			_ messageId: Int,
			fromDisplayName: UnsafeMutablePointer<Int8>!,
			from: UnsafeMutablePointer<Int8>!,
			toDisplayName: UnsafeMutablePointer<Int8>!,
			to: UnsafeMutablePointer<Int8>!,
			reason: UnsafeMutablePointer<Int8>!,
			code: Int32) {
		let message = DefaultSIPOutOfDialogMessage(
				id: messageId,
				fromName: string(from: fromDisplayName),
				fromNumber: string(from: from),
				toName: string(from: toDisplayName),
				toNumber: string(from: to))
		let reason = DefaultSIPReason(
				reason: string(from: reason),
				code: code)
		let info: [String: Any] = [
			SIPNotification.Message.Key.message: message,
			SIPNotification.Message.Key.reason: reason
		]
		post(name: SIPNotification.Message.sendOutOfDialogSuccess, info: info)
	}

	public func onPlayAudioFileFinished(_ sessionId: Int, fileName: UnsafeMutablePointer<Int8>!) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let info: [String: Any] = [
			SIPNotification.Play.Key.fileName: fileName
		]
		post(name: SIPNotification.Play.audioFileFinished, session: session, info: info)
	}

	public func onPlayVideoFileFinished(_ sessionId: Int) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		post(name: SIPNotification.Play.videoFileFinished, session: session)
	}

	public func onReceivedRTPPacket(
			_ sessionId: Int,
			isAudio: Bool,
			rtpPacket: UnsafeMutablePointer<UInt8>!,
			packetSize: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let data = Data(bytes: rtpPacket, count: Int(packetSize))
		let info: [String: Any] = [
			SIPNotification.RTP.Key.data: data
		]
		post(name: SIPNotification.RTP.received, session: session, info: info)
	}

	public func onSendingRTPPacket(
			_ sessionId: Int,
			isAudio: Bool,
			rtpPacket: UnsafeMutablePointer<UInt8>!,
			packetSize: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let data = Data(bytes: rtpPacket, count: Int(packetSize))
		let info: [String: Any] = [
			SIPNotification.RTP.Key.data: data
		]
		post(name: SIPNotification.RTP.sending, session: session, info: info)
	}

	// This needs to pass the data to a delegate in real time...

	public func onAudioRawCallback(
			_ sessionId: Int,
			audioCallbackMode: Int32,
			data: UnsafeMutablePointer<UInt8>!,
			dataLength: Int32,
			samplingFreqHz: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let rawData = Data(bytes: data, count: Int(dataLength))
		let stream = DefaultSIPAudioStream(
				mode: audioCallbackMode,
				samplingFreqHz: samplingFreqHz,
				data: rawData)
	}

	public func onVideoRawCallback(
			_ sessionId: Int,
			videoCallbackMode: Int32,
			width: Int32,
			height: Int32,
			data: UnsafeMutablePointer<UInt8>!,
			dataLength: Int32) -> Int32 {
		guard let session = sessionManager.session(byID: sessionId) else {
			return 0
		}
		let rawData = Data(bytes: data, count: Int(dataLength))
		let stream = DefaultSIPVideoStream(
				mode: videoCallbackMode,
				width: width,
				height: height,
				data: rawData)
		return 0
	}

	public func onVideoDecoderCallback(
			_ sessionId: Int,
			width: Int32,
			height: Int32,
			framerate: Int32,
			bitrate: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			return
		}
		let message = DefaultSIPVideoDecoded(
				width: width,
				height: height,
				frameRate: framerate,
				bitRate: bitrate)
		let info: [String: Any] = [
			SIPNotification.Stream.Key.videoInfo: message
		]
		post(name: SIPNotification.Stream.videoDecoded, session: session, info: info)
	}

}

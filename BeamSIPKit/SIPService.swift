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
	}

	// Messaging?

	public struct Signaling {
		public static let received = Notification.Name("SIP.signaling.received")
		public static let sending = Notification.Name("SIP.signaling.sending")
	}

	// MWI

	public struct MessageWaitingIndicator {
		public static let voiceMessage = Notification.Name("SIP.mwi.voice")
		public static let faxMessage = Notification.Name("SIP.mwi.fax")
	}

	public struct DTMF {
		public static let received = Notification.Name("SIP.dtmf.received")
	}

	public struct Info {
		public static let received = Notification.Name("SIP.info.received")
	}

	public struct Options {
		public static let received = Notification.Name("SIP.options.received")
	}

	public struct Presence {
		public static let receivedSubscription = Notification.Name("SIP.presence.receivedSubscription")
		public static let online = Notification.Name("SIP.presence.online")
		public static let offline = Notification.Name("SIP.presence.offline")
	}

	public struct Message {
		public static let received = Notification.Name("SIP.message.received")
		public static let receivedOutOfDialog = Notification.Name("SIP.message.receivedOutOfDialog")
		public static let sendSuccessful = Notification.Name("SIP.message.sendSuccessful")
		public static let sendFailure = Notification.Name("SIP.message.sendFailure")
		public static let sendOutOfDialogSuccess = Notification.Name("SIP.message.sendOutOfDialogSuccess")
		public static let sendOutOfDialogFailure = Notification.Name("SIP.message.sendOutOfDialogFailure")
	}

	public struct Play {
		public static let audioFileFinished = Notification.Name("SIP.play.audioFileFinished")
		public static let videoFileFinished = Notification.Name("SIP.play.videoFileFinished")
	}

	public struct RTP {
		public static let received = Notification.Name("SIP.rtp.audioFileFinished")
		public static let sending = Notification.Name("SIP.rtp.videoFileFinished")
	}

	public struct Stream {
		public static let audio = Notification.Name("SIP.stream.audio")
		public static let video = Notification.Name("SIP.stream.video")
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

	public init(address: String = "0.0.0.0", port: Int32 = ((10000 + Int(arc4random())) % 1000)) {
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

		do {
			let session = try manager.addSession(
					id: sessionId,
					type: .incoming,
					callerDisplayName: string(from: callerDisplayName),
					caller: string(from: caller),
					calleeDisplayName: string(from: calleeDisplayName),
					callee: string(from: callee),
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

	internal func post(name: Notification.Name, session: SIPSession) {
		let userInfo: [String: Any] = [
			SIPNotification.Call.Key.session: session
		]

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
		post(name: SIPNotification.Call.outgoing, session: session)
	}

	// Session in progress
	public func onInviteSessionProgress(_ sessionId: Int,
	                                    audioCodecs: UnsafeMutablePointer<Int8>!,
	                                    videoCodecs: UnsafeMutablePointer<Int8>!,
	                                    existsEarlyMedia: Bool,
	                                    existsAudio: Bool,
	                                    existsVideo: Bool) {

		let audioList = string(from: audioCodecs)
		let videoList = string(from: videoCodecs)

		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		let audioCodecsItems = audioList.characters.split(separator: "#").map(String.init)
		let videoCodecsItems = videoList.characters.split(separator: "#").map(String.init)
		sessionManager.update(
				session: session,
				audioCodecs: audioCodecsItems,
				videoCodecs: videoCodecsItems,
				existsEarlyMedia: existsEarlyMedia,
				includesAudio: existsAudio,
				includesVideo: existsVideo)
		post(name: SIPNotification.Call.progress, session: session)
	}

	// Outgoing call is ringing
	public func onInviteRinging(_ sessionId: Int,
	                            statusText: UnsafeMutablePointer<Int8>!,
	                            statusCode: Int32) {
		let status = string(from: statusText)
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		post(name: SIPNotification.Call.outgoingRinging, session: session)
	}

	// Remote party is answering the call
	public func onInviteAnswered(_ sessionId: Int,
	                             callerDisplayName: UnsafeMutablePointer<Int8>!,
	                             caller: UnsafeMutablePointer<Int8>!,
	                             calleeDisplayName: UnsafeMutablePointer<Int8>!,
	                             callee: UnsafeMutablePointer<Int8>!,
	                             audioCodecs: UnsafeMutablePointer<Int8>!,
	                             videoCodecs: UnsafeMutablePointer<Int8>!,
	                             existsAudio: Bool,
	                             existsVideo: Bool) {
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		if let manager = sessionManager as? DefaultSIPSessionManager {
			manager.update(
					session: session,
					callerDisplayName: string(from: callerDisplayName),
					caller: string(from: caller),
					calleeDisplayName: string(from: calleeDisplayName),
					callee: string(from: callee),
					includesAudio: existsAudio,
					includesVideo: existsVideo)
		}
		post(name: SIPNotification.Call.outgoingRinging, session: session)
	}

	public func onInviteFailure(_ sessionId: Int, reason: UnsafeMutablePointer<Int8>!, code: Int32) {
		guard let session = sessionManager.session(byID: sessionId) else {
			// WTF?
			return
		}
		post(name: SIPNotification.Call.failed, session: session)
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
		guard let manager = sessionManager as? DefaultSIPSessionManager else {
			return
		}
		manager.update(
				session: session,
				callerDisplayName: string(from: callerDisplayName),
				caller: string(from: caller),
				calleeDisplayName: string(from: calleeDisplayName),
				callee: string(from: callee),
				includesAudio: existsAudio,
				includesVideo: existsVideo)
	}

	public func onInviteConnected(_ sessionId: Int) {
	}

	public func onInviteBeginingForward(_ forwardTo: UnsafeMutablePointer<Int8>!) {
	}

	public func onInviteClosed(_ sessionId: Int) {
	}

	public func onRemoteHold(_ sessionId: Int) {
	}

	public func onRemoteUnHold(_ sessionId: Int, audioCodecs: UnsafeMutablePointer<Int8>!, videoCodecs: UnsafeMutablePointer<Int8>!, existsAudio: Bool, existsVideo: Bool) {
	}

	public func onReceivedRefer(_ sessionId: Int, referId: Int, to: UnsafeMutablePointer<Int8>!, from: UnsafeMutablePointer<Int8>!, referSipMessage: UnsafeMutablePointer<Int8>!) {
	}

	public func onReferAccepted(_ sessionId: Int) {
	}

	public func onReferRejected(_ sessionId: Int, reason: UnsafeMutablePointer<Int8>!, code: Int32) {
	}

	public func onTransferTrying(_ sessionId: Int) {
	}

	public func onTransferRinging(_ sessionId: Int) {
	}

	public func onACTVTransferSuccess(_ sessionId: Int) {
	}

	public func onACTVTransferFailure(_ sessionId: Int, reason: UnsafeMutablePointer<Int8>!, code: Int32) {
	}

	public func onReceivedSignaling(_ sessionId: Int, message: UnsafeMutablePointer<Int8>!) {
	}

	public func onSendingSignaling(_ sessionId: Int, message: UnsafeMutablePointer<Int8>!) {
	}

	public func onWaitingVoiceMessage(_ messageAccount: UnsafeMutablePointer<Int8>!, urgentNewMessageCount: Int32, urgentOldMessageCount: Int32, newMessageCount: Int32, oldMessageCount: Int32) {
	}

	public func onWaitingFaxMessage(_ messageAccount: UnsafeMutablePointer<Int8>!, urgentNewMessageCount: Int32, urgentOldMessageCount: Int32, newMessageCount: Int32, oldMessageCount: Int32) {
	}

	public func onRecvDtmfTone(_ sessionId: Int, tone: Int32) {
	}

	public func onRecvOptions(_ optionsMessage: UnsafeMutablePointer<Int8>!) {
	}

	public func onRecvInfo(_ infoMessage: UnsafeMutablePointer<Int8>!) {
	}

	public func onPresenceRecvSubscribe(_ subscribeId: Int, fromDisplayName: UnsafeMutablePointer<Int8>!, from: UnsafeMutablePointer<Int8>!, subject: UnsafeMutablePointer<Int8>!) {
	}

	public func onPresenceOnline(_ fromDisplayName: UnsafeMutablePointer<Int8>!, from: UnsafeMutablePointer<Int8>!, stateText: UnsafeMutablePointer<Int8>!) {
	}

	public func onPresenceOffline(_ fromDisplayName: UnsafeMutablePointer<Int8>!, from: UnsafeMutablePointer<Int8>!) {
	}

	public func onRecvMessage(_ sessionId: Int, mimeType: UnsafeMutablePointer<Int8>!, subMimeType: UnsafeMutablePointer<Int8>!, messageData: UnsafeMutablePointer<UInt8>!, messageDataLength: Int32) {
	}

	public func onRecvOutOfDialogMessage(_ fromDisplayName: UnsafeMutablePointer<Int8>!, from: UnsafeMutablePointer<Int8>!, toDisplayName: UnsafeMutablePointer<Int8>!, to: UnsafeMutablePointer<Int8>!, mimeType: UnsafeMutablePointer<Int8>!, subMimeType: UnsafeMutablePointer<Int8>!, messageData: UnsafeMutablePointer<UInt8>!, messageDataLength: Int32) {
	}

	public func onSendMessageSuccess(_ sessionId: Int, messageId: Int) {
	}

	public func onSendMessageFailure(_ sessionId: Int, messageId: Int, reason: UnsafeMutablePointer<Int8>!, code: Int32) {
	}

	public func onSendOutOfDialogMessageSuccess(_ messageId: Int, fromDisplayName: UnsafeMutablePointer<Int8>!, from: UnsafeMutablePointer<Int8>!, toDisplayName: UnsafeMutablePointer<Int8>!, to: UnsafeMutablePointer<Int8>!) {
	}

	public func onSendOutOfDialogMessageFailure(_ messageId: Int, fromDisplayName: UnsafeMutablePointer<Int8>!, from: UnsafeMutablePointer<Int8>!, toDisplayName: UnsafeMutablePointer<Int8>!, to: UnsafeMutablePointer<Int8>!, reason: UnsafeMutablePointer<Int8>!, code: Int32) {
	}

	public func onPlayAudioFileFinished(_ sessionId: Int, fileName: UnsafeMutablePointer<Int8>!) {
	}

	public func onPlayVideoFileFinished(_ sessionId: Int) {
	}

	public func onReceivedRTPPacket(_ sessionId: Int, isAudio: Bool, rtpPacket RTPPacket: UnsafeMutablePointer<UInt8>!, packetSize: Int32) {
	}

	public func onSendingRTPPacket(_ sessionId: Int, isAudio: Bool, rtpPacket RTPPacket: UnsafeMutablePointer<UInt8>!, packetSize: Int32) {
	}

	public func onAudioRawCallback(_ sessionId: Int, audioCallbackMode: Int32, data: UnsafeMutablePointer<UInt8>!, dataLength: Int32, samplingFreqHz: Int32) {
	}

	public func onVideoRawCallback(_ sessionId: Int, videoCallbackMode: Int32, width: Int32, height: Int32, data: UnsafeMutablePointer<UInt8>!, dataLength: Int32) -> Int32 {
		return 0
	}

	public func onVideoDecoderCallback(_ sessionId: Int, width: Int32, height: Int32, framerate: Int32, bitrate: Int32) {
	}

}

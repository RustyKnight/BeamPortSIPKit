//
// Created by Shane Whitehead on 9/6/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public protocol AudioManager {
	func setAudioBitRate(session: SIPSession, codecType: SIPAudioCodec, kbps: Int32) throws

	var isSpeakerOn: Bool { get set }
	var isMicroPhoneMuted: Bool { get set }
	var isSpeakerMuted: Bool { get set }

	var speakerDynamicVolume: Int32 { get }
	var microPhoneDynamicVolume: Int32 { get }

	func channelOutputVolumeScaling(_ scale: Int32, for session: SIPSession) throws
}

class DefaultAudioManager: DefaultSIPSupportManager, AudioManager {

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	func setAudioBitRate(session: SIPSession, codecType: SIPAudioCodec, kbps: Int32) throws {
		let result = portSIPSDK.setAudioBitrate(session.id, codecType: codecType.type, bitrateKbps: kbps)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	internal var dynamicVolumeLevel: (speaker: Int32, microphone: Int32) {
		var speaker: Int32 = 0
		var microphone: Int32 = 0
		portSIPSDK.getDynamicVolumeLevel(&speaker, microphoneVolume: &microphone)

		return (speaker: speaker, microphone: microphone)
	}

	var speakerDynamicVolume: Int32 {
		return dynamicVolumeLevel.speaker
	}

	var microPhoneDynamicVolume: Int32 {
		return dynamicVolumeLevel.microphone
	}

	func channelOutputVolumeScaling(_ scale: Int32, for session: SIPSession) throws {
		let value = min(1000, max(0, scale))
		let result = portSIPSDK.setChannelOutputVolumeScaling(session.id, scaling: value)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	var isSpeakerOn: Bool = false {
		didSet {
			if portSIPSDK.setLoudspeakerStatus(isSpeakerOn) != 0 && isSpeakerOn {
				isSpeakerOn = false
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
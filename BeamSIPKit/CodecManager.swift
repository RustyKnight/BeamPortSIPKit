//
// Created by Shane Whitehead on 9/3/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public protocol CodecManager {
	associatedtype Codec

	var isEmpty: Bool {get}

	func add(codec: Codec)
	func clear()

	// I have no idea what the type actually is
	func setPayloadType(forCodec: Codec, to type: Int32)
	func setParameter(forCodec: Codec, to: String)
}

public class AudioCodecManager: DefaultSIPSupportManager, CodecManager {
	public typealias Codec = SIPAudioCodec

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	public var isEmpty: Bool {
		return portSIPSDK.isAudioCodecEmpty()
	}

	public func add(codec: SIPAudioCodec) {
		portSIPSDK.addAudioCodec(codec.type)
	}

	public func clear() {
		portSIPSDK.clearAudioCodec()
	}

	public func setPayloadType(forCodec codec: SIPAudioCodec, to type: Int32) {
		portSIPSDK.setAudioCodecPayloadType(codec.type, payloadType: type)
	}

	public func setParameter(forCodec codec: SIPAudioCodec, to: String) {
		portSIPSDK.setAudioCodecParameter(codec.type, parameter: to)
	}
}

public class VideoCodecManager: DefaultSIPSupportManager, CodecManager {

	public typealias Codec = SIPVideoCodec

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	public var isEmpty: Bool {
		return portSIPSDK.isAudioCodecEmpty()
	}

	public func add(codec: SIPVideoCodec) {
		portSIPSDK.addVideoCodec(codec.type)
	}

	public func clear() {
		portSIPSDK.clearAudioCodec()
	}

	public func setPayloadType(forCodec codec: SIPVideoCodec, to type: Int32) {
		portSIPSDK.setVideoCodecPayloadType(codec.type, payloadType: type)
	}

	public func setParameter(forCodec codec: SIPVideoCodec, to: String) {
		portSIPSDK.setVideoCodecParameter(codec.type, parameter: to)
	}
}

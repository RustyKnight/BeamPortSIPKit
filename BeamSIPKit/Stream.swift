//
// Created by Shane Whitehead on 8/6/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation

public protocol SIPStream {
	var mode: Int32 {get}
	var data: Data {get}
}

public protocol SIPAudioStream: SIPStream {
	var samplingFreqHz: Int32 {get}
}

public protocol SIPVideoStream: SIPStream {
	var width: Int32 {get}
	var height: Int32 {get}
}

struct DefaultSIPAudioStream: SIPAudioStream {
	let mode: Int32
	let samplingFreqHz: Int32
	let data: Data
}

struct DefaultSIPVideoStream: SIPVideoStream {
	let mode: Int32
	let width: Int32
	let height: Int32
	let data: Data
}

public protocol SIPVideoDecoded {
	var width: Int32 {get}
	var height: Int32 {get}
	var frameRate: Int32 {get}
	var bitRate: Int32 {get}
}

struct DefaultSIPVideoDecoded: SIPVideoDecoded {
	let width: Int32
	let height: Int32
	let frameRate: Int32
	let bitRate: Int32
}

Class {
	#name : #SOLockableStreamTest,
	#superclass : #TestCase,
	#instVars : [
		'stream'
	],
	#category : #'Soil-File-Tests'
}

{ #category : #running }
SOLockableStreamTest >> tearDown [ 
	super tearDown.
	stream close.
	stream := nil
]

{ #category : #tests }
SOLockableStreamTest >> testMemoryLock [
	| objA objB registry |
	objA := Object new.
	objB := Object new.
	stream := (SOLockableStream path: '/tmp/soil-lock-test') lockOnlyInImage.
	stream nextPutAll: 'hello world'.
	stream lockFrom: 7 to: 12 for: objA.
	self assert: stream locks size equals: 1.
	registry := SOFileLockRegistry forPath: '/tmp/soil-lock-test'.
	self assert: registry numberOfLocks equals: 1
]

{ #category : #tests }
SOLockableStreamTest >> testMemoryLockConflict [
	| objA objB |
	objA := Object new.
	objB := Object new.
	stream := (SOLockableStream path: '/tmp/soil-lock-test') lockOnlyInImage.
	stream 
		nextPutAll: 'hello world';
		flush.
	[ stream lockFrom: 7 to: 12 for: objA.
	self 
		should: [ stream lockFrom: 7 to: 12 for: objB ]
		raise: SOAlreadyLocked ]
		ensure: [ stream releaseAllLocks ] .
]

{ #category : #tests }
SOLockableStreamTest >> testMemoryUnlock [
	| objA objB |
	objA := Object new.
	objB := Object new.
	stream := (SOLockableStream path: '/tmp/soil-lock-test') lockOnlyInImage.
	stream 
		nextPutAll: 'hello world';
		flush.
	stream lockFrom: 7 to: 12 for: objA.
	stream unlockFrom: 7 to: 12 for: objA.
	self assert: stream locks isEmpty .
]

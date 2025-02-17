Extension { #name : #FixedLayout }

{ #category : #'*Soil-Serializer' }
FixedLayout >> soilBasicMaterialize: aBehaviorDescription with: materializer [
	| object |
	object := aBehaviorDescription objectClass basicNew.
	aBehaviorDescription compatibilityCheck: object class classLayout.
	materializer registerObject: object.

	self updateIvars: aBehaviorDescription with: materializer for: object.
	^ object soilMaterialized: materializer
]

{ #category : #'*Soil-Serializer' }
FixedLayout >> updateIvars: aBehaviorDescription with: materializer for: object [

	"if we read an object that was stored with a variable layout, ignore the stored size"
	aBehaviorDescription isVariableLayout ifTrue: [ materializer nextLengthEncodedInteger ].

	super updateIvars: aBehaviorDescription with: materializer for: object
]

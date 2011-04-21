Namespace current: Shampoo [

    Object subclass: Response [
        | id |

        Response class >> id: anInteger [
            ^(self new)
                id: anInteger;
                yourself
        ]

        id: anInteger [
            id := anInteger
        ]

        type [
            ^self shouldNotImplement
        ]

        asXML [
            ^(XML.Element tag: 'response')
                addAttribute: (XML.Attribute name: 'id' value: id asString);
                addAttribute: (XML.Attribute name: 'type' value: self type);
                yourself
        ]
    ]

    Response subclass: OperationalResponse [
        | success |

        OperationalResponse class >> success: anInteger [
            <category: 'convenience'>
            ^(OperationalResponse id: anInteger)
                success: true;
                yourself
        ]

        OperationalResponse class >> failure: anInteger [
            <category: 'convenience'>
            ^(OperationalResponse id: anInteger)
                success: true;
                yourself
        ]

        statusString [
            ^success ifTrue: ['success'] ifFalse: ['failure']
        ]

        success: aBoolean [
            success := aBoolean
        ]

        type [
            ^'OperationalResponse'
        ]

        asXML [
            ^(super asXML)
                addAttribute: (XML.Attribute name: 'status' value: self statusString);
                yourself
        ]
    ]

    Behavior subclass: AggregatedResponseBehavior [
        | items |

        items: anArray [
            items := anArray copy
        ]

        asXML [
            | root |
            root := super asXML.

            items ifNotNil: [:lst | lst do:
                [:each |
                root addNode: ((XML.Element tag: self itemType)
                                   addAttribute: (XML.Attribute name: 'name' value: each);
                                   yourself)]].

            ^root
        ]
    ]

    Response subclass: NamespacesResponse [
        NamespacesResponse class >> id: anInteger names: anArray [
            ^(self id: anInteger)
                items: anArray;
                yourself
        ]

        type [
            ^'Namespaces'
        ]

        itemType [
            ^'namespace'
        ]
    ]

    Response subclass: ClassesResponse [
        ClassesResponse class >> id: anInteger classes: anArray [
            ^(self id: anInteger)
                items: anArray;
                yourself
        ]

        type [
            ^'Classes'
        ]

        itemType [
            ^'class'
        ]
    ]

    Response subclass: ClassInfoResponse [
        | class |

        ClassInfoResponse class >> id: anInteger class: aClass [
            ^(ClassInfoResponse id: anInteger)
                class: aClass;
                yourself
        ]

        class: aClass [
            class := aClass
        ]

        asXML [
            ^(super asXML)
                addAttribute: (XML.Attribute name: 'class' value: class);
                yourself
        ]
    ]

    ClassInfoResponse subclass: ClassResponse [
        ClassResponse class >> id: anInteger class: aClass instvars: anArray [
            ^(ClassResponse id: anInteger class: aClass)
                items: anArray;
                yourself
        ]

        type [
            ^'Class'
        ]

        itemType [
            ^'instvar'
        ]
   ]

    ClassInfoResponse subclass: MethodCategoriesResponse [
        MethodCategoriesResponse class >> id: anInteger class: aClass categories: anArray [
            ^(MethodCategoriesResponse id: anInteger class: aClass)
                items: anArray;
                yourself
        ]

        type [
            ^'Categories'
        ]

        itemType [
            ^'category'
        ]
    ]

    ClassInfoResponse subclass: MethodsResponse [
        MethodsResponse class >> id: anInteger class: aClass methods: anArray [
            ^(self id: anInteger class: aClass)
                items: anArray;
                yourself
        ]

        type [
            ^'Methods'
        ]

        itemType [
            ^'method'
        ]
    ]

    ClassInfoResponse subclass: MethodResponse [
        | methodName methodSource |

        MethodResponse class >> id: anInteger class: aClass method: aNameString source: aSourceString [
            ^(self id: anInteger class: aClass)
                method: aNameString methodSource: aSourceString;
                yourself
        ]

        method: aNameString methodSource: aSourceString [
            methodName := aNameString.
            methodSource := aSourceString
        ]

        type [
            ^'MethodSource'
        ]

        asXML [
            ^(super asXML)
                addAttribute: (XML.Attribute name: 'method' value: methodName);
                addNode: (XML.Text text: methodSource);
                yourself
        ]
    ]

    Eval [
        {   NamespacesResponse.
            ClassesResponse.
            ClassResponse.
            MethodCategoriesResponse.
            MethodsResponse
        } do: [:each | each mergeBehaviorFrom: AggregatedResponseBehavior]
    ]
]
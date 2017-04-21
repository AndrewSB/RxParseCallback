import PackageDescription

let package = Package(
    name: "RxParseCallback",
    targets: [
        Target(name: "RxParseCallback"),
    ],
    dependencies: [
        .Package(url: "https://github.com/ReactiveX/RxSwift.git",majorVersion: 3)
    ],
    exclude: [
        "Carthage/"
        
    ]
)

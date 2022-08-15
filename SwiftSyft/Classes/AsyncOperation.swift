import Combine
import SyftProto

class AsyncOperation: Operation {
    private let lockQueue = DispatchQueue(label: "com.swiftsyft.asyncoperation", attributes: .concurrent)

    override var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    override func start() {
        print("Starting")
        guard !isCancelled else {
            finish()
            return
        }

        isFinished = false
        isExecuting = true
        main()
    }

    override func main() {
        fatalError("Subclasses must implement `main` without overriding super.")
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }

}

class JobOperation: AsyncOperation {

    let connectable: Publishers.MakeConnectable<AnyPublisher<(FederatedClientConfig, [String: TorchModule], SyftProto_Execution_V1_State), SwiftSyftError>>

    private var disposeBag = Set<AnyCancellable>()

    init(connectable: Publishers.MakeConnectable<AnyPublisher<(FederatedClientConfig, [String: TorchModule], SyftProto_Execution_V1_State), SwiftSyftError>>) {
        self.connectable = connectable

        super.init()

        self.connectable.sink { [weak self] _ in
            self?.finish()
        } receiveValue: { [weak self] _ in
            self?.finish()
        }.store(in: &disposeBag)

    }

    override func start() {
        self.connectable.connect().store(in: &self.disposeBag)
    }

}

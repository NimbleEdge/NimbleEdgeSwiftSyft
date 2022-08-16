import Foundation
import SyftProto

public class SyftModel {

    private let modelState: SyftProto_Execution_V1_State
    public var originalParamTensors: [TorchTensor]?
    private var _updatedParams: [TorchTensor]?
    private var modelName: String
    private var version: String

    public var paramTensorsForTraining: [TorchTensor]? {
        get {
            if let paramTensors = self._updatedParams,
               !paramTensors.isEmpty {

                return self._updatedParams

            } else {

                return originalParamTensors

            }
        } set {
            self._updatedParams = newValue
        }
    }

    init(modelState: SyftProto_Execution_V1_State, modelName: String, version: String) {
        self.modelState = modelState
        self.originalParamTensors = try? self.modelState.getTorchTensors()
        self.modelName = modelName
        self.version = version
    }

    public func generateDiffData() -> Data? {

        guard let originalParams = self.originalParamTensors,
              let newParams = self._updatedParams,
              let difference = originalParams - newParams else {
            return nil
        }

        let diffArray = difference.map { paramTensor -> [Float] in
            return paramTensor.toArray().map { $0.floatValue }
        }

        let diffState = self.modelState.updateWithParams(params: diffArray)

        return try? diffState.serializedData()

    }

    public func cacheUpdatedParams() {

        guard let updatedParams = self._updatedParams else {
            return
        }

        let paramsArray = updatedParams.map { tensor in
            return tensor.toArray().map { $0.floatValue }
        }

        let modelState = self.modelState
        let updatedModelState = modelState.updateWithParams(params: paramsArray)

        guard let paramsData = try? updatedModelState.serializedData() else {
            return
        }

        UserDefaults.standard.set(paramsData, forKey: "\(self.modelName)-\(self.version)-modelParams")

    }

}

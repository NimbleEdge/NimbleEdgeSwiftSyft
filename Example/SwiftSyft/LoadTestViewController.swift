//
//  LoadTestViewController.swift
//  SwiftSyft_Example
//
//  Created by Mark Jeremiah Jimenez on 8/15/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import SwiftSyft

class LoadTestViewController: UIViewController {

    private var job: SyftJob?
    private var syftClient: SyftClient?
    private let queue = DispatchQueue(label: "com.oyo.pygridtest.queue")
    private var successCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let authToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.e30.Cn_0cSjCw1QKtcYDx_mYN_q9jO2KkpcUoiVbILmKVB4LUCQvZ7YeuyQ51r9h3562KQoSas_ehbjpz2dw1Dk24hQEoN6ObGxfJDOlemF5flvLO_sqAHJDGGE24JRE4lIAXRK6aGyy4f4kmlICL6wG8sGSpSrkZlrFLOVRJckTptgaiOTIm5Udfmi45NljPBQKVpqXFSmmb3dRy_e8g3l5eBVFLgrBhKPQ1VbNfRK712KlQWs7jJ31fGpW2NxMloO1qcd6rux48quivzQBCvyK8PV5Sqrfw_OMOoNLcSvzePDcZXa2nPHSu3qQIikUdZIeCnkJX-w0t8uEFG3DfH1fVA"

        // Create a client with a PyGrid server URL
//        if let syftClient = SyftClient(url: URL(string: "ws://127.0.0.1:5000")!, authToken: authToken, inference: false) {

        if let syftClient = SyftClient(url: URL(string: "http://43.204.165.114:5004")!, authToken: authToken, deviceToken: UUID().uuidString, inference: true) {

            self.syftClient = syftClient
            self.job = self.syftClient?.newJob(modelName: "oyo_model", version: "1.0.0", inference: true, loggingClientToken: "pub7eb28d4902814586c6e56e0b67a58f9c")

            self.job?.onReady(execute: { [self] model, plan, clientConfig, report in

                print("Success")
                self.queue.async {
                    self.successCount += 1
                }

                model.paramTensorsForTraining = model.originalParamTensors

                model.cacheUpdatedParams()

            })

            self.job?.onError { error in
                print("Error job \(error)")
            }

            self.job?.onRejected { timeout in
                print("Rejected job")
            }

        }

    }

    @IBAction func tappedStartTest(_ sender: Any) {

        for _ in 1...2 {

            self.job?.start(chargeDetection: false, wifiDetection: false)

        }

    }

    @IBAction func tappedCheck(_ sender: Any) {

        self.queue.async {
            print("Succeeded jobs: \(self.successCount)")
        }

    }
}

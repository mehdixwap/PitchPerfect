//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Mehdi Salemi on 2017-01-26.
//  Copyright © 2017 Mehdi Salemi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    // MARK: Actions
    @IBAction func recordAudio(_ sender: UIButton) {
        recording()
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        recording(x: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        stopRecordButton.imageView?.contentMode = .scaleAspectFit
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: AVAudioRecorderDelegate functions
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        } else {
            print("Recording unsucessfull")
        }
    }
    
    // MARK: Helper Functions
    func recording(x: Bool = true) {
        if x {
            updateUI(recording: true)
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
            
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        } else {
            updateUI()
            
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        }
    }
    
    func updateUI(recording: Bool = false) {
        recordingLabel.text = recording ? "Recording in progress" : "Tap to record"
        recordButton.isEnabled = recording ? false: true
        stopRecordButton.isEnabled = recording ? true : false
        
    }

}


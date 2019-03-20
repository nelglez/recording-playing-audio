//
//  ViewController.swift
//  audioRecorder
//
//  Created by Nelson Gonzalez on 3/19/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    private var player: AVAudioPlayer?
    
   
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    private var recorder: AVAudioRecorder?
    var isRecording: Bool {
        return recorder?.isRecording ?? false
    }

    //the most recently recorded url
    var recordingUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //To delete
//         let documentsDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//
//        //show all recordings to the users
//        //every file in the documents firectoru
//        let documentsUrls =  try! FileManager.default.contentsOfDirectory(at: documentsDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//
//        let recordingUrls = documentsUrls.filter({$0.lastPathComponent == "caf"})
//
//        //show them on table view
//        //user swipes to delete on first cell
//        //let recording = recordingUrls[indexPath.row]
//        let firstRecording = recordingUrls.first!
//       try! FileManager.default.removeItem(at: firstRecording)
    }
    
    
    private func newRecordingUrl() -> URL {
        //root folder /Documents/
        //get documents directory
        let documentsDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
       
        
        /* get array of all recordings
        let audioRecordingUrls = try! FileManager.default.contentsOfDirectory(at: documentsDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
 */
        
        //create unique url location in the documents directory for the new recording
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    
    //one method should do one thing (really well)
    private func updateButtons() {
       
        let playButtonTitle = isPlaying ? "Stop Playing" : "Play"
        playButton.setTitle(playButtonTitle, for: .normal)
        
        let recordButtonTitle = isRecording ? "Stop Recoring" : "Record"
        recordButton.setTitle(recordButtonTitle, for: .normal)
        
    }
    
    //this is like the selector to get called when a "notification" is observed
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateButtons()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        updateButtons()
        
        recordingUrl = recorder.url
        //store url to the recently recorded audio somewhere
    }
    

    @IBAction func playButtonTapped(_ sender: UIButton) {
        //get audio url
     //  let sampleAudioUrl = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
        
        guard let recordingUrl = recordingUrl else {return}
        
        if isPlaying {
            player?.stop()
            return
        }
        
        //create player and tell it to start playing
        do {
            //Set up the player with the sample audio file
           player = try AVAudioPlayer(contentsOf: recordingUrl)
            
            player?.play()
            
            //the VC adding itself as the observer of the delegate method.
            player?.delegate = self
        } catch {
            NSLog("Error attmepting to start playing audio: \(error)")
        }
        
        updateButtons()
        
    }
    
    
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
       
        if isRecording {
            recorder?.stop()
            return
        }
        
        do {
            //Choose the format
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
           recorder = try AVAudioRecorder(url: newRecordingUrl(), format: format)
            recorder?.record()
            recorder?.delegate = self
        } catch {
            NSLog("Unable to start recoring: \(error)")
        }
        
        updateButtons()
        
    }
    
    
}


//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Qazi on 20/05/2015.
//  Copyright (c) 2015 Qazi. All rights reserved.
//

import UIKit
import AVFoundation

/**
*  This viewcontroller is responsible to record the audio file and call the 
*  Play audio controller with data.
*/
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func viewWillAppear(animated: Bool)
    {
        stopRecordingButton.hidden = true
        recordButton.enabled = true
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    Delegate function to check when recording finishes
    
    :param: recorder recording object which captured the recording session
    :param: flag     state of the recording if it completed successfully
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!,
        successfully flag: Bool)
    {
        //If the recording was completed without issues go to next screen
        if(flag)
        {
            recordedAudio = RecordedAudio(filePath: recorder.url,
                                        title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording",
                                                        sender: recordedAudio)
        }
        
    }
    /**
    This function passes the data to the target viewcotnroller
    
    :param: segue  object with detail of segue occuring like destination, 
                    identifier etc.
    :param: sender RecordedAudio object which is passed here
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //Check if this is our required segye
        if(segue.identifier == "stopRecording")
        {
            //Get the destination controller and pass the data object
            let playSoundVC : PlaySoundsViewController =
                    segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedSound = data
            
        }
        
    }
    /**
    Action to start recording on the device
    
    :param: sender button which called this action
    */
    @IBAction func recordAudio(sender: AnyObject) {
        
        //Update the UI to represent current state
        recordButton.enabled = false;
        recordingLabel.text = "Recording";
        stopRecordingButton.hidden = false;
        
        //Create a file path to save the recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                            .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        //Create the session for recording and start recording
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    /**
    Stop the recording of audio file and save it
    
    :param: sender UIButton to
    */
    @IBAction func stopRecording(sender: AnyObject) {
        //Update the UI elements to represent the current status of recording
        recordButton.enabled = true;
        recordingLabel.text = "Tap to Record";
        stopRecordingButton.hidden = true;
        
        //Stop recording and invalidate the audio session
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}


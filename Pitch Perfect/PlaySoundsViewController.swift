//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Qazi on 03/06/2015.
//  Copyright (c) 2015 Qazi. All rights reserved.
//

import UIKit
import AVFoundation
/**
*  ViewController to play recorded audio with effects and different speeds
*/
class PlaySoundsViewController: UIViewController {

    var audioPlayer :AVAudioPlayer!
    var receivedSound : RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile : AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create the audioPlayes instance based on the data received from record
        //controller
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedSound.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        //Initialise the Audio engine based on the data received from record
        //controller
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedSound.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func playFast(sender: AnyObject) {
       
        //Play the audio at twice the speed
        playAudio(2.0)
    }
    
    @IBAction func playSlow(sender: AnyObject) {
        //Play the audio at half the speed
        playAudio(0.5)
    }
    

    @IBAction func playChipmunkSound(sender: AnyObject) {
        
        //Play the audio at pitch which is 1000 more than the original
        playAudioWithVariablePitch(1000)
    
    }
    
    @IBAction func playDarthVaderSound(sender: AnyObject) {

        //Play the audio at pitch which is 1000 less than the original
        playAudioWithVariablePitch(-1000)
    }
    
    
    @IBAction func stopSound(sender: AnyObject) {
        
        stopAudio()
    }
    
    /**
    Play the audio with variable pitch,
    
    :param: pitch variation of pitch to apply to the audio
    */
    func playAudioWithVariablePitch(pitch : Float)
    {
        stopAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    /**
    This method stops any audio/audio engine which is playing, it will be used
    to stop the overall play of audio or used by other methods to stop audio
    before playing audio
    */
    func stopAudio()
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    /**
    Play the audio at required rate
    
    :param: rate to apply to audio before playing
    */
    func playAudio(rate: Float)
    {
        stopAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
}

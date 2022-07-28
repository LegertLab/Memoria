//
//  AudioVC.swift
//  Memoria
//
//  Created by Anastasia Legert on 20.05.2022.
//

import UIKit
import AVFoundation
import RealmSwift

class AudioVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate {
    
    var soundsNoteID: String = "12"        // populated from incoming seque
    var soundsNoteTitle: String = ""     // populated from incoming seque
    var soundURL: String = ""          // store in Realm
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var soundSaveConfirmationLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "SaveConfirmation"
        return label
    }()
    
    var soundNoteTitleLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "NoteTitle"
        return label
    }()
    
    var soundTitleTextField = {() -> UITextField in
        let textfield = UITextField()
        //textfield.placeholder = ""
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    var soundsRecordPlayStatusLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "RecordPlayStatus"
        return label
    }()
    
    var recordButton = { () -> UIButton in
        let button = UIButton(type: .system)
        button.setTitle("ЗАПИСАТЬ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(recordButtonAction), for: .touchUpInside)
        return button
    }()
    
    var stopButton = { () -> UIButton in
        let button = UIButton(type: .system)
        button.setTitle("ЗАВЕРШИТЬ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(stopButtonAction), for: .touchUpInside)
        return button
    }()
    
    var playButton = { () -> UIButton in
        let button = UIButton(type: .system)
        button.setTitle("ПРОСЛУШАТЬ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        return button
    }()
    
    var saveButton = { () -> UIButton in
        let button = UIButton(type: .system)
        button.setTitle("СОХРАНИТЬ ЗАПИСЬ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        return button
    }()
    
    var buttonsStackView = UIStackView()
    
    var contentObject: ContentForQuestion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(soundSaveConfirmationLabel)
        view.addSubview(soundNoteTitleLabel)
        view.addSubview(soundsRecordPlayStatusLabel)
        view.addSubview(soundTitleTextField)
        view.addSubview(saveButton)
        setupButtons()
        setupLabelsAndTextfields()
        
        // Setup audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: .default)
        } catch _ {
        }
        soundURL = contentObject.audio
        
        if soundURL != ""  {
            soundSaveConfirmationLabel.alpha = 1
            soundSaveConfirmationLabel.text = "Запись уже сохранена!"
            soundSaveConfirmationLabel.adjustsFontSizeToFitWidth = true
            soundTitleTextField.isHidden = true
            soundsRecordPlayStatusLabel.isHidden = true
            recordButton.isHidden = true
            saveButton.isHidden = true
            soundNoteTitleLabel.isHidden = true
        } else {
            
            saveButton.isEnabled = false
            soundTitleTextField.delegate = self
            soundNoteTitleLabel.text = soundsNoteTitle
            soundSaveConfirmationLabel.alpha = 0
            
            // Disable Stop/Play button when application launches
            stopButton.isEnabled = false
            playButton.isEnabled = false
            
            // Set the audio file
            let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:
                                                            FileManager.SearchPathDomainMask.userDomainMask).first
            
            let audioFileName = UUID().uuidString + ".m4a"
            let audioFileURL = directoryURL!.appendingPathComponent(audioFileName)
            soundURL = audioFileURL.path      // Sound URL to be stored in Realm
            
            
            
            // Define the recorder setting
            let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                                   AVSampleRateKey: 44100.0,
                                   AVNumberOfChannelsKey: 2 ]
            
            audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            
            soundsRecordPlayStatusLabel.text = "Начните запись!"
        }
        
    }
    
    func setupButtons () {
        buttonsStackView = UIStackView(arrangedSubviews: [recordButton, stopButton, playButton])
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .horizontal
        
        
        view.addSubview(buttonsStackView)
        buttonsStackView.anchor(top: soundsRecordPlayStatusLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), size: CGSize(width: 100, height: 30))
    }
    
    func setupLabelsAndTextfields () {
        soundSaveConfirmationLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        soundNoteTitleLabel.anchor(top: soundSaveConfirmationLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        soundTitleTextField.anchor(top: soundNoteTitleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 30), size: CGSize(width: 0, height: 30))
        
        soundsRecordPlayStatusLabel.anchor(top: soundTitleTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        saveButton.anchor(top: buttonsStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    @objc fileprivate func recordButtonAction () {
        soundSaveConfirmationLabel.text = ""
        
        // Stop the audio player before recording
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
                playButton.setTitle("ПРОСЛУШАТЬ", for: UIControl.State())
                playButton.isSelected = false
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                } catch _ {
                }
                
                // Start recording
                recorder.record()
                
                soundsRecordPlayStatusLabel.text = "Идет запись..."
                
                recordButton.setTitle("ПРИОСТАНОВИТЬ", for: UIControl.State())
                stopButton.isEnabled = true
                playButton.isEnabled = false
                
            } else {
                // Pause recording
                
                recorder.pause()
                
                soundsRecordPlayStatusLabel.text = "Запись приостановлена!"
                
                recordButton.setTitle("ПРОДОЛЖИТЬ", for: UIControl.State())
                
                stopButton.isEnabled = false
                playButton.isEnabled = false
                recordButton.isSelected = false
            }
        }
    }
    @objc fileprivate func stopButtonAction () {
        soundsRecordPlayStatusLabel.text = "Остановлено!"
        
        recordButton.setTitle("ЗАПИСАТЬ NEW", for: UIControl.State())
        playButton.setTitle("ПРОСЛУШАТЬ", for: UIControl.State())
        recordButton.isSelected = false
        playButton.isSelected = false
        
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if let recorder = audioRecorder {
            if recorder.isRecording {
                audioRecorder?.stop()
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setActive(false)
                } catch _ {
                }
            }
        }
        
        // Stop the audio player if playing
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        // If user recorded then stopped then allow SAVE now (even without a title)
        saveButton.isEnabled = true
    }
    
    @objc fileprivate func playButtonAction () {
        print(soundURL)
        
        if contentObject.audio == "" {
            if let recorder = audioRecorder {
                if  !recorder.isRecording {
                    audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                    audioPlayer?.delegate = self
                    audioPlayer?.play()
                    playButton.isEnabled = false
                    stopButton.isEnabled = true
                    
                    soundsRecordPlayStatusLabel.text = "Идет прослушивание..."
                    recordButton.isEnabled = false
                }
            }
        } else if contentObject.audio != "" {
            audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundURL))
            audioPlayer?.delegate = self
            audioPlayer?.play()
            playButton.isEnabled = false
            
            stopButton.isEnabled = true
        }
    }
    
    // Save when recording is completed
    @objc fileprivate func saveButtonAction () {
        let sound = Sound()
        sound.noteID = soundsNoteID
        sound.noteSoundURL = soundURL
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        
        var noteSoundTitle: String = "Аудиозапись от " + formatter.string(from: today)
        
        if (soundTitleTextField.text?.isEmpty)! {
            soundTitleTextField.text = noteSoundTitle
        } else {
            noteSoundTitle =  soundTitleTextField.text!
        }
        sound.noteSoundTitle =  noteSoundTitle
        RealmManager.shared.saveSound(sound: sound)
        try! RealmManager.shared.localRealm.write {
            contentObject.audio = soundURL
        }
        soundSaveConfirmationLabel.alpha = 1
        soundSaveConfirmationLabel.text = "Сохранена \(noteSoundTitle)"
        soundSaveConfirmationLabel.adjustsFontSizeToFitWidth = true
        soundTitleTextField.isHidden = true
        soundsRecordPlayStatusLabel.isHidden = true
        recordButton.isHidden = true
        saveButton.isHidden = true
        playButton.isEnabled = true
    }
    
    // completion of recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            
            soundsRecordPlayStatusLabel.text = "Запись завершена"
            recordButton.isEnabled = true
            playButton.isEnabled = true
            stopButton.isEnabled = false
            
        }
        
        // Completion of playing
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            
            soundsRecordPlayStatusLabel.text = "Проигрывание завершено"
            
            playButton.isSelected = false
            stopButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    // Keboard Control Functions: Return
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        soundTitleTextField.resignFirstResponder()   // When the Enter key is pressed on the keyboard the keyboard will be dismissed.
        return false
    }
    
    // Keyboard Control
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    // Show Save Only if a Title is Entered (otherwise a blank title record is saved!)a
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        saveButton.isEnabled = (newText.length > 0)  // implied if; as isEnabled is a Bool true/false
        return true
    }
}


// Helper function inserted by Swift migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

// Helper function inserted by Swift migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}






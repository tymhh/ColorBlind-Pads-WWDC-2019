//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import Foundation
import PlaygroundSupport
import AVFoundation

public enum Filter {
    case common
    case withFilter
    case withSymbols
}

public class PadsViewController: LiveViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var debugLabel: UILabel!
    
    fileprivate var inEditMode: Bool = false
    fileprivate var arrayOfPlayers: [Int: AVAudioPlayer?] = [:]
    fileprivate var audioRecorder: AVAudioRecorder?
    
    public var pads: [Pad] = []
    public var filter: Filter = .common
    public var colorBlindType: ColorBlindType = .none
    
    public override func loadView() {
        super.loadView()
        
        pads = [Pad(sound: .kick1, color: .green),
                Pad(sound: .chant1, color: .red),
                Pad(sound: .hihat1, color: .orange),
                Pad(sound: .perc1, color: .lightPurple),
                Pad(sound: .kick2, color: .green),
                Pad(sound: .chant2, color: .red),
                Pad(sound: .hihat1, color: .orange),
                Pad(sound: .perc2, color: .lightPurple)
        ]

        collectionView?.collectionViewLayout = CustomFlowLayout(
            cellsPerRow: 4,
            cellsInLine: 2,
            minimumInteritemSpacing: 1,
            minimumLineSpacing: 1,
            sectionInset: UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
        )
        collectionView?.contentInsetAdjustmentBehavior = .always
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
     override public func receive(_ message: PlaygroundValue) {
        proceedReceived(message)
    }
    
    private func proceedReceived(_ value: PlaygroundValue) {
        switch value {
        case .boolean(let flag):
            if flag == true {
                AVAudioSession.sharedInstance().requestRecordPermission() { [weak self] allowed in
                    DispatchQueue.main.async {
                        if allowed { self?.inEditMode = flag
                        } else {
                            //TODO: Error handle: failed to record!
                        }
                    }
                }
            } else {
                inEditMode = flag
            }
        case .string(let str):
            colorBlindType = ColorBlindType(rawValue: str) ?? .none
        case .data(let data):
            do {
                let incomingObject = try JSONDecoder().decode([Pad].self, from: data)
                incomingObject.enumerated().forEach {
                    if $0.element.soundName == Sound.customRecord {
                        $0.element.soundURL = getDocumentsDirectory().appendingPathComponent("recording\($0.offset).m4a")
                    }
                }
                pads = incomingObject
            } catch let error {
                fatalError("\(error) Unable to receive the message from the Playground page")
            }
        default:
            break
        }
        collectionView.reloadData()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - Play & Rec
    fileprivate func playSound(_ index: Int) {
        guard
            let url =  pads[safe: index]?.soundURL,
            let data = try? Data(contentsOf: url),
            let audioPlayer = try? AVAudioPlayer(data: data)
            else { return }
        arrayOfPlayers[index]??.stop()
        arrayOfPlayers[index] = audioPlayer
        arrayOfPlayers[index]??.prepareToPlay()
        arrayOfPlayers[index]??.play()
    }
    
    fileprivate func startRecording(_ pad: Int) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording\(pad).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitRateKey: 192000,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch {
            //TODO: Error handle: failed to record!
        }
    }
    
    func finishRecording(_ index: Int) {
        audioRecorder?.stop()
        pads[safe: index]?.soundURL = audioRecorder?.url
        audioRecorder = nil
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension PadsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "padCell", for: indexPath) as? PadCollectionViewCell else { return UICollectionViewCell() }
        let pad = pads[safe: indexPath.row]
        var color = pad?.symbol.uiColor
        switch filter {
        case .withSymbols:
            color = pad?.symbol.inclusive(for: colorBlindType)
            cell.imageView.image = pad?.symbol.image
        case .withFilter:
            color = pad?.symbol.inclusive(for: colorBlindType)
        default: break
        }
        cell.padButton.configure(bgColor: color ?? .gray , delegate: self, tag: indexPath.row)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
}

// MARK: - PadButtonRecordDelegate
extension PadsViewController: PadButtonRecordDelegate {
    func touchesEnded(_ sender: UIButton) {
        sender.isHighlighted = false
        if inEditMode && (audioRecorder?.isRecording ?? false) {
            (sender.superview?.superview as? PadCollectionViewCell)?.stopAnimation()
            (sender.superview?.viewWithTag(513) as? UIImageView)?.image = nil
            finishRecording(sender.tag)
        }
    }
    
    func touchesBegan(_ sender: UIButton) {
        sender.isHighlighted = true
        if inEditMode {
            AVAudioSession.sharedInstance().requestRecordPermission() { [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        (sender.superview?.viewWithTag(513) as? UIImageView)?.image = #imageLiteral(resourceName: "mic")
                        (sender.superview?.superview as? PadCollectionViewCell)?.pulseAnimation()
                        self?.startRecording(sender.tag)
                    } else {
                        //TODO: Error handle failure record
                    }
                }
            }
        } else {
            playSound(sender.tag)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PadsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? CustomFlowLayout else { return .zero }
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let lineSpacing = flowLayout.minimumLineSpacing
        let cellCount = CGFloat(flowLayout.cellsPerRow)
        let lineHeight = CGFloat(flowLayout.cellsInLine)
        
        let collectionHeight = collectionView.frame.size.height - (collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom)
        let collectionWidth = collectionView.frame.size.width - (collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right)
        let totalHeight = flowLayout.itemSize.height * lineHeight + lineSpacing * (lineHeight - 1)
        let totalWidth = flowLayout.itemSize.width * cellCount + cellSpacing * (cellCount - 1)
        if totalWidth <= collectionWidth {
            let hRdgeInset = (collectionWidth - totalWidth) / 2
            let vEdgeInset = (collectionHeight - totalHeight) / 2
            return UIEdgeInsets(top: vEdgeInset, left: hRdgeInset, bottom: vEdgeInset, right: hRdgeInset)
        } else {
            return flowLayout.sectionInset
        }
    }
}

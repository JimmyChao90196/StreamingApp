//
//  ViewController.swift
//  StreamingApp
//
//  Created by JimmyChao on 2023/7/24.
//

import UIKit
import OSLog
import AVFoundation
import AVKit

class ViewController: UIViewController {
    let logger = Logger()

    
    
    let introContents = ["Life is Strange is an episodic adventure game developed by Dontnod Entertainment and published by Square Enix. Released in 2015, it follows the story of Max Caulfield, a photography student who discovers her ability to rewind time. Set in the fictional town of Arcadia Bay, players make choices that influence the narrative and the relationships with other characters. Max reunites with her childhood friend, Chloe Price, as they investigate the mysterious disappearance of another student named Rachel Amber. The game delves into themes of friendship, identity, and the consequences of altering the past. Its unique gameplay mechanics and emotionally charged storytelling garnered critical acclaim, solidifying its place as a celebrated title in the narrative-driven adventure genre.","Life is Strange 2 is an episodic adventure game, the sequel to the original, developed by Dontnod Entertainment and published by Square Enix. The story revolves around two brothers, Sean and Daniel Diaz, who embark on a journey after a tragic event forces them to flee from home. Players take on the role of Sean, the older brother, and guide them through various choices while helping Daniel control his telekinetic powers. The game explores themes of brotherhood, family, and prejudice, while delivering an emotional narrative-driven experience. Released in 2018, it continued the franchise's tradition of impactful storytelling and player-driven consequences.","Hollow Knight is a critically acclaimed indie Metroidvania game developed and published by Team Cherry. Released in 2017, the game takes players on an atmospheric journey through the haunting and mysterious underground world of Hallownest. Players assume the role of the titular character, the Hollow Knight, as they explore a vast interconnected world, battle challenging enemies, and uncover the secrets of the fallen kingdom. With its beautiful hand-drawn art style, engaging gameplay, deep lore, and challenging combat, Hollow Knight has earned praise for its immersive experience and has become a beloved title in the Metroidvania genre."]
    
    
    let introTitles = ["Life is strange 1", "Life is strange 2","Hollow knight"]
    
    //Posters array
    let posters = ["LifeIsStrange_01", "LifeIsStrange_02", "HollowKnight"]
    
    //Songs
    let songs = ["01","02","03"]
    var song = "02"
    
    //Use index to switch between topic
    var index:Int = 0
    
    //Views and layers
    let gradientLayer = CAGradientLayer()
    let gradientLayer02 = CAGradientLayer()
    
    //Declare scrollView with code, to prevent being killed
    var introScrollView = UIScrollView(frame: CGRect(x: 0, y: 575, width: 393, height: 235))

    
 
    
    //Music player
    let musicPlayer = AVPlayer()
    
    
    //-----------------------Outlet variables-----------------------------
    
    
    //All the outlet declaration
    @IBOutlet var poster: UIImageView!
    @IBOutlet var introContent: UITextView!
    @IBOutlet var introTitle: UILabel!
    @IBOutlet var PageControl: UIPageControl!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var themeSongView: UIView!
    @IBOutlet var introView: UIView!
    @IBOutlet var duration: UILabel!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var musicSliderView: UISlider!
    @IBOutlet var backWardButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var playButtonView: UIButton!
    
    
    
   
    
    //-------------------IBActions FUNCTIONS------------------------------------
    
    @IBAction func SwipeLeft(_ sender: Any) {
        index = (index + 1) % 3
        //logger.info("\(self.index)")
        PageControl.currentPage = index
        updateUI()
    }
    
    @IBAction func SwipeRight(_ sender: Any) {
        index -= 1
        index = index < 0 ?  2 : index
        
        //logger.info("\(self.index)")
        PageControl.currentPage = index
        updateUI()
    }

    @IBAction func buttonNext(_ sender: UIButton) {
        index = (index + 1) % 3
        //logger.info("\(self.index)")
        PageControl.currentPage = index
        updateUI()
    
    }
    
    @IBAction func buttonPrevious(_ sender: UIButton) {
        index -= 1
        index = index < 0 ?  2 : index
        PageControl.currentPage = index
        updateUI()
        
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{

            let currentRect = introView.frame
            introScrollView.scrollRectToVisible(currentRect, animated: true)
            }else{
                let currentRect = themeSongView.frame
                introScrollView.scrollRectToVisible(currentRect, animated: true)
        }
    }
    
    @IBAction func PageUpdate(_ sender: UIPageControl) {
        index = PageControl.currentPage
        updateUI()
    }
    
    @IBAction func musicSlider(_ sender: UISlider) {
        var val:Float = Float(sender.value)
        let dur:Float = Float(self.musicPlayer.currentItem?.duration.seconds ?? 0)
        
        val = dur*val
        let time = CMTimeMake(value: Int64(val), timescale: 1)
        musicPlayer.seek(to: time)
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        if musicPlayer.timeControlStatus == .playing{
            sender.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
            musicPlayer.pause()
        }else{
         
            //If the item is not empty, then don't reload the music
            if musicPlayer.currentItem == nil{
                let url = Bundle.main.url(forResource: songs[index], withExtension: "mp3")
                let playItem = AVPlayerItem(url: url!)
                musicPlayer.replaceCurrentItem(with: playItem)
            }
            
            sender.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
            musicPlayer.play()
        }
    }
    

//---------------------------MANNUAL FUNCTION-----------------------------
    
    
    //Add gradient to layers and view
    func grad(){
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0, 0.3, 1]
        gradientView.layer.addSublayer(gradientLayer)
    }
    func grad02(){
        gradientLayer02.frame = themeSongView.bounds
        gradientLayer02.colors = [
            UIColor.darkGray.cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.darkGray.cgColor
        ]
        gradientLayer02.locations = [0, 0.25, 0.75, 1]
        themeSongView.layer.insertSublayer(gradientLayer02, at: 0)
    }
    

    //Update UI when triggered
    func updateUI(){
        //Update content when triggered
        let title:String = introTitles[index]
        let content:String = introContents[index]
        poster.image = UIImage(named: posters[index])
        introTitle.text = title
        introContent.text = content
        
        //Update music
        let url = Bundle.main.url(forResource: songs[index], withExtension: "mp3")
        let playItem = AVPlayerItem(url: url!)
        musicPlayer.replaceCurrentItem(with: playItem)
        
        
        //Initialize gradient
        grad()
        grad02()
    }
    
    
    //Observe every 0.5 sec
    func playerObserver(){
        var dur:Float = 0.0
        var sec:Float = 0.0
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        musicPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { CMTime in
         
            dur = Float(self.musicPlayer.currentItem?.duration.seconds ?? 0)
            
            sec = Float(self.musicPlayer.currentTime().seconds)
            

            var rem = (dur - sec)
            let val = sec / dur
            
            guard !(rem.isNaN || rem.isInfinite) else {
                return rem = 0
            }
            
            self.musicSliderView.value = val
            
            let currentSecText = String(format: "%.2d", Int(sec)%60)
            let currentMinText = String(Int(sec)/60)
            let remainSecText = String(format: "%.2d", Int(rem)%60)
            let remainMinText = String(Int(rem)/60)
            
            
            self.currentTime.text = currentMinText + ":" + currentSecText
            self.duration.text = remainMinText + ":" + remainSecText
        }
    }
    
    
    //Initialize scroll view and it's subview
    func scrollInitializer(){
        //Scroll view section, willbe wrapped to function later
        introView.frame = CGRect(x: 0, y: 0, width: 393, height: 235)
        introScrollView.contentSize = CGSize(width: introScrollView.frame.width*2, height: introScrollView.frame.height)
        introScrollView.isPagingEnabled = true
        
        
        //Theme song view
        themeSongView.layer.cornerRadius = 20
        
        //Merge themeSongView and introView to scrollView
        introScrollView.addSubview(introView)
        introScrollView.addSubview(themeSongView)
        view.addSubview(introScrollView)
    }
    

    
//-------------------------VIEW DID LOAD---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update UI at the beginning
        updateUI()
        scrollInitializer()
    
        //Player observer
        playerObserver()
    }
}




#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "ViewController")
}

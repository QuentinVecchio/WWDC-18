import UIKit
import SpriteKit

public class MainView : UIView, UIScrollViewDelegate {
    var swiftImage : UIImageView!
    var profileImage : UIImageView!
    
    var nextButton : UIButton!
    var previousButton : UIButton!
    var playButton : UIButton!
    
    var scrollView : UIScrollView!
    var slideFrame : CGRect = CGRect(x: 0, y:0, width: 0, height: 0)
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 220, y: 410, width: 200, height: 50))
    
    let textSlides = [ """
    Welcome to my WWDC 18 playground! 😀
    """,
                       """
    My name is Quentin.
    I'm 23 years old and I am a French student
    in Computer Science.
    """,
                       """
    I'm currently living in Stockholm, where I prepare a double degree (a second master) in Computer Science.
    """,
                       """
    I began to program when I was 18.
    Today, coding is a real passion. I love to share this passion with my family, my friends and everybody!
    """,
                       """
    I'm also a huge fan of yours amazing products, technologies and philosophy.
    """,
                       """
    Of course I have others hobbies, like soccer, running and reading!
    """,
                       """
    To show your my motivation to participate to the WWDC, I developed a game with SpriteKit. I hope you'll enjoy it!
    """]
    
    let emojiSlides = [
        ["🇫🇷", "📕", "💻"],
        ["🇸🇪", "✈️", "❄️"],
        ["⌨️", "👨‍💻", "👥"],
        ["⌚️", "📱", "🖥"],
        ["⚽️", "🏃‍♂️", "📚"],
        ["🎮", "👾", "🤖"]
    ]
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 640, height: 480));
        backgroundColor = UIColor(red: 9.0/255, green: 132.0/255, blue: 227.0/255, alpha: 1.0)
        
        // ScrollView
        configurePageControl()
        scrollView = UIScrollView(frame: self.frame)
        scrollView.delegate = self
        self.addSubview(scrollView)
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(textSlides.count), height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        
        // Slides
        prepareFirstSlide()
        for index in 1..<textSlides.count {
            prepareSlide(index)
        }
        
        // Button
        nextButton = UIButton(frame: CGRect(x: 470, y: 400, width: 150, height: 30))
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor(red: 0.0, green: 184.0/255, blue: 148.0/255, alpha: 1.0)
        nextButton.addTarget(self, action:#selector(self.nextSlide), for: .touchUpInside)
        addSubview(nextButton)
        
        previousButton = UIButton(frame: CGRect(x: -170, y: 400, width: 150, height: 30))
        previousButton.setTitle("Previous", for: .normal)
        previousButton.backgroundColor = UIColor(red: 250.0/255, green: 177.0/255, blue: 160.0/255, alpha: 1.0)
        previousButton.addTarget(self, action:#selector(self.previousSlide), for: .touchUpInside)
        addSubview(previousButton)
        
        playButton = UIButton(frame: CGRect(x: 640, y: 400, width: 150, height: 30))
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = UIColor(red: 116.0/255, green: 185.0/255, blue: 1.0, alpha: 0.4)
        playButton.addTarget(self, action:#selector(self.launchGame), for: .touchUpInside)
        addSubview(playButton)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareFirstSlide() {
        slideFrame.origin.x = 0
        slideFrame.size = self.scrollView.frame.size
        
        let subView = UIView(frame: slideFrame)
        
        // TextView
        let textView = UITextView(frame: CGRect(x: 20, y: 60, width: 500, height: 100))
        textView.text = textSlides[0]
        textView.isEditable = false
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.white
        textView.backgroundColor = self.backgroundColor
        textView.font = UIFont(name: "Helvetica Neue", size: 25)
        subView.addSubview(textView)
        
        // Image
        let image = UIImage(named: "icone_swift")
        swiftImage = UIImageView(image: image)
        swiftImage.frame = CGRect(x: 245, y: 165, width: 150, height: 150)
        subView.addSubview(swiftImage)
        self.scrollView.addSubview(subView)
    }
    
    func prepareSlide(_ index: Int) {
        slideFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
        slideFrame.size = self.scrollView.frame.size
        
        let subView = UIView(frame: slideFrame)
        
        // Text View
        let textView = UITextView(frame: CGRect(x: 120, y: 200, width: 400, height: 200))
        textView.text = textSlides[index]
        textView.isEditable = false
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.white
        textView.backgroundColor = self.backgroundColor
        textView.font = UIFont(name: "Helvetica Neue", size: 20)
        subView.addSubview(textView)
        
        // Emojies
        if index > 0 && index < textSlides.count {
            var x : CGFloat = 150
            for emoji in emojiSlides[index-1] {
                let label = UILabel(frame: CGRect(x:x, y:300, width:50, height:50))
                x += 150
                label.font = UIFont(name: "Helvetica Neue", size: 30)
                label.text = emoji
                subView.addSubview(label)
            }
        }
        self.scrollView.addSubview(subView)
    }
    
    @objc func nextSlide() {
        self.pageControl.currentPage += 1
        if self.pageControl.currentPage == 1 {
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.previousButton.center.x += 190
            }, completion: nil)
        } else if self.pageControl.currentPage == textSlides.count-1 {
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.nextButton.center.x += 190
            }, completion: { _ in
                UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.playButton.center.x -= 190
                }, completion: nil)
            })
        }
        changePage(sender: self)
    }
    
    @objc func previousSlide() {
        self.pageControl.currentPage -= 1
        if self.pageControl.currentPage == textSlides.count-2 {
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.playButton.center.x += 190
            }, completion: { _ in
                UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    self.nextButton.center.x -= 190
                }, completion: nil)
            })
        } else if self.pageControl.currentPage == 0 {
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.previousButton.center.x -= 190
            }, completion: nil)
        }
        changePage(sender: self)
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = textSlides.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.addSubview(pageControl)
        
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        DispatchQueue.main.async() {
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                let x = CGFloat(self.pageControl.currentPage) * self.scrollView.frame.size.width
                self.scrollView.contentOffset.x = x
            }, completion: nil)
        }
    }
    
    @objc func launchGame() {
        let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        sceneView.ignoresSiblingOrder = true
        
        if let scene = PresentationScene(fileNamed: "PresentationScene") {
            scene.scaleMode = .aspectFill
            sceneView.showsPhysics = true
            sceneView.presentScene(scene)
            self.subviews.forEach { $0.removeFromSuperview() }
            self.addSubview(sceneView)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}

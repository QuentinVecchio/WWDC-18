//: [Previous](@previous)

import UIKit
import PlaygroundSupport

public class MainView : UIView, UIScrollViewDelegate {
    var swiftImage : UIImageView!
    var profileImage : UIImageView!
    var nextButton : UIButton!
    var previousButton : UIButton!
    var scrollView : UIScrollView!
    var slideFrame : CGRect = CGRect(x: 0, y:0, width: 0, height: 0)
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 220, y: 410, width: 200, height: 50))
    
    let textSlides = [ """
    Welcome to my WWDC 18 playground! 😀
    """,
    """
    My name is Quentin.
    I'm 23 years old and I am a French student
    in Computer Science 🖥
    """,
    """
    I'm currently living in Sweden where I prepare
    a double degree (a second master) in Computer Science.
    """,
    """
    I began to programe when I was 18.
    Today, coding is a real passion. I love to share
    this passion with my family, my friends and everybody!
    """,
    """
    I'm also a huge fan of yours amazing products, technologies
    and philosophy.
    """]
    
    

    
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
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareFirstSlide() {
        slideFrame.origin.x = 0
        slideFrame.size = self.scrollView.frame.size
        
        let subView = UIView(frame: slideFrame)
        let textView = UITextView(frame: CGRect(x: 20, y: 60, width: 400, height: 100))
        textView.text = textSlides[0]
        textView.isEditable = false
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.white
        textView.backgroundColor = self.backgroundColor
        textView.font = UIFont(name: "Helvetica Neue", size: 20)
        subView.addSubview(textView)
        self.scrollView.addSubview(subView)
    }
    
    func prepareSlide(_ index: Int) {
        slideFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
        slideFrame.size = self.scrollView.frame.size
        
        let subView = UIView(frame: slideFrame)
        let textView = UITextView(frame: CGRect(x: 20, y: 60, width: 400, height: 100))
        textView.text = textSlides[index]
        textView.isEditable = false
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.white
        textView.backgroundColor = self.backgroundColor
        textView.font = UIFont(name: "Helvetica Neue", size: 20)
        subView.addSubview(textView)
        self.scrollView.addSubview(subView)
    }
    
//        // Image
//        let image = UIImage(named: "icone_swift")
//        swiftImage = UIImageView(image: image)
//        swiftImage.frame = CGRect(x: 245, y: 165, width: 150, height: 150)
//        addSubview(swiftImage)

    @objc func nextSlide() {
        self.pageControl.currentPage += 1
        changePage(sender: self)
    }

    @objc func previousSlide() {
        self.pageControl.currentPage -= 1
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
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

PlaygroundPage.current.liveView = MainView()
PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)

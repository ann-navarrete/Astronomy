import UIKit

class ViewController: UIViewController {
    
    var dateSelected: Date = Date()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var discoverDescription: UILabel!
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateSelected = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preferredDatePickerStyle = .inline
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(dateSelected)
        if(segue.identifier == "showDate") {
            let displayDate = segue.destination as! ImageViewController
            displayDate.date = dateSelected
        }
        
    }
}

extension UIButton {
    open override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}


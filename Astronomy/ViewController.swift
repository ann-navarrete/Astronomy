import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateSelected: Date = Date()
    
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


# SimpleDropdown

This is a simple dropdown that can be easily integrated into your app layout and customize the visual design to suit your design.

So you just need to import this library:
```swift
    import SimpleDropdown
```
create a dropdown instance in your code:
```swift
    let dropdownView = DropdownView(options: ["Option 1", "Option 2", "Option 3"], customCellType: CustomDropdownCell.self, customCellIdentifier: "cell", customHeaderView: CustomDropdownView())
```
make some constraints and use it.

You can also change the menu cells (UITableViewCell) to your own custom ones and configure them through the configurator function:
```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dropdownView.cellConfigurator = { cell, option in
            if let customCell = cell as? CustomDropdownCell {
               customCell.configure(
                   with: option,
                   icon: UIImage(systemName: "star"),
                   subtitle: "Subtitle for \(option)"
               )
           }
        }
    }
```
You can do the same with the header (UIView):
```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dropdownView.headerConfigurator = { customView, option in
            if let view = view as? CustomDropdownView {
                view.set(title: option)
            }
        }
    }
```
<img width="337" alt="Снимок экрана 2024-09-02 в 20 08 01" src="https://github.com/user-attachments/assets/4555091b-7616-423e-932e-2f0101c9eae1">

## Requirements

iOS 15+. Swift 5.5.

## Installation

SimpleDropdown is available through CocoaPods. To install it, simply add the following line to your Podfile:
```ruby
pod "SimpleDropdown"
```
SimpleDropdown is available through Carthage. To install it, simply add the following line to your Cartfile:
```ruby
github "idapgroup/SimpleDropdown"
```
## License

SimpleDropdown is available under the New BSD license. See the LICENSE file for more info.

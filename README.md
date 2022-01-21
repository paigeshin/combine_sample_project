```swift
import Foundation

struct Constants {

    struct URLs {

        static func weather(city: String) -> String { "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=yourapikey&units=imperial" }
        // celsius = metric

    }

}
```

```swift
import Foundation

struct WeatherResponse: Decodable {
    let main: Weather
}

struct Weather: Decodable {

    let temp: Double?
    let humidity: Double?

    static var placeholder: Weather {
        return Weather(temp: nil, humidity: nil)
    }

}
```

```swift
class Webservice {

    func fetchWeather(city: String) -> AnyPublisher<Weather, Error> {
        guard let url = URL(string: Constants.URLs.weather(city: city)) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { $0.main }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
```

```swift
import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!

    private var webservice: Webservice = Webservice()
    private var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPublishers()


        //        self.cancellable = self.webservice.fetchWeather(city: "Houston")
        //            .catch{_ in Just(Weather.placeholder)}
        //            .map { weather in
        //                if let temp = weather.temp {
        //                    return "\(temp)"
        //                } else {
        //                    return "Error getting weather!"
        //                }
        //            }
        //            .assign(to: \.text, on: self.temperatureLabel)


    }

    private func setupPublishers() {

        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self.cityTextField)

        self.cancellable = publisher.compactMap {
            ($0.object as! UITextField).text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        }.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .flatMap { city in
                return self.webservice.fetchWeather(city: city)
                    .catch { _ in Just(Weather.placeholder) }
                    .map { $0 }
            }.sink {

                if let temp = $0.temp {
                    self.temperatureLabel.text = "\(temp) ℉"
                } else {
                    self.temperatureLabel.text = ""
                }
            }
    }

}
```

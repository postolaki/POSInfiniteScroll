# POSInfiniteScroll

## Example

To run the example project clone the repo and run `pod install` from the Demo directory first.

## Requirements
- [x] Swift 5
- [x] iOS 10 or higher

## Installation

## CocoaPods

POSInfiniteScroll is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod POSInfiniteScroll
```

## Carthage
Add POSInfiniteScroll to your Cartfile:
```
github "postolaki/posinfinitescroll"
```

And then run:
```
carthage update or carthage update --use-xcframeworks
```

## Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding POSInfiniteScroll as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/postolaki/POSInfiniteScroll.git")
]
```


```swift
import POSInfiniteScroll
```

## InfiniteScroll
```swift
// setup infinite scroll
tableView.addInfiniteScroll { tableView in
    // finish infinite scroll animation
    tableView.finishInfiniteScroll()
}

collectionView.addInfiniteScroll { collectionView in
    // finish infinite scroll animation
    collectionView.reloadDataAndFinishInfIniteScroll()
}

tableView.shouldRemoveInfiniteScrollHandler = { _ in
    return condition to remove infinite scroll
}
```
#### Public methods and properties
```swift
func addInfiniteScroll(_ completion: @escaping (UITableView) -> Void)
func addInfiniteScroll(_ completion: @escaping (UICollectionView) -> Void)
func finishInfiniteScroll(_ completion: (() -> Void)? = nil)
func removeInfiniteScroll()

var infiniteScrollTriggerOffset: CGFloat
var shouldRemoveInfiniteScrollHandler: () -> Bool
```

#### Custom indicator
Custom indicator must conform to protocol `SpinnerViewProtocol`
```swift
protocol SpinnerViewProtocol: UIView {
    func startAnimating()
    func stopAnimating()
}

var infiniteScrollSpinnerView: SpinnerViewProtocol?
```

## PullToRefresh
```swift
// setup pull to refresh
tableView.addPullToRefresh { tableView in
    // finish pull to refresh animation
    tableView.finishPullToRefresh()
}

collectionView.addPullToRefresh { collectionView in
    // finish pull to refresh animation
    collectionView.reloadDataAndFinishPullToRefresh()
}
```

#### Public methods and properties
```swift
func beginPullToRefresh(_ completion: (() -> Void)? = nil)
func addPullToRefresh(_ completion: @escaping (UITableView) -> Void)
func addPullToRefresh(_ completion: @escaping (UICollectionView) -> Void)
func finishPullToRefresh(_ completion: (() -> Void)? = nil)
func removePullToRefresh()

var pullToRefreshTriggerOffset: CGFloat
```

#### Custom indicator
Custom indicator must conform to protocol `PullToRefreshSpinnerViewProtocol`
```swift
protocol PullToRefreshSpinnerViewProtocol: SpinnerViewProtocol {
    var progress: CGFloat { get set }
    var isAnimating: Bool { get }
}

var pullToRefreshSpinnerView: PullToRefreshSpinnerViewProtocol?
```

## Author

ivan.postolaki@gmail.com

## License

POSInfiniteScroll is available under the MIT license.

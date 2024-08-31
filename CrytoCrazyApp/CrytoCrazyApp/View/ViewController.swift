import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UIScrollViewDelegate  {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cryptoList = [Crypto]()
    let cryptoVM = CryptoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationController?.title = "Ana a"
       
    
        setupBinding()
        cryptoVM.requestData()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
 
  
    
    private func setupBinding() {
        
        cryptoVM.loading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Handle errors
        cryptoVM.error
            .observe(on: MainScheduler.instance)
            .do(onNext: { errorString in
                print("Error: \(errorString)")
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        // Update crypto list and reload table view
       /* cryptoVM.cryptos
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cryptos in
                self?.cryptoList = cryptos
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        */
                
       cryptoVM.cryptos.observe(on: MainScheduler.asyncInstance).bind(to: tableView.rx.items(cellIdentifier: "CryptoCell" ,cellType: CryptoTableViewCell.self)) { row,item,cell in
            cell.item = item
        }
        .disposed(by: disposeBag)
        
       
    }
    /*

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return
       */
       }


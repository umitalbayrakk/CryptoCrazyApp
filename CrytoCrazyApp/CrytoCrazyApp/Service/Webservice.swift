import Foundation

class Webservice {
    
    enum CryptoError : Error {
        case sarverError
        case parsingError
    }
    
    
    func downloadCurrencies(url:URL , completion:@escaping (Result<[Crypto],CryptoError>) -> () ){
        URLSession.shared.dataTask(with:url) { data, response, error in
            if error != nil {
                completion(.failure(CryptoError.sarverError))
            } else if let data = data {
                
                
            let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data)
                if let cryptoList = cryptoList {
                    completion(.success(cryptoList))
                }else {
                    completion(.failure(.parsingError))
                }
            }
        }.resume()
    }
}

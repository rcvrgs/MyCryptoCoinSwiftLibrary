import Alamofire

public struct CoinRetriever {
    private var apiKey: String;
    
    public init(apiKey: String) {
        self.apiKey = apiKey;
    }
    
    public func latestPrice(coins: [String], completionHandler: @escaping (Result< Coins, AFError>) -> Void) {
        let headers: HTTPHeaders = [
            "X-CMC_PRO_API_KEY": apiKey,
            "Accept": "application/json",
            "Accept-Encoding": "deflate, gzip"
        ]
        let parameters: Parameters = ["symbol": coins.joined(separator: ",")]
        AF.request("https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest", parameters: parameters, headers: headers).responseDecodable(of: Coins.self) { response in
            guard let coins = response.value else {
                completionHandler(.failure(response.error!))
                return
            }
            completionHandler(.success(coins))
        }
    }
}

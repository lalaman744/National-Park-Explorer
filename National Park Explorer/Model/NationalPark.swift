import Foundation

struct NationalParkResult: Decodable {
    let total: String
    let data: [NationalPark]
}

struct NationalPark: Decodable {
    let states: String
    let description: String
    let fullName: String
}

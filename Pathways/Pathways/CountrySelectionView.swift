//
//  CountrySelectionView.swift
//  Pathways
//
//  Created by Francisco Mestizo on 10/12/24.
//

import SwiftUI

struct CountrySelectionView: View {
    @Binding var selectedCountry: (name: String, flag: String)
    @State private var selectedIndex: Int = -1
    let countries: [(name: String, flag: String)] = getCountriesWithFlags()
    
    var body: some View {
        Picker("Country", selection: $selectedIndex) {
            Text("Select a country").tag(-1)
            ForEach(0..<countries.count, id: \.self) { index in
                Text("\(countries[index].flag) \(countries[index].name)")
                .tag(index)
            }
            .onChange(of: selectedIndex) { oldValue, newValue in
                if newValue >= 0 {
                    selectedCountry = countries[newValue]
                } else {
                    selectedCountry = (name: "", flag: "")
                }
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    CountrySelectionView(selectedCountry: .constant((name: "Italy", flag: "🇮🇹")))
}

//generate the full list of flags
func getCountriesWithFlags() -> [(name: String, flag: String)] {
    let isoRegions = Locale.Region.isoRegions
    var countries: [(name: String, flag: String)] = []
    
    for region in isoRegions {
        if let name = Locale.current.localizedString(forRegionCode: region.identifier),
           let flag = codeToFlagEmoji(code: region.identifier) {
            countries.append((name: name, flag: flag))
        }
    }
    
    return countries.sorted { $0.name < $1.name }
}

//Get the flag for each country
func codeToFlagEmoji(code: String) -> String? {
    guard code.count == 2 else { return nil } // Flags require 2-letter country codes
    let base: UInt32 = 127397 // Base value for regional indicator symbols
    var flag = ""
    for scalar in code.uppercased().unicodeScalars {
        flag.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
    }
    return flag
}

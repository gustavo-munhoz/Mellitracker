//
//  String+LocalizedKey.swift
//  Mellitracker
//
//  Created by Gustavo Munhoz Correa on 12/09/24.
//

import Foundation

extension String {
    
    /// Represents keys for localized strings in the app, allowing for dynamic localization with associated values.
    /// The cases should be 1-1 with `Localizable.xcstrings` keys.
    public enum LocalizedKey {
        // MARK: - Computed Properties
        
        /// Computes the key for localization by extracting the case name from the enum instance.
        /// Uses reflection to find the label of the first child of the enum case,
        /// which represents the case name without associated values.
        /// Falls back to the default description if no label is found.
        var key: String {
            if let nameRemovingValues = Mirror(reflecting: self).children.first?.label {
                return nameRemovingValues
            }
            
            return String(describing: self)
        }
        
        /// Computes an array of `CVarArg` suitable for string formatting,
        /// reflecting the associated values of the enum case.
        /// Uses reflection to access and cast the associated values to `CVarArg` for use in formatted strings.
        var values: [CVarArg] {
            let mirror = Mirror(reflecting: self)
            guard let associated = mirror.children.first?.value else { return [] }
            
            var extractedValues = [CVarArg]()
            let valuesMirror = Mirror(reflecting: associated)
            for child in valuesMirror.children {
                if let array = child.value as? [CVarArg] {
                    extractedValues.append(contentsOf: array)
                } else if let value = child.value as? CVarArg {
                    extractedValues.append(value)
                }
            }
            
            return extractedValues
        }
        
        case <#LocalizedKey#>
    }
    
    /// Returns a localized string using the key and associated values defined by the `LocalizedKey` enum.
    /// Utilizes the `NSLocalizedString` function to fetch the appropriate translation for the key,
    /// and formats it with any associated values using `String(format:arguments:)`.
    /// - Parameter key: The `LocalizedKey` enum case representing the localization key and its associated values.
    /// - Returns: A formatted, localized string.
    static public func localized(for key: LocalizedKey) -> String {
        String(format: NSLocalizedString(key.key, comment: ""), arguments: key.values)
    }
}


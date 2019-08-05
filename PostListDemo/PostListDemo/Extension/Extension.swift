//
//  Extension.swift
//  PostListDemo
//
//  Created by PCQ187 on 05/08/19.
//  Copyright © 2019 PCQ187. All rights reserved.
//

import UIKit

extension UITableView {
    private func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        register(UINib.init(nibName: String(describing: T.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: T.self))
    }
    func dequeueCellFromNIB<T: UITableViewCell>(_: T.Type) -> T {
        if let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T{
            return cell
        }else{
            register(T.self)
            return dequeueCellFromNIB(T.self)
        }
    }
}

extension String{
    var createdAtString: String {
        if self != "" {
            if let date = DateFormatter.sourceDateFormatter.date(from: self) as Date? {
                return "Created At " + DateFormatter.sourceDateFormatter.string(from: date)
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
}

extension DateFormatter{
    static var sourceDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static var destDateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
}

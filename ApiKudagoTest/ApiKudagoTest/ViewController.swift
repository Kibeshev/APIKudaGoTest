//
//  ViewController.swift
//  ApiKudagoTest
//
//  Created by Кирилл Кибешев on 02.03.2019.
//  Copyright © 2019 Кирилл Кибешев. All rights reserved.
//

import UIKit

class Event {
    
    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
}

class KudagoAPIManager {

    func getEvents(completion: @escaping ([Event]?) -> Void) {
        let urlString = "https://kudago.com/public-api/v1.4/events/?fields=id,dates,title,description,body_text,location,images,price,is_free&text_format=text"
        guard let url = URL(string: urlString) else {
            return
        }
        // Создаем задачу загрузки данных с сервера
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in // Замыкание
            // Вызывается не в главном потоке потому что под капотом переходит в бэкграунд поток
            
            // Проверяем не nil ли data
            if let data = data {
                // Преобразуем data в словарь [String: Any]
                let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                
                // Пытаемся вытащить массив результатов [[String: Any]] по ключу "results"
                if let results = dictionary??["results"] as? [[String: Any]] {
                    // Выводим этот массив консоль
                    print("results: \(results)")

                    // Создаем пустой массив под наши ивенты
                    var events: [Event] = []

                    // Проходим по массиву результатов
                    for element in results {
                        // Пытаемся получить title и description по их ключам и привести их к String
                        if let title = element["title"] as? String,
                            let description = element["description"] as? String {
                            // Создаем объект ивента
                            let event = Event(title: title, description: description)
                            // Добавляем его в массив events
                            events.append(event)
                        }
                    }
                    
                    // Выводим наш массив ивентов
                    print(events)
                    // Вызываем замыкание и передаем туда наши ивенты
                    completion(events)
                    // Обрываем выполнение функции чтобы комплишен ниже не вызвался
                    return
                }
            }
            
            completion(nil)
        }
        // Отправляем нашу задачу на выполнение
        task.resume()
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let manager = KudagoAPIManager()
    
    var events: [Event] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Это надо чтобы мы могли показывать наши данные в таблице
        tableView.delegate = self
        tableView.dataSource = self
        // Показываем индикатор загрузки
        activityIndicator.startAnimating()
        // Загружаем наши данные
        manager.getEvents(completion: { events in
            // Ещё не главный поток
            DispatchQueue.main.async { // Теперь главный поток
                // Присваиваем нашему свойству events ивенты
                self.events = events ?? [] // Если придет nil, то положим пустой массив []
                // Выключаем индикатор загрузки
                self.activityIndicator.stopAnimating()
                // -------
                // Тут нужно сделать tableView.reloadData()
                // Чтобы таблица перезагрузилась и нарисовала те events то что мы загрузили
                self.tableView.reloadData()
            }
        })
    }
    
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count // Тут напиши свой код
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as? KGCell
        
        let events2 = self.events[indexPath.row]
        
        
        cell?.labelTitle.text = events2.title
        cell?.labelDescriotions.text = events2.description
        
    
        
        
        
        
        
        
        
        
        
        return cell ?? UITableViewCell() // И тут тоже
        
     
        }
    }





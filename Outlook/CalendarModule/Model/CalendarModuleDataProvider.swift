//
//  CalendarModuleDataProvider.swift
//  Outlook
//
//  Created by abhishek dutt on 04/09/17.
//  Copyright © 2017 abhishek dutt. All rights reserved.
//

import Foundation

//check to add optional feature where needed
class CalendarModuleDataProvider {
    private var dateList = [CalendarModel]()
    
    private var startDate = DateModel.twoMonthsAgoDateModel
    private var endDate = DateModel.twoMonthsLaterDateModel
    
    var currentDateIndex: Int {
        let currentDateModel = CalendarModel(date: DateModel(), events: nil)
        return dateList.index(of: currentDateModel)!
    }
    
    func currentDayIndex(inCalendarList list: [CalendarModel]) -> Int {
        let currentDateModel = CalendarModel(date: DateModel(), events: nil)
        return list.index(of: currentDateModel)!
    }
    
    //handle other view element or create corresponding viewModel
    var currentDateList: [CalendarModel] {
        startDate.offsetToSunday()
        endDate.offsetToSaturday()
        
        createDateList(from: startDate,endDate: endDate)
        
        return dateList
    }
    
    //check custom iterator implementation
    func createDateList(from startDateModel: DateModel,endDate endDateModel: DateModel) {
        var startDateModel = startDateModel
        let endDateModel = endDateModel
        
        while startDateModel <= endDateModel {
            let list: [EventModel] = getStaticEventLists(eventDate: startDateModel.thisDate)
            dateList.append(CalendarModel(date: startDateModel, events: list))
            startDateModel.next()
        }
    }
    
    // TODO: remove code repeat
    func updateDateListForPreviousTwoMonths() -> [CalendarModel] {
        let previousStartDate = startDate
        var newList = [CalendarModel]()
        
        startDate.offsetDateModel(byMonth: -2)
        startDate.offsetToSunday()
        
        while startDate < previousStartDate {
            let list: [EventModel] = getStaticEventLists(eventDate: startDate.thisDate)
            newList.append(CalendarModel(date: startDate, events: list)) //add events accordingly from db
            startDate.next()
        }
        
        startDate = previousStartDate
        startDate.offsetDateModel(byMonth: -2)
        startDate.offsetToSunday()
        
        return updatedDateList(atStart: true, withList: newList)
    }
    
    func updateDateListForComingTwoMonths() -> [CalendarModel] {
        var previousEndDate = endDate
        var newList = [CalendarModel]()
        
        endDate.offsetDateModel(byMonth: 2)
        endDate.offsetToSaturday()
        
        previousEndDate.next()
        while previousEndDate <= endDate {
            let list: [EventModel] = getStaticEventLists(eventDate: previousEndDate.thisDate)
            newList.append(CalendarModel(date: previousEndDate, events: list))
            previousEndDate.next()
        }
        return updatedDateList(atStart: false, withList: newList)
    }
    
    private func updatedDateList(atStart: Bool, withList newList: [CalendarModel]) -> [CalendarModel] {
        var newList = newList
        
        if atStart {
            newList.append(contentsOf: dateList)
            dateList = newList
        }else {
            dateList.append(contentsOf: newList)
        }
        
        return dateList
    }
    
    private func getStaticEventLists(eventDate: Date) -> [EventModel] {
        let event1 =  EventModel.dummyEventModel3(eventDate: eventDate)
        let event2 =  EventModel.dummyEventModel1(eventDate: eventDate)
        let event3 =  EventModel.dummyEventModel2(eventDate: eventDate)
        
        var list = [EventModel]()
        
        // TODO: Have the list ordered
        list.append(event1)
        list.append(event2)
        list.append(event3)
        return list
    }
}

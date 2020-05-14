//
//  AppDelegate.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Personalización al iniciar la app
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //Evento que se llama cuando la app va a entrar en segundo plano, ideal para planear recursos
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Evento que se llama cuando la app entra en segundo plano
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Evento que se llama cuando el usuario vuelve a la app
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Evento que se llama cuando el usuario vuelve a la aplicación y es la activa
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //Evento que se llama cuando termine la aplicación
    }


}


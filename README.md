# SimpleMapApp
SimpleMapApp for interview purposes.

Introduction

Hello. First of all, thank you for giving me the opportunity to complete this sample project. I am excited to complete it. Although it is a simple project, there are a lot of possible features to add. I tried my best to show my skills and vision to you. 

In this document, I provided some information regarding the project. Let’s walk through the flow of the app. 


## App Flow

Launchscreen is simple. It tells the purpose of the app and navigates to the map with a button.

![Screen Shot 2022-09-24 at 23 21 05](https://user-images.githubusercontent.com/38487440/192117527-049851bb-10c8-4e2f-be03-1f2e6d47bb87.png)


After Launchscreen, there is a map and a floating search bar. User can search a place in this interface.

![Screen Shot 2022-09-24 at 23 21 35](https://user-images.githubusercontent.com/38487440/192117559-ccd9f5bb-c553-4683-b708-53a316742cc5.png)


During the search, the background goes a bit dark to enhance UX.
After searching something (e.g. coffee), the app shows the top 10 closest and relevant places to the user. 

![Screen Shot 2022-09-24 at 23 22 14](https://user-images.githubusercontent.com/38487440/192117579-7e3e5c4e-e685-4b60-8ae8-ec5d8846d294.png)

The user might click a pinned location and look up its category. 



## Design Pattern and Used Libraries

Firstly, I applied the MVVM design pattern. I used Alamofire to ease my networking and Floating Panel to enhance User Experience. Other tools and libraries are built-in libraries.

####  Alamofire, for networking
#### Floating Panel, for floating search panel to enhance UX
#### Core Data
#### Core Location
#### Mapkit



## Notes


Although the API provides more information such as distance and rating etc., I could not find a way to get the correct information from my model when a user clicks on a pin. Pin annotations only carry two information which is title and subtitle. I would be glad if we can discuss and find a way to solve this.



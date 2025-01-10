Digiwagon Company Flutter Assignment

--> Project Setup

1. Clone the repository to your laptop/pc.
   -> Run the following commands in your terminal to set up the project:
   flutter clean, flutter pub get, flutter run

-->Functionality Overview

1. Login/Register Screen:
   -> Upon running the app, you will be presented with a login/register screen.
   -> Enter your name and email to register a new user.
   -> Tap the Register button to navigate to the next screen.

2. Task Management Screen:
   -> On the second screen, you will see a task management interface.
   -> An Add Task button is located at the bottom of the screen. Tap it to add a new task.
   -> After adding a task, it will appear at the top of the screen, displayed by default in
   descending order (newest tasks first).
   -> Each task is displayed in a card view, Card contains Task title, priority tag and a checkbox
   to change status (Complete/Pending).

3. Task Derails Screen:
   -> On this screen displayed every details of selected task, and you will have the following
   options:
    1. Edit: Update task details, including changing the task's status (e.g., Pending or Complete
       and Priorities).
    2. Delete: Remove the task from the list.

4. Filtering Tasks:
   -> You can filter tasks based on their status (e.g., Pending or Complete) using the Status
   button.
   -> You can filter tasks based on their priorities (e.g., High, Medium, Low, All, Sort by due
   date ) using the Filter button.

5. Architecture and Technologies Used
   -> MVC (Model-View-Controller) architecture is implemented.
   -> SQLite and Hive are used for local data storage.
   -> GetX is used for state management.

-->Libraries Used

1. get
2. sqflite
3. hive
4. hive_flutter
5. uuid
6. intl
7. path

--> Explanation

   -> GetX: GetX is used to manage the state of your application, making it easy to sync data between the view (UI) and the model (logic/data).
            It allows you to easily maintain and update data, automatically reflecting changes in the UI when the data changes.


   -> I have have used two database libraries Hive and Sqflite.

      1. Hive: Used for storing small data like user preferences or settings (e.g., username, theme, or task
            sorting orders).

      2. Sqflit: Used for storing larger datasets like task lists, or other complex data that require more
            structured storage.

Thank you! Regards

# 📋 TaskManager – Personal Task Tracking App (Flutter + Firebase)

![Task Manager Preview](taskmanager1.jpg) 


<img src="taskmanager1.jpg" width="500" height= "800" />


![Task Manager Preview](taskmanager2.jpg)!

![Task Manager Preview](taskmanager3.jpg)-

![Task Manager Preview](taskmanager6.jpg)- ![Task Manager Preview](taskmanager5.jpg)  
![Task Manager Preview](taskmanager4.jpg)-

![Task Manager Preview](taskmanager7.jpg)  ![Task Manager Preview](taskmanager8.jpg) 
![Task Manager Preview](taskmanager9.jpg)  

![Task Manager Preview](taskmanager10.jpg) ![Task Manager Preview](taskmanager13.jpg) ![Task Manager Preview](taskmanager14.jpg) 

![Task Manager Preview](taskmanager11jpg.jpg) ![Task Manager Preview](taskmanager12.jpg) ![Task Manager Preview](taskmanager45jpg.jpg) 

**TaskManager** is a feature-rich, modern task management app built with **Flutter**, **Firebase**, and **Riverpod**. Designed with clean architecture and scalable code, it offers real-time task tracking, authentication, and task filtering—ideal for both productivity and as a demonstration of professional Flutter/Firebase development practices.

---

## 🎥 Demo

https://github.com/your-username/Taskmanager/assets/demo-video.mp4  
*👉 A full walkthrough showing login, task creation, filtering, and completion features.*

---

## 📸 Screenshots

| Login Page | Task List | Add Task | Filters |
|------------|-----------|----------|---------|
| ![login](assets/login.png) | ![list](assets/tasklist.png) | ![add](assets/addtask.png) | ![filters](assets/filters.png) |

---

## 🚀 Key Features

- 🔐 **Secure User Login** – Email & password authentication via Firebase
- 📋 **Personal Task Storage** – Each user's data is isolated and private
- ➕ **Create, Edit & Delete Tasks** – Full CRUD functionality
- ✅ **Toggle Task Completion** – Mark tasks as done or undone
- 🔍 **Advanced Filters** – Filter tasks by:
  - Priority (High, Medium, Low)
  - Status (Completed, Incomplete)
  - Tags
- ♻️ **Real-Time UI Updates** – Powered by `AsyncNotifier` from Riverpod
- 🔒 **Firestore Security Rules** – User data is safely restricted

---

## 🧑‍💻 Technologies Used

| Tech | Description |
|------|-------------|
| Flutter | Cross-platform UI toolkit |
| Firebase Auth | Authentication backend |
| Cloud Firestore | Realtime NoSQL database |
| Riverpod | State management with AsyncNotifier |
| Tuple | Lightweight data structure for filters |

---

## 📁 Project Structure

lib/
├── models/
│ └── TaskModel.dart # Data model
├── repository/
│ └── TaskRepository.dart # Firestore interaction layer
├── provider/
│ └── TaskProvider.dart # Riverpod logic (AsyncNotifier)
├── screens/
│ ├── LoginScreen.dart
│ └── HomeScreen.dart
└── main.dart # App entry point


✨ Future Enhancements
📅 Add due dates and calendar views

🔔 Push notifications for reminders

📊 Task analytics dashboard

🔎 Global search functionality

🌙 Dark mode support

🧑 Author
Sundram Awasthi
📧 [Insert Email]
🔗 GitHub • LinkedIn


📌 This project was created as part of a job/internship evaluation to demonstrate Flutter app development skills, clean architecture, and real-world Firebase integration.



ECOSHIELD+ : AI-Powered Women Safety Surveillance System

A real-time **audio-visual threat detection** system designed to enhance women's safety in public and private spaces using computer vision and sound analysis. The system detects potential violent events and panic sounds, instantly triggering alerts via email and storing relevant video evidence.


💡 Project Overview

This project integrates **YOLOv8-based video surveillance** with **audio threat recognition** to detect:

* **Physical aggression or fights** using motion heuristics and bounding box overlaps.
* **Panic sounds or screams** using microphone input and audio frequency spikes.

✅ Key Features

* Real-time detection of violent activity and distress sounds.
* Alert sound playback and emergency email notifications.
* Automatic location fetching using IP.
* Storage of incident video clips with timestamps.
* Designed for institutions, public areas, or home security.


🛠️ Tech Stack

| Component      | Technology Used                                              |
| -------------- | ------------------------------------------------------------ |
| Video Analysis | [YOLOv8](https://github.com/ultralytics/ultralytics), OpenCV |
| Audio Analysis | `pyaudio`, `numpy`, `scipy`                                  |
| Alerts         | `playsound`, `smtplib`, `email`, `requests`                  |
| Language       | Python                                                       |


📁 Project Structure

```
.
├── alert.mp3               # Sound played when violence is detected
├── dataset.mp4             # Input video or replace with webcam feed
├── detection.py            # Main script for video-based violence detection
├── safe.py                 # Audio-based panic scream detection
├── fight_videos/           # Folder to store saved incident clips
├── README.md               # Project documentation
```

⚙️ Setup & Installation

1. **Install Python Packages**

```bash
pip install opencv-python ultralytics playsound requests pyaudio numpy scipy
```

> For `pyaudio`, if you face installation issues, install using:

```bash
pip install pipwin
pipwin install pyaudio
```

2. **Add Required Files**

* Ensure `alert.mp3`, `dataset.mp4`, `safe.py`, and `detection.py` are in the project folder.

---

▶️ Running the Project

  🎥 Video Threat Detection

```bash
python detection.py
```

* Uses webcam or video file to detect suspicious movements.
* Displays bounding boxes and "Violence Detected" warning.
* Saves the incident clip and sends an email with location.

   🔊 Audio Threat Detection

```bash
python safe.py
```

* Listens for high-frequency panic sounds (e.g., screams).
* Triggers alerts and logs time of detection.

---

## 📧 Email Alert Configuration

Update the following variables in `detection.py`, `safe.py`:

```python
EMAIL_ADDRESS = 'your_email@gmail.com'
EMAIL_PASSWORD = 'your_app_password'
RECIPIENTS = ['recipient1@example.com', 'recipient2@example.com']
```

> Use a Gmail App Password (from [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)) for secure access.


📍 Location Detection

The system uses the IP address to fetch approximate user location:

```python
location = requests.get("https://ipinfo.io").json().get("loc")
```

Shared in the alert email as a **Google Maps link**.


🚀 Future Enhancements

* Integrate with a mobile app for real-time monitoring.
* Trigger alerts to local police or guardians via SMS/API.
* Deploy on Raspberry Pi for portable surveillance kits.


👥 Developed By

**Team Phoenix Pioneers**

* *Sunidhi*
* *Khushan Gowda G H*
* *Puneeth A S*
* *Dhanush R Kalkur*

> B.E. in AI & ML | JNNCE Shivamogga
> Hackathon Project: SHE Secure 2025

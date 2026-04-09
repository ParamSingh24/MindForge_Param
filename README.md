#  MindForge_Param

<p align="center">
  <b>A high-performance, cross-platform mobile architecture engineered for advanced multimodal processing.</b>
</p>

---

##  Overview
**MindForge_Param** leverages the **Google Gemini LLM ecosystem** to facilitate seamless real-time data extraction, voice interaction, and intelligent visual analysis. The system utilizes a **hybrid cloud-edge approach** to minimize latency while maximizing reliability.

---

##  Key Features

* ** Multimodal Intelligence:** Integrated with **Gemini 2.5 Flash Lite** for rapid, high-context data processing.
* ** Real-time OCR:** On-device computer vision for instant text extraction using **Google ML Kit**.
* ** Bilingual Voice Engine:** Native **STT** and **TTS** optimized specifically for `en-US` and `hi-IN` dialects.
* ** High-Availability Backend:** A resilient, **multi-tier proxy architecture** ensuring constant AI uptime through intelligent failover routing.

---

##  Technical Stack

### **Frontend & Core**
> **Framework:** `Flutter (Dart)`  
> **State Management:** `Provider`  
> **Security:** `Firebase Authentication`

### **Native Integrations**
* **Vision:** Google ML Kit Text Recognition API
* **STT:** `speech_to_text` (Live voice parsing)
* **TTS:** `flutter_tts` (Native platform dialect control)

### **Backend & AI Infrastructure**
* **AI Engine:** Gemini 2.5 Flash Lite API
* **Middleware:** Node.js / Express proxy microservice
* **Hosting:** Render (PaaS)
* **Failover Logic:** 1.  `Tier 1`: Direct API Tunnel
    2.  `Tier 2`: Hosted Proxy Server
    3.  `Tier 3`: Localized Device Regex Heuristics (Edge-fallback)

---

##  Build & Installation (Android)

### **Prerequisites**
* **Java JDK:** 21+ (Eclipse Adoptium recommended)
* **Flutter SDK:** Latest stable version
* **Android Studio:** Configured with SDK & Command-line Tools

### **Build Steps**

1. **Clone and Navigate**
   ```bash
   git clone [https://github.com/ParamSingh24/MindForge_Param.git](https://github.com/ParamSingh24/MindForge_Param.git)
   cd MindForge_Param

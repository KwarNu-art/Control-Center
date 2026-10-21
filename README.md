# Control-Center (iOS 26 Concept Tweak)  
  
A futuristic Control Center overhaul designed specifically for iPhone 7 Plus running iOS 14.0–15.8.x.  
  
### Features  
- **Liquid Acrylic Glass:** Real-time specular edge refraction and neon drop shadows.  
- **Cyber Capsule Sliders:** Continuous corner radii with live % numeric indicators.  
- **Fluid Spring Animations:** Staggered entrance and responsive touch physics.  
- **Rootless & Rootful Ready:** Native support for Dopamine, Palera1n, and Checkra1n.  
  
### Manual Local Build Instructions  
1. Install Theos: `bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"`  
2. Clone repository: `git clone https://github.com/your-username/Control-Center.git`  
3. Enter directory: `cd Control-Center`  
4. Build package: `make package FINALPACKAGE=1`  
5. Deploy to device: `make do THEOS_DEVICE_IP=192.168.1.X`

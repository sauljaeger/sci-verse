# SciVerse - 3D Science Model Scanner

A Flutter mobile application that uses camera-based text recognition to identify scientific terms and display corresponding 3D science models with detailed descriptions.

## 🔬 What it does

SciVerse transforms your mobile device into an intelligent science learning tool. Simply point your camera at text containing scientific terms from physics, chemistry, or biology, and the app will:

1. **Scan and recognize text** using OCR (Optical Character Recognition)
2. **Identify scientific keywords** from the detected text
3. **Display relevant 3D science models** with visual representations
4. **Provide educational descriptions** for each identified concept

## 📱 Features

### Text Recognition
- Real-time camera preview for text scanning
- Advanced OCR technology powered by Google ML Kit
- Instant text detection and processing
- Support for various text formats and fonts

### Science Model Library
The app includes pre-loaded models covering:

#### 🔵 Physics
- **Newton's Cradle** - Conservation of momentum and energy
- **Electric Motor** - Basic motor functionality and components
- **Magnetic Field Lines** - 3D visualization of magnetic fields
- **Telescope Model** - Optical arrangements and lens systems
- **Gyroscope** - Angular momentum and precession principles

#### 🟢 Biology
- **DNA Double Helix** - Genetic structure and base pairing
- **Animal Cell** - Cellular organelles and functions
- **Human Heart** - Cardiac chambers and circulation
- **Neuron Structure** - Neural components and synapses
- **Plant Cell** - Photosynthesis and cellular structures

#### 🟠 Chemistry
- **Molecular Structures** - Water, methane, and organic compounds
- **Periodic Table** - 3D elemental visualization
- **Crystal Lattice** - Ionic and covalent crystal structures
- **Chemical Reactions** - Reactant and product interactions
- **Bunsen Burner** - Laboratory equipment components

### User Interface
- **Clean, modern design** with category-specific color coding
- **Intuitive camera controls** with floating action button
- **Real-time feedback** showing detected text
- **Responsive layout** optimized for mobile devices
- **Error handling** with helpful user messages

## 🛠️ Technical Stack

- **Framework**: Flutter
- **Text Recognition**: Google ML Kit Text Recognition
- **Camera**: Flutter Camera Plugin
- **State Management**: Provider pattern with theme support
- **Platform**: Android & iOS compatible

## 📋 Requirements

- Flutter SDK (latest stable version)
- Android Studio / Xcode for development
- Physical device with camera (recommended for testing)
- Minimum Android API level 21 / iOS 10.0

## 🚀 Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd sciverse
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add science model images**
   - Create an `assets` folder in your project root
   - Add the following image files:
     - `newtons_cradle.jpeg`
     - `electric_motor.jpg`
     - `magnetic_field.jpeg`
     - `telescope.jpeg`
     - `gyroscope.jpeg`
     - `dna_helix.jpeg`
     - `animal_cell.jpeg`
     - `human_heart.jpg`
     - `neuron.jpeg`
     - `plant_cell.jpeg`
     - `molecule_water.jpeg`
     - `periodic_table.jpeg`
     - `crystal_lattice.jpeg`
     - `chemical_reaction.jpeg`
     - `bunsen_burner.jpeg`

4. **Update pubspec.yaml**
   ```yaml
   flutter:
     assets:
       - assets/
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 📖 How to Use

1. **Launch the app** - The camera will initialize automatically
2. **Point your camera** at any text containing scientific terms
3. **Tap the camera button** to capture and analyze the text
4. **View the results** - Matching science models will appear below the camera view
5. **Explore the model** - See the 3D visualization and read the educational description

## 🎯 Supported Keywords

The app recognizes various scientific terms including:
- **Physics**: newton, momentum, motor, magnet, lens, telescope, gyroscope
- **Biology**: dna, cell, heart, neuron, chloroplast, mitochondria, synapse
- **Chemistry**: molecule, water, element, crystal, reaction, bunsen, ionic

## 🔄 Future Enhancements

- [ ] AR (Augmented Reality) integration for true 3D model viewing
- [ ] Interactive 3D models with rotation and zoom
- [ ] Audio descriptions and pronunciations
- [ ] Quiz mode for educational assessment
- [ ] Bookmark favorite models
- [ ] Offline model database expansion
- [ ] Multi-language support
- [ ] Cloud-based model library

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:
- Adding new science models
- Improving text recognition accuracy
- Enhancing UI/UX design
- Bug fixes and optimizations

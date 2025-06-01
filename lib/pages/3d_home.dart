import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  TextRecognizer? _textRecognizer;
  bool _isDetecting = false;
  String _detectedText = '';
  ScienceModel? _currentModel;

  final Map<String, ScienceModel> _predefinedModels = {
    // Physics Models
    'newton cradle': ScienceModel(
      name: 'Newton\'s Cradle',
      description: 'Demonstrates conservation of momentum and energy',
      imagePath: 'assets/newtons_cradle.jpeg',
      category: 'Physics',
    ),
    'newton': ScienceModel(
      name: 'Newton\'s Cradle',
      description: 'Demonstrates conservation of momentum and energy',
      imagePath: 'assets/newtons_cradle.jpeg',
      category: 'Physics',
    ),
    'momentum': ScienceModel(
      name: 'Newton\'s Cradle',
      description: 'Demonstrates conservation of momentum and energy',
      imagePath: 'assets/newtons_cradle.jpeg',
      category: 'Physics',
    ),
    'electric motor': ScienceModel(
      name: 'Electric Motor',
      description: 'Basic working model of a simple motor',
      imagePath: 'assets/electric_motor.jpg',
      category: 'Physics',
    ),
    'motor': ScienceModel(
      name: 'Electric Motor',
      description: 'Basic working model of a simple motor',
      imagePath: 'assets/electric_motor.jpg',
      category: 'Physics',
    ),
    'magnetic field': ScienceModel(
      name: 'Magnetic Field Lines',
      description: '3D representation of field lines around a bar magnet',
      imagePath: 'assets/magnetic_field.jpeg',
      category: 'Physics',
    ),
    'magnet': ScienceModel(
      name: 'Magnetic Field Lines',
      description: '3D representation of field lines around a bar magnet',
      imagePath: 'assets/magnetic_field.jpeg',
      category: 'Physics',
    ),
    'telescope': ScienceModel(
      name: 'Telescope Model',
      description: 'Showing the arrangement of lenses/mirrors',
      imagePath: 'assets/telescope.jpeg',
      category: 'Physics',
    ),
    'lens': ScienceModel(
      name: 'Telescope Model',
      description: 'Showing the arrangement of lenses/mirrors',
      imagePath: 'assets/telescope.jpeg',
      category: 'Physics',
    ),
    'gyroscope': ScienceModel(
      name: 'Gyroscope',
      description: 'Illustrating angular momentum and precession',
      imagePath: 'assets/gyroscope.jpeg',
      category: 'Physics',
    ),

    // Biology Models
    'dna': ScienceModel(
      name: 'DNA Double Helix',
      description: 'Colorful spiral model showing base pairing',
      imagePath: 'assets/dna_helix.jpeg',
      category: 'Biology',
    ),
    'double helix': ScienceModel(
      name: 'DNA Double Helix',
      description: 'Colorful spiral model showing base pairing',
      imagePath: 'assets/dna_helix.jpeg',
      category: 'Biology',
    ),
    'genetic': ScienceModel(
      name: 'DNA Double Helix',
      description: 'Colorful spiral model showing base pairing',
      imagePath: 'assets/dna_helix.jpeg',
      category: 'Biology',
    ),
    'animal cell': ScienceModel(
      name: 'Animal Cell',
      description: 'Labeled model with organelles like mitochondria and nucleus',
      imagePath: 'assets/animal_cell.jpeg',
      category: 'Biology',
    ),
    'cell': ScienceModel(
      name: 'Animal Cell',
      description: 'Labeled model with organelles like mitochondria and nucleus',
      imagePath: 'assets/animal_cell.jpeg',
      category: 'Biology',
    ),
    'mitochondria': ScienceModel(
      name: 'Animal Cell',
      description: 'Labeled model with organelles like mitochondria and nucleus',
      imagePath: 'assets/animal_cell.jpeg',
      category: 'Biology',
    ),
    'heart': ScienceModel(
      name: 'Human Heart',
      description: 'Chambers, valves, and blood flow paths',
      imagePath: 'assets/human_heart.jpg',
      category: 'Biology',
    ),
    'cardiac': ScienceModel(
      name: 'Human Heart',
      description: 'Chambers, valves, and blood flow paths',
      imagePath: 'assets/human_heart.jpg',
      category: 'Biology',
    ),
    'circulation': ScienceModel(
      name: 'Human Heart',
      description: 'Chambers, valves, and blood flow paths',
      imagePath: 'assets/human_heart.jpg',
      category: 'Biology',
    ),
    'neuron': ScienceModel(
      name: 'Neuron',
      description: 'Showing dendrites, axon, and synapses',
      imagePath: 'assets/neuron.jpeg',
      category: 'Biology',
    ),
    'nerve': ScienceModel(
      name: 'Neuron',
      description: 'Showing dendrites, axon, and synapses',
      imagePath: 'assets/neuron.jpeg',
      category: 'Biology',
    ),
    'synapse': ScienceModel(
      name: 'Neuron',
      description: 'Showing dendrites, axon, and synapses',
      imagePath: 'assets/neuron.jpeg',
      category: 'Biology',
    ),
    'plant cell': ScienceModel(
      name: 'Plant Cell',
      description: '3D cross-section with chloroplasts and cell wall',
      imagePath: 'assets/plant_cell.jpeg',
      category: 'Biology',
    ),
    'chloroplast': ScienceModel(
      name: 'Plant Cell',
      description: '3D cross-section with chloroplasts and cell wall',
      imagePath: 'assets/plant_cell.jpeg',
      category: 'Biology',
    ),
    'photosynthesis': ScienceModel(
      name: 'Plant Cell',
      description: '3D cross-section with chloroplasts and cell wall',
      imagePath: 'assets/plant_cell.jpeg',
      category: 'Biology',
    ),

    // Chemistry Models
    'molecule': ScienceModel(
      name: 'Molecular Structures',
      description: 'Water, methane, glucose molecules',
      imagePath: 'assets/molecule_water.jpeg',
      category: 'Chemistry',
    ),
    'water molecule': ScienceModel(
      name: 'Water Molecule',
      description: 'H2O molecular structure',
      imagePath: 'assets/molecule_water.jpeg',
      category: 'Chemistry',
    ),
    'h2o': ScienceModel(
      name: 'Water Molecule',
      description: 'H2O molecular structure',
      imagePath: 'assets/molecule_water.jpeg',
      category: 'Chemistry',
    ),
    'water': ScienceModel(
      name: 'Water Molecule',
      description: 'H2O molecular structure',
      imagePath: 'assets/molecule_water.jpeg',
      category: 'Chemistry',
    ),
    'periodic table': ScienceModel(
      name: 'Periodic Table 3D Block',
      description: 'Each element as a 3D cube',
      imagePath: 'assets/periodic_table.jpeg',
      category: 'Chemistry',
    ),
    'element': ScienceModel(
      name: 'Periodic Table 3D Block',
      description: 'Each element as a 3D cube',
      imagePath: 'assets/periodic_table.jpeg',
      category: 'Chemistry',
    ),
    'crystal lattice': ScienceModel(
      name: 'Crystal Lattice',
      description: 'Model of ionic/covalent crystals (NaCl lattice)',
      imagePath: 'assets/crystal_lattice.jpeg',
      category: 'Chemistry',
    ),
    'crystal': ScienceModel(
      name: 'Crystal Lattice',
      description: 'Model of ionic/covalent crystals (NaCl lattice)',
      imagePath: 'assets/crystal_lattice.jpeg',
      category: 'Chemistry',
    ),
    'ionic': ScienceModel(
      name: 'Crystal Lattice',
      description: 'Model of ionic/covalent crystals (NaCl lattice)',
      imagePath: 'assets/crystal_lattice.jpeg',
      category: 'Chemistry',
    ),
    'chemical reaction': ScienceModel(
      name: 'Chemical Reaction',
      description: 'Animated 3D model showing reactants and products',
      imagePath: 'assets/chemical_reaction.jpeg',
      category: 'Chemistry',
    ),
    'reaction': ScienceModel(
      name: 'Chemical Reaction',
      description: 'Animated 3D model showing reactants and products',
      imagePath: 'assets/chemical_reaction.jpeg',
      category: 'Chemistry',
    ),
    'bunsen burner': ScienceModel(
      name: 'Bunsen Burner',
      description: 'Functional model with labeled parts',
      imagePath: 'assets/bunsen_burner.jpeg',
      category: 'Chemistry',
    ),
    'burner': ScienceModel(
      name: 'Bunsen Burner',
      description: 'Functional model with labeled parts',
      imagePath: 'assets/bunsen_burner.jpeg',
      category: 'Chemistry',
    ),
  };

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _textRecognizer = TextRecognizer();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) return;

    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized || _isDetecting) {
      return;
    }

    setState(() => _isDetecting = true);

    try {
      final XFile image = await _controller!.takePicture();
      final InputImage inputImage = InputImage.fromFilePath(image.path);

      final RecognizedText recognizedText = await _textRecognizer!.processImage(inputImage);

      String detectedText = recognizedText.text.toLowerCase();
      setState(() => _detectedText = detectedText);

      // Search for matching models
      ScienceModel? matchedModel = _findMatchingModel(detectedText);

      if (matchedModel != null) {
        setState(() => _currentModel = matchedModel);
      } else {
        setState(() => _currentModel = null);
        _showSnackBar('No matching science model found for the detected text');
      }
    } catch (e) {
      print('Error during text recognition: $e');
    } finally {
      setState(() => _isDetecting = false);
    }
  }

  ScienceModel? _findMatchingModel(String text) {
    for (String key in _predefinedModels.keys) {
      if (text.contains(key)) {
        return _predefinedModels[key];
      }
    }
    return null;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Science Scanner'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                CameraPreview(_controller!),
                if (_isDetecting)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _detectedText.isEmpty ? 'Point camera at text to scan' : _detectedText,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _currentModel != null
                ? _buildImageViewer()
                : const Center(
              child: Text(
                'Scan text to display science models',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndAnalyze,
        backgroundColor: Colors.deepPurple,
        child: _isDetecting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildImageViewer() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: _getCategoryColor(_currentModel!.category),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(_currentModel!.category),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentModel!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _currentModel!.category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Image.asset(
                  _currentModel!.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(_currentModel!.category),
                          size: 64,
                          color: _getCategoryColor(_currentModel!.category),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Image not found\nPlace image at:\n${_currentModel!.imagePath}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Text(
                _currentModel!.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'physics':
        return Colors.blue;
      case 'biology':
        return Colors.green;
      case 'chemistry':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'physics':
        return Icons.science;
      case 'biology':
        return Icons.biotech;
      case 'chemistry':
        return Icons.science_outlined;
      default:
        return Icons.threed_rotation;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer?.close();
    super.dispose();
  }
}

class ScienceModel {
  final String name;
  final String description;
  final String imagePath;
  final String category;

  ScienceModel({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.category,
  });
}
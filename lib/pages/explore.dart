//
// // screens/explore_screen.dart
// import 'dart:async';
//
// import 'package:ar_flutter_plugin/models/ar_anchor.dart';
// import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
// import 'package:ar_flutter_plugin/models/ar_node.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
// import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
// import 'package:permission_handler/permission_handler.dart';
//
// class ExploreScreen extends StatefulWidget {
//   @override
//   _ExploreScreenState createState() => _ExploreScreenState();
// }
//
// class _ExploreScreenState extends State<ExploreScreen>
//     with TickerProviderStateMixin {
//   // AR Controllers
//   ARSessionManager? arSessionManager;
//   ARObjectManager? arObjectManager;
//   ARAnchorManager? arAnchorManager;
//   ARLocationManager? arLocationManager;
//
//   // Camera and Text Recognition
//   CameraController? cameraController;
//   late List<CameraDescription> cameras;
//   final TextRecognizer textRecognizer = TextRecognizer();
//
//   // Animation Controllers
//   late AnimationController _fadeController;
//   late AnimationController _pulseController;
//   late AnimationController _scanController;
//
//   // State variables
//   bool isARMode = false;
//   bool isARReady = false;
//   bool isScanning = true;
//   bool isCameraInitialized = false;
//   String detectedText = '';
//   String statusMessage = 'Point camera at text';
//   List<String> placedObjects = [];
//   List<ARNode> placedNodes = []; // Track individual nodes
//   List<ARPlaneAnchor> placedAnchors = []; // Track individual anchors
//   bool isProcessingImage = false;
//
//   // Text scanning overlay animation
//   double scanLinePosition = 0.0;
//
//   // Colors for different objects based on text content
//   final Map<String, Color> objectColors = {
//     'nature': Colors.green,
//     'technology': Colors.blue,
//     'animal': Colors.orange,
//     'food': Colors.red,
//     'vehicle': Colors.purple,
//     'building': Colors.grey,
//     'default': Colors.cyan,
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _pulseController = AnimationController(
//       duration: Duration(milliseconds: 1000),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _scanController = AnimationController(
//       duration: Duration(milliseconds: 2000),
//       vsync: this,
//     )..repeat();
//
//     _scanController.addListener(() {
//       setState(() {
//         scanLinePosition = _scanController.value;
//       });
//     });
//
//     _initializeCamera();
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _pulseController.dispose();
//     _scanController.dispose();
//     cameraController?.dispose();
//     textRecognizer.close();
//     arSessionManager?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initializeCamera() async {
//     final status = await Permission.camera.request();
//     if (!status.isGranted) {
//       setState(() {
//         statusMessage = 'Camera permission required';
//       });
//       return;
//     }
//
//     cameras = await availableCameras();
//     cameraController = CameraController(
//       cameras[0],
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     try {
//       await cameraController!.initialize();
//       setState(() {
//         isCameraInitialized = true;
//         statusMessage = 'Point camera at text';
//       });
//       _startTextRecognition();
//     } catch (e) {
//       setState(() {
//         statusMessage = 'Camera initialization failed';
//       });
//     }
//   }
//
//   void _startTextRecognition() {
//     if (!isCameraInitialized || isProcessingImage) return;
//
//     Timer.periodic(Duration(milliseconds: 1500), (timer) {
//       if (!mounted || isARMode || isProcessingImage) {
//         timer.cancel();
//         return;
//       }
//       _captureAndProcessImage();
//     });
//   }
//
//   Future<void> _captureAndProcessImage() async {
//     if (!isCameraInitialized || isProcessingImage) return;
//
//     setState(() {
//       isProcessingImage = true;
//     });
//
//     try {
//       final XFile image = await cameraController!.takePicture();
//       final InputImage inputImage = InputImage.fromFilePath(image.path);
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//
//       String allText = recognizedText.text.trim();
//
//       if (allText.isNotEmpty && allText != detectedText) {
//         setState(() {
//           detectedText = allText;
//           statusMessage = 'Text detected: ${_getObjectType(allText)}';
//         });
//
//         HapticFeedback.mediumImpact();
//
//         // Auto-switch to AR mode after a short delay
//         Future.delayed(Duration(milliseconds: 1500), () {
//           if (!isARMode && mounted) {
//             _toggleMode();
//           }
//         });
//       }
//     } catch (e) {
//       print('Error processing image: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           isProcessingImage = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Main content
//           isARMode ? _buildARView() : _buildTextScannerView(),
//
//           // Overlay UI
//           _buildOverlay(),
//
//           // Control buttons
//           _buildControls(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextScannerView() {
//     if (!isCameraInitialized) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: Colors.green),
//             SizedBox(height: 20),
//             Text(
//               'Initializing Camera...',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Stack(
//       children: [
//         CameraPreview(cameraController!),
//
//         // Scanning overlay
//         CustomPaint(
//           size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
//           painter: TextScannerOverlayPainter(
//             scanLinePosition: scanLinePosition,
//             isProcessing: isProcessingImage,
//           ),
//         ),
//
//         // Text detection zones
//         Center(
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             height: MediaQuery.of(context).size.height * 0.4,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.green.withOpacity(0.8),
//                 width: 3,
//               ),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Center(
//               child: Text(
//                 'Point text here',
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   shadows: [
//                     Shadow(
//                       color: Colors.black.withOpacity(0.8),
//                       blurRadius: 4,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildARView() {
//     return ARView(
//       onARViewCreated: _onARViewCreated,
//       planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
//     );
//   }
//
//   Widget _buildOverlay() {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 20,
//       left: 20,
//       right: 20,
//       child: AnimatedBuilder(
//         animation: _fadeController,
//         builder: (context, child) {
//           return Container(
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.8),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isARMode ? Colors.blue : Colors.green,
//                 width: 2,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: (isARMode ? Colors.blue : Colors.green).withOpacity(0.3),
//                   blurRadius: 15,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     AnimatedBuilder(
//                       animation: _pulseController,
//                       builder: (context, child) {
//                         return Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(
//                             color: (isARMode ? Colors.blue : Colors.green)
//                                 .withOpacity(0.5 + 0.5 * _pulseController.value),
//                             shape: BoxShape.circle,
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       isARMode ? 'Explore AR Active' : 'Text Scanner',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (isProcessingImage && !isARMode) ...[
//                       SizedBox(width: 12),
//                       SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   statusMessage,
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 16,
//                   ),
//                 ),
//                 if (detectedText.isNotEmpty) ...[
//                   SizedBox(height: 8),
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       'Detected: ${detectedText.length > 50 ? detectedText.substring(0, 50) + "..." : detectedText}',
//                       style: TextStyle(
//                         color: Colors.green[200],
//                         fontSize: 14,
//                         fontFamily: 'monospace',
//                       ),
//                     ),
//                   ),
//                 ],
//                 if (placedObjects.isNotEmpty) ...[
//                   SizedBox(height: 8),
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.purple.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       'AR Objects: ${placedObjects.length}',
//                       style: TextStyle(
//                         color: Colors.purple[200],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildControls() {
//     return Positioned(
//       bottom: MediaQuery.of(context).padding.bottom + 30,
//       left: 20,
//       right: 20,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildControlButton(
//             icon: isARMode ? Icons.text_fields : Icons.view_in_ar,
//             label: isARMode ? 'Text Mode' : 'AR Mode',
//             color: isARMode ? Colors.orange : Colors.blue,
//             onPressed: _toggleMode,
//           ),
//           _buildControlButton(
//             icon: Icons.clear_all,
//             label: 'Clear',
//             color: Colors.red,
//             onPressed: _clearARObjects,
//           ),
//           _buildControlButton(
//             icon: Icons.refresh,
//             label: 'Reset',
//             color: Colors.purple,
//             onPressed: _resetApp,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.4),
//                 blurRadius: 15,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: FloatingActionButton(
//             heroTag: label,
//             onPressed: onPressed,
//             backgroundColor: color,
//             child: Icon(icon, color: Colors.white, size: 28),
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
//     this.arSessionManager = arSessionManager;
//     this.arObjectManager = arObjectManager;
//     this.arAnchorManager = arAnchorManager;
//     this.arLocationManager = arLocationManager;
//
//     this.arSessionManager!.onInitialize(
//       showFeaturePoints: false,
//       showPlanes: true,
//       customPlaneTexturePath: null,
//       showWorldOrigin: false,
//       handleTaps: true,
//     );
//
//     this.arObjectManager!.onInitialize();
//
//     this.arSessionManager!.onPlaneOrPointTap = _onPlaneOrPointTapped;
//
//     setState(() {
//       isARReady = true;
//       if (isARMode) {
//         statusMessage = 'Tap on surfaces to place objects';
//       }
//     });
//   }
//
//   void _onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) {
//     if (hitTestResults.isNotEmpty && arObjectManager != null) {
//       _addARObject(hitTestResults.first);
//       HapticFeedback.lightImpact();
//     }
//   }
//
//   void _addARObject(ARHitTestResult hitResult) {
//     final objectType = _getObjectType(detectedText.isNotEmpty ? detectedText : 'default');
//     final objectName = '${objectType}_${DateTime.now().millisecondsSinceEpoch}';
//
//     // Create AR node based on detected text content
//     ARNode node = _createNodeFromText(objectType);
//
//     // Add anchor and object to AR scene
//     final anchor = ARPlaneAnchor(transformation: hitResult.worldTransform);
//     arAnchorManager!.addAnchor(anchor).then((didAddAnchor) {
//       if (didAddAnchor!) {
//         arObjectManager!.addNode(node, planeAnchor: anchor).then((didAddNode) {
//           if (didAddNode!) {
//             placedObjects.add(objectName);
//             placedNodes.add(node); // Track the node
//             placedAnchors.add(anchor); // Track the anchor
//             setState(() {
//               statusMessage = 'Placed ${objectType} - Total: ${placedObjects.length}';
//             });
//           }
//         });
//       }
//     });
//   }
//
//   ARNode _createNodeFromText(String objectType) {
//     switch (objectType) {
//       case 'nature':
//         return ARNode(
//           type: NodeType.webGLB,
//           uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
//           scale: vector.Vector3(0.15, 0.3, 0.15),
//           position: vector.Vector3(0.0, 0.0, 0.0),
//           rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//         );
//       case 'technology':
//         return ARNode(
//           type: NodeType.webGLB,
//           uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
//           scale: vector.Vector3(0.2, 0.1, 0.3),
//           position: vector.Vector3(0.0, 0.0, 0.0),
//           rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//         );
//       case 'animal':
//         return ARNode(
//           type: NodeType.webGLB,
//           uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Sphere/glTF-Binary/Sphere.glb",
//           scale: vector.Vector3(0.2, 0.2, 0.2),
//           position: vector.Vector3(0.0, 0.0, 0.0),
//           rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//         );
//       case 'food':
//         return ARNode(
//           type: NodeType.webGLB,
//           uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Cylinder/glTF-Binary/Cylinder.glb",
//           scale: vector.Vector3(0.15, 0.1, 0.15),
//           position: vector.Vector3(0.0, 0.0, 0.0),
//           rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//         );
//       case 'vehicle':
//         return ARNode(
//           type: NodeType.webGLB,
//           uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
//           scale: vector.Vector3(0.3, 0.1, 0.15),
//           position: vector.Vector3(0.0, 0.0, 0.0),
//           rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//         );
//       case 'building':
//         return ARNode(
//           type: NodeType.webGLB,
//           uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
//           scale: vector.Vector3(0.2, 0.4, 0.2),
//           position: vector.Vector3(0.0, 0.0, 0.0),
//           rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//         );
//       default:
//         return ARNode(
//           type: NodeType.webGLB,
//           uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
//           scale: vector.Vector3(0.2, 0.2, 0.2),
//           position: vector.Vector3(0.0, 0.0, 0.0),
//           rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
//         );
//     }
//   }
//
//   String _getObjectType(String text) {
//     final lowerText = text.toLowerCase();
//
//     // Nature keywords
//     if (lowerText.contains(RegExp(r'\b(tree|flower|plant|garden|nature|leaf|grass|forest)\b'))) {
//       return 'nature';
//     }
//     // Technology keywords
//     if (lowerText.contains(RegExp(r'\b(computer|phone|technology|digital|software|app|internet|code)\b'))) {
//       return 'technology';
//     }
//     // Animal keywords
//     if (lowerText.contains(RegExp(r'\b(cat|dog|bird|animal|pet|fish|horse|cow|elephant)\b'))) {
//       return 'animal';
//     }
//     // Food keywords
//     if (lowerText.contains(RegExp(r'\b(food|eat|restaurant|pizza|burger|cake|bread|fruit)\b'))) {
//       return 'food';
//     }
//     // Vehicle keywords
//     if (lowerText.contains(RegExp(r'\b(car|truck|vehicle|bus|train|plane|motorcycle|bike)\b'))) {
//       return 'vehicle';
//     }
//     // Building keywords
//     if (lowerText.contains(RegExp(r'\b(house|building|home|office|school|hospital|hotel|store)\b'))) {
//       return 'building';
//     }
//
//     return 'default';
//   }
//
//   void _toggleMode() {
//     HapticFeedback.mediumImpact();
//     setState(() {
//       isARMode = !isARMode;
//       if (isARMode) {
//         statusMessage = isARReady
//             ? 'Tap on surfaces to place objects'
//             : 'Initializing AR...';
//         cameraController?.pausePreview();
//       } else {
//         statusMessage = 'Point camera at text';
//         cameraController?.resumePreview();
//         _startTextRecognition();
//       }
//     });
//     _fadeController.forward().then((_) => _fadeController.reverse());
//   }
//
//   void _clearARObjects() {
//     if (arObjectManager != null && placedObjects.isNotEmpty) {
//       // Remove all nodes individually
//       for (ARNode node in placedNodes) {
//         arObjectManager!.removeNode(node);
//       }
//
//       // Remove all anchors individually
//       for (ARPlaneAnchor anchor in placedAnchors) {
//         arAnchorManager!.removeAnchor(anchor);
//       }
//
//       // Clear all tracking lists
//       placedObjects.clear();
//       placedNodes.clear();
//       placedAnchors.clear();
//
//       setState(() {
//         statusMessage = 'AR objects cleared';
//       });
//
//       HapticFeedback.heavyImpact();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('All objects cleared'),
//           backgroundColor: Colors.red,
//           duration: Duration(milliseconds: 1500),
//         ),
//       );
//     }
//   }
//
//   void _resetApp() {
//     HapticFeedback.heavyImpact();
//     _clearARObjects();
//     setState(() {
//       detectedText = '';
//       isARMode = false;
//       statusMessage = 'Point camera at text';
//     });
//     cameraController?.resumePreview();
//     _startTextRecognition();
//   }
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (cameraController != null) {
//       cameraController!.pausePreview();
//       cameraController!.resumePreview();
//     }
//   }
// }
//
// // Custom painter for text scanner overlay
// class TextScannerOverlayPainter extends CustomPainter {
//   final double scanLinePosition;
//   final bool isProcessing;
//
//   TextScannerOverlayPainter({
//     required this.scanLinePosition,
//     required this.isProcessing,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.green.withOpacity(0.3)
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//
//     // Draw scanning area
//     final scanRect = Rect.fromCenter(
//       center: Offset(size.width / 2, size.height / 2),
//       width: size.width * 0.8,
//       height: size.height * 0.4,
//     );
//
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(scanRect, Radius.circular(16)),
//       paint,
//     );
//
//     // Draw scanning line
//     if (!isProcessing) {
//       final scanLinePaint = Paint()
//         ..color = Colors.green
//         ..strokeWidth = 3;
//
//       final lineY = scanRect.top + (scanRect.height * scanLinePosition);
//       canvas.drawLine(
//         Offset(scanRect.left + 10, lineY),
//         Offset(scanRect.right - 10, lineY),
//         scanLinePaint,
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
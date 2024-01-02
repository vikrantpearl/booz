import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:webview_flutter/webview_flutter.dart';
import '../api/apiservice.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

import '../widgets/shareprefences.dart';

class MyWebViewApp extends StatefulWidget {
  @override
  _MyWebViewAppState createState() => _MyWebViewAppState();
}

class _MyWebViewAppState extends State<MyWebViewApp> {
  final String _webUrl2 = "https://boozeexpress.com.au/"; // Default URL
  String _webUrl = ""; // Default URL

  // Default URL
  late WebViewController? _webViewController;
  bool _isLoading = true;
  int _currentIndex = 0;
  bool _hasError = false;
  String _shUrl = "";
  SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    _webViewController = null;
    setState(() {
      if (_webViewController != null) {
        _shUrl = sharedPreferencesHelper.loadData("webUrl");

        if (_shUrl != "null") _webViewController!.loadUrl(_shUrl);
        // Load the new URL
      }
      fetchDataFromApi();

      _isLoading = false; // Set loading to false when URL is loaded
    });

    // Load data
  }

  Future<void> fetchDataFromApi() async {
    try {
      final apiUrl = await ApiService.fetchUrlFromApi(
        key: "key_pearl_06\$\$12\$\$2021",
        code: "code_pearl_06\$\$12\$\$2021",
        erpName: "booze_exp",
        appName: "booze_exp",
      );
      print("URL: $apiUrl");
      setState(() {
        _isLoading = false;
      });
      if (apiUrl != _webUrl) {
        setState(() {
          _webUrl = apiUrl;
          print("_Updated URL: $apiUrl");
          if (_webViewController != null) {
            if (_shUrl == "null") {
              _webViewController!.loadUrl(apiUrl);
              sharedPreferencesHelper.saveData('webUrl', apiUrl);
            } else {
              if (_shUrl == _webUrl) {
                _webUrl = _shUrl;
                //  _webViewController!.loadUrl(_shUrl);
              } else {
                _webViewController!.loadUrl(apiUrl);
                sharedPreferencesHelper.saveData('webUrl', apiUrl);
              }
            }
            // Load the new URL

            // Save data
          }
          // Set loading to false when URL is loaded
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        print("Catch $e");
      });
    }
  }

  double webProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('S2 Classes'),
      ),*/
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0e1b4d),
        selectedLabelStyle: GoogleFonts.archivo(),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 0) {
              checkConnectivity();
              _webViewController!.loadUrl(_webUrl);
            } else if (index == 1) {
              checkConnectivity();
              final newUrl = "$_webUrl/collections";
              _webViewController!.loadUrl(newUrl);
            } else if (index == 2) {
              checkConnectivity();
              final newUrl = "$_webUrl/account/login";
              _webViewController!.loadUrl(newUrl);
            } else if (index == 3) {
              checkConnectivity();
              final newUrl = "$_webUrl/collections/beer-amp-cider";
              _webViewController!.loadUrl(newUrl);
            } else if (index == 4) {
              checkConnectivity();
              final newUrl = "$_webUrl/collections/liqueurs-and-aperitifs";
              _webViewController!.loadUrl(newUrl);
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'collections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity_rounded),
            label: 'account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wine_bar),
            label: 'beer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.liquor),
            label: 'Liqueurs',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            webProgress < 1
                ? SizedBox(
                    height: 5,
                    child: LinearProgressIndicator(
                      value: webProgress,
                      color: Colors.red,
                      backgroundColor: Colors.black,
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: Container(
                height: 200,
                child: Stack(
                  children: [
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0e1b4d),
                        ),
                      ),
                    if (!_isLoading && !_hasError)
                      WebView(
                        initialUrl: _webUrl,
                        zoomEnabled: true,
                        javascriptMode: JavascriptMode.unrestricted,
                        debuggingEnabled: true,
                        onProgress: (prograss) => setState(() {
                          this.webProgress = prograss / 100;
                        }),
                        onWebViewCreated: (controller) {
                          _webViewController = controller;
                        },
                        onPageFinished: (_) {
                          print("LOADED URL $_webUrl");
                          setState(() {
                            _isLoading = false;
                          });
                        },
                      ),
                    if (_hasError)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Lottie.asset('assets/interrnet.json'),
                            //Image.asset('assets/static2.png', fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 20),
                          MaterialButton(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              elevation: 5.0,
                              minWidth: 200.0,
                              height: 35,
                              color: Color(0xFF0e1b4d),
                              onPressed: () {
                                setState(() {
                                  _isLoading = true; // Set loading to true
                                  _hasError = false;

                                  _isLoading = false; // Reset error state
                                });
                                checkConnectivity();
                              },
                              child: const Text(
                                'No Internet Connection',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }
}

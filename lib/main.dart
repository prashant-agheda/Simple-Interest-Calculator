import 'package:flutter/material.dart';

// Creating the Main Function
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Personal Simple Interest Calculator :)",
    home: SIForm(),
  ));
}

// Creating a Stateful Widget
class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

// Defining the STATE of Stateful Widget and some Properties
class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();

  // Properties
  var _currencies = ["Dollars", "Rupees", "Pounds"];
  final _minimumPadding = 5.0;

  var _currentItemSelected = "";

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  // Controller helps us to extract the values from the Textfields
  TextEditingController principalController = TextEditingController();
  TextEditingController rateOfInterestController = TextEditingController();
  TextEditingController termController = TextEditingController();

  var displayResult = "";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    
    Color bg = Color.fromRGBO(204, 214, 204, 1.0);

    return Scaffold(
      backgroundColor: bg,
      // Use it only if less number of widgets - resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator :)"),
        backgroundColor: Colors.green,
        brightness: Brightness.dark,
        shadowColor: Colors.amber,
        elevation: 10.0,
      ),
      body: Form(
        // Using this key we can access our form and get its current status
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding * 2),
          child: ListView(
            children: [
              myImageAsset(),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding * 2, bottom: _minimumPadding * 2),
                child: TextFormField(
                  style: textStyle,
                  controller: principalController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Please Enter Principal Amount";
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15.0,
                      ),
                      labelText: "Principal",
                      hintText: "Enter Principal Amount (e.g. 15000)",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding * 2, bottom: _minimumPadding * 2),
                child: TextFormField(
                  style: textStyle,
                  controller: rateOfInterestController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Please Enter Rate of Interest";
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15.0,
                      ),
                      labelText: "Rate of Interest",
                      hintText: "In Percentage",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: textStyle,
                        controller: termController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Time";
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.indigo,
                              fontSize: 15.0,
                            ),
                            labelText: "Term",
                            hintText: "Time in Years",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                    Container(
                      width: _minimumPadding * 5,
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                          items: _currencies
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          value: _currentItemSelected,
                          style: textStyle,
                          onChanged: (String newValueSelected) {
                            // Code to execute, when menu item is selected

                            _onDropDownItemSelected(newValueSelected);
                          }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding * 4, bottom: _minimumPadding * 4),
                child: Row(
                  children: [
                    Expanded(
                        child: RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(7.0),
                      child: Text("Calculate", textScaleFactor: 1.5),
                      onPressed: () {
                        setState(() {
                          // If user input is valid then only calculate the Total Returns
                          if (_formKey.currentState.validate()) {
                            this.displayResult = _calculateTotalReturns();
                          }
                        });
                      },
                    )),
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Colors.white,
                      child: Text("Reset", textScaleFactor: 1.5),
                      onPressed: () {
                        setState(() {
                          _reset();
                        });
                      },
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(_minimumPadding * 2),
                child: Text(this.displayResult, style: textStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myImageAsset() {
    //var myIcon = Icon(Icons.account_balance).toString();
    //AssetImage assetImage = AssetImage(myIcon);
    //Image image = Image(image: assetImage, width: 125.0, height: 125.0);
    return Container(
      child: Icon(
        Icons.account_balance,
        color: Colors.blue,
        size: 80.0,
      ),
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    // Extract the Values using controller
    double principal = double.parse(principalController.text);
    double rateOfInterest = double.parse(rateOfInterestController.text);
    double term = double.parse(termController.text);

    // Calculate the Total Amount Payable by using SIMPLE Interest Formula
    double totalAmountPayable =
        principal + (principal * rateOfInterest * term) / 100;
    String result =
        "After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected";

    return result;
  }

  void _reset() {
    principalController.text = "";
    rateOfInterestController.text = "";
    termController.text = "";
    displayResult = "";
    _currentItemSelected = _currencies[0];
  }
}

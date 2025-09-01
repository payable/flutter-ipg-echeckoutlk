### ECheckout IPG - Flutter Integration

Flutter Package - [echeckout_ipg_flutter](https://pub.dev/packages/echeckout_ipg_flutter)

[![Pub](https://img.shields.io/pub/v/echeckout_ipg_flutter.svg)](https://pub.dev/packages/echeckout_ipg_flutter)

<hr/>

### Initialization

<b>1.</b> Change the `minSdkVersion` as below from your app level `build.gradle` file.

```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

<b>2.</b> Add the below package into your `pubspec.yaml` file.

```yaml
echeckout_ipg_flutter: ^3.0.0
```

<hr/>

### Implementation

<b>1.</b> Import ECheckout IPG SDK package.

```dart
import 'package:echeckout_ipg_flutter/echeckout_ipg_flutter.dart';
```

<b>2.</b> Create ECheckout IPG client with `ECheckoutIPGClient`.

```dart 
ECheckoutIPGClient ipgClient = ECheckoutIPGClient(
    merchantKey: "YOUR_MERCHANT_KEY",
    merchantToken: "YOUR_MERCHANT_TOKEN",
    returnUrl: "YOUR_RETURN_URL_TO_REDIRECT",
    logoUrl: "YOUR_COMPANY_LOGO",
    environment: IPGEnvironment.sandbox, // only for testing
);
```

<b>3.</b> Call `ECheckoutIPG` into your application body.

> One-time payments
```dart
ECheckoutIPG(
    ipgClient: ipgClient,
    amount: "100.45",
    currencyCode: "LKR",
    paymentType: 1, // The value is 1 for one-time payments
    orderDescription: "Netflix",
    customerFirstName: "John",
    customerLastName: "Doe",
    customerEmail: "johndoe@gmail.com",
    customerMobilePhone: "0777123456",
    billingAddressStreet: "Hill Street",
    billingAddressCity: "Dehiwala",
    billingAddressCountry: "LK",
    billingAddressPostcodeZip: "10350"
)
```


> Recurring payments
```dart
ECheckoutIPG(
    ipgClient: ipgClient,
    amount: "350.00", // Sets the amount needs to be charged along with this payment
    currencyCode: "LKR",
    paymentType: 2, // The value is 2 for recurring payments
    orderDescription: "Play Pass",
    customerFirstName: "John",
    customerLastName: "Doe",
    customerEmail: "johndoe@gmail.com",
    customerMobilePhone: "0777123456",
    billingAddressStreet: "Hill Street",
    billingAddressCity: "Dehiwala",
    billingAddressCountry: "LK", // ISO country code (LK, US, etc.)
    billingAddressPostcodeZip: "10350"
    startDate: '2024-05-27',
    endDate: '2024-11-27',
    recurringAmount: 350.00, // Sets the amount needs to be recurred 
    interval: 'MONTHLY', // Sets how often the payment is made. The value can be MONTHLY, QUARTERLY or ANNUALLY.
    isRetry: '1', // Sets whether automatic retying is allowed in case of a payment fails. (1 - allowed, 0 - not allowed)
    retryAttempts: '3', // Sets the amount of days that automatic retrying will be performed. (max: 5)
    doFirstPayment: '1', // Sets whether the user is making the initial payment of this subscription along with this payment. 
)
```

> Optional params
```dart
custom1 // Merchant specific data
custom2 // Merchant specific data
billingPhone
billingCompanyName
billingStreetAddress2
billingProvince
shippingFirstName
shippingLastName
shippingMobile
shippingPhone
shippingEmail
shippingCompanyName
shippingStreetAddress1
shippingStreetAddress2
shippingTownCity
shippingProvince
shippingCountry
shippingPostcode
```

<hr/>

### Example Usage

```dart
import 'package:flutter/material.dart';
import 'package:echeckout_ipg_flutter/echeckout_ipg_flutter.dart';

class _PaymentPageState extends State<PaymentPage> {
  ECheckoutIPGClient? _myIpgClient;
  ECheckoutIPG? _eCheckoutIPG;
  List<String>? _errorMessages;
  bool _loadIPG = true;

  @override
  Widget build(BuildContext context) {
    _loadData();

    Widget children;
    if (_eCheckoutIPG != null && _loadIPG) {
      children = _eCheckoutIPG as Widget;
    }
    else if (_errorMessages != null) {
      children = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...?_errorMessages?.map((errorMessage) =>
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )),
        ],
      );
    }
    else {
      children = Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stack(
        children: [
          children
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    setState(() {
        _myIpgClient = const ECheckoutIPGClient(
          logoUrl: "https://i.imgur.com/l21F5us.png",
          returnUrl: "https://example.com/receipt",
          merchantKey: "A748BFC24F8F6C61",
          merchantToken: "09FD8632EED1D1FEB9AD9A5E55427452",
          webhookUrl: "https://your-webhook-url.example.com"
        );

        _eCheckoutIPG = ECheckoutIPG(
          ipgClient: myIpgClient,
          amount: "100.00",
          currencyCode: "LKR",
          paymentType: "1",
          orderDescription: "Order description goes here",
          invoiceId: _generateInvoiceId(),
          customerFirstName: "John",
          customerLastName: "Doe",
          customerMobilePhone: "0777123456",
          customerEmail: "johndoe@gmail.com",
          billingAddressStreet: "Hill Street",
          billingAddressCity: "Colombo",
          billingAddressCountry: "LK",
          billingAddressPostcodeZip: "70000",

          onPaymentStarted: (data) {
            log('Payment started');
          },
          onPaymentCompleted: (data) {
            log('Payment completed');
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          onPaymentError: (data) {
            log('Payment error');
            if (data.status == 3009) {
              final errorMap = data.error;
              final errorMessages =
              errorMap.values.expand((list) => list).toList();
              setState(() {
                _loadIPG = false;
                _errorMessages = errorMessages.cast<String>();
              });
            }
          },
          onPaymentCancelled: () {
            log('Payment cancelled');
            Navigator.pop(context);
          }
        );
    }
  }
```
> Check the sample app for a full working code and more details on implementation.

<hr/>

### Advanced Usage

Check the status of the transaction using `uid` and `resultIndicator` receieved from `onPaymentStarted` or `onPaymentCompleted`.

```dart
var data = await ipgClient.getStatus("uid", "resultIndicator");
```

<hr/>
<br>

ECheckout IPG SDK - Flutter Integration

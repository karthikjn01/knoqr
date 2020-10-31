import 'package:diinq/Providers/UserData.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGenerator extends StatelessWidget {
  House house;
  QRCodeGenerator(this.house);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              "knoqr",
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              "Scan the QR code to ring! If no one is in ${house.name} then leave a message.",
              style: Theme.of(context).textTheme.caption,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: QrImage(
                data: "https://doooooorbell.web.app/#/ring/${house.code}",
                version: QrVersions.auto,
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              "Visit knoqr.app for more information!",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGenerator extends StatelessWidget {
  String id;
  QRCodeGenerator(this.id);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              "knoqr.app",
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              "Scan the QR code to use as a bell!",
              style: Theme.of(context).textTheme.caption,
            ),
            Expanded(
              child: QrImage(
                data: "https://doooooorbell.web.app/#/ring/$id",
                version: QrVersions.auto,
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

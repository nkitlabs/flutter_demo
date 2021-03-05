import 'package:flutter/material.dart';

class Prediction {
  final double confidence;
  final int index;
  final String label;

  Prediction({this.confidence, this.index, this.label});

  factory Prediction.fromJson(Map<dynamic, dynamic> json) {
    return Prediction(
      confidence: json['confidence'],
      index: json['index'],
      label: json['label'],
    );
  }
}

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;

  const PredictionWidget({Key key, this.predictions}) : super(key: key);

  Widget _numberWidget(int num, Prediction prediction) {
    double confidence = 0.0;
    if (prediction != null) {
      confidence = prediction.confidence;
    }
    double opac = (confidence * 2).clamp(0, 1).toDouble();
    return Column(
      children: <Widget>[
        Text('$num',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: prediction == null
                  ? Colors.black
                  : Colors.blue.withOpacity(opac),
            )),
        Text(
          '${prediction == null ? '' : confidence.toStringAsFixed(3)}',
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  }

  List<dynamic> getPredictionStyles(List<Prediction> predictions) {
    List<dynamic> data = new List<dynamic>.generate(10, (i) => null);
    predictions?.forEach((prediction) {
      data[prediction.index] = prediction;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var preds = getPredictionStyles(this.predictions);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 0; i < 5; i++) _numberWidget(i, preds[i])
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 5; i < 10; i++) _numberWidget(i, preds[i])
          ],
        ),
      ],
    );
  }
}

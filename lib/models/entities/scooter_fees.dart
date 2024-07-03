class ScooterFees {
  final String brand;
  final double startFee;
  final double minuteFee;

  ScooterFees({
    required this.brand,
    required this.startFee,
    required this.minuteFee,
  });

  factory ScooterFees.fromMap(Map<String, dynamic> map) {
    return ScooterFees(
      brand: map['brand'] as String,
      startFee: map['start_fee'] as double,
      minuteFee: map['minute_fee'] as double,
    );
  }
}

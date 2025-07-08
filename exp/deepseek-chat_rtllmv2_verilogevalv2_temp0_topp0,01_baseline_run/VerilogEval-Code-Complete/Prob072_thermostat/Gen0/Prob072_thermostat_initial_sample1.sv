module TopModule (
  input mode,
  input too_cold,
  input too_hot,
  input fan_on,
  output heater,
  output aircon,
  output fan
);

  // Heater control: only in heating mode when too cold
  assign heater = mode & too_cold;

  // Aircon control: only in cooling mode when too hot
  assign aircon = ~mode & too_hot;

  // Fan control: on when either heater/aircon is on or fan_on is high
  assign fan = heater | aircon | fan_on;

endmodule
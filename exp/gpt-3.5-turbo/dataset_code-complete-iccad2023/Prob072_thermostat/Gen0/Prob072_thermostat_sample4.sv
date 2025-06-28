module TopModule (
  input mode,
  input too_cold,
  input too_hot,
  input fan_on,
  output heater,
  output aircon,
  output fan
);

  // Turn on heater when in heating mode and too cold
  assign heater = (mode && too_cold) ? 1 : 0;

  // Turn on air conditioner when in cooling mode and too hot
  assign aircon = (!mode && too_hot) ? 1 : 0;

  // Turn on fan when heater, air conditioner, or fan request is on
  assign fan = (heater || aircon || fan_on) ? 1 : 0;

endmodule
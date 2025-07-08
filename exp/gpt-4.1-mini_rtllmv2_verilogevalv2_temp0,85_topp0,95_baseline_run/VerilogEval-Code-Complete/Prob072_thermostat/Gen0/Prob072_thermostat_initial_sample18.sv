module TopModule (
  input mode,
  input too_cold,
  input too_hot,
  input fan_on,
  output heater,
  output aircon,
  output fan
);

  assign heater = mode & too_cold;          // Heater on in heating mode when too cold
  assign aircon = (~mode) & too_hot;        // Aircon on in cooling mode when too hot
  assign fan = fan_on | heater | aircon;    // Fan on if requested or if heater or aircon on

endmodule
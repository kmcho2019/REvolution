module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

assign heater = mode & too_cold;  // Heater is on when in heating mode and too cold
assign aircon = ~mode & too_hot;  // Air conditioner is on when in cooling mode and too hot
assign fan = heater | aircon | fan_on;  // Fan is on when heater or air conditioner is on, or fan is requested

endmodule
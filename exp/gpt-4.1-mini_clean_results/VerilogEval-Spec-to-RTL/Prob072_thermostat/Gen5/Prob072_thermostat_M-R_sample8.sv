module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

// Heater is on when in heating mode and it is too cold
assign heater = mode & too_cold;

// Air conditioner is on when in cooling mode and it is too hot
assign aircon = (~mode) & too_hot;

// Fan is on if heater or aircon is on, or fan_on is requested
assign fan = heater | aircon | fan_on;

endmodule
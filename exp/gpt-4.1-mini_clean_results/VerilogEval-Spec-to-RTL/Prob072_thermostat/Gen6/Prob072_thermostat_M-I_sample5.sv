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

// Fan is on if heater or aircon is on; otherwise, fan_on controls it
assign fan = heater | aircon | (fan_on & ~(heater | aircon));

endmodule
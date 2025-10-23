module TopModule(
    input  mode,       // 1 for heating mode, 0 for cooling mode
    input  too_cold,   // 1 if it's too cold
    input  too_hot,   // 1 if it's too hot
    input  fan_on,    // 1 to turn on the fan manually
    output heater,    // output to control the heater
    output aircon,   // output to control the air conditioner
    output fan       // output to control the fan
);

// In heating mode, turn on the heater if it's too cold
assign heater = (mode == 1'b1) && (too_cold == 1'b1);

// In cooling mode, turn on the air conditioner if it's too hot
assign aircon = (mode == 1'b0) && (too_hot == 1'b1);

// Turn on the fan if the heater or air conditioner is on, or if the fan_on signal is asserted
assign fan = (heater == 1'b1) || (aircon == 1'b1) || (fan_on == 1'b1);

endmodule
module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // In heating mode, turn on the heater when it's too cold
    assign heater = (mode == 1'b1) && (too_cold == 1'b1);
    
    // In cooling mode, turn on the air conditioner when it's too hot
    assign aircon = (mode == 1'b0) && (too_hot == 1'b1);
    
    // Simplified fan logic: turn on the fan when the heater or air conditioner is on, or when the fan is requested
    assign fan = (heater || aircon) || fan_on;

endmodule
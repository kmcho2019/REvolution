module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Logic for the heater: on in heating mode when it's too cold
    assign heater = (mode == 1'b1) && (too_cold == 1'b1);
    
    // Logic for the air conditioner: on in cooling mode when it's too hot
    assign aircon = (mode == 1'b0) && (too_hot == 1'b1);
    
    // Logic for the fan: on when the heater or air conditioner is on, or when requested
    assign fan = (heater || aircon) || fan_on;

endmodule
module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Calculate the state of the heater and air conditioner
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Calculate the state of the fan
    assign fan = (heater | aircon) | fan_on;

endmodule
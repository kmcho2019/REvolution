module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Control heater and air conditioner directly based on mode and temperature
    assign heater = mode && too_cold;
    assign aircon = !mode && too_hot;

    // Control fan based on heater, air conditioner, or fan_on
    assign fan = (mode && too_cold) || (!mode && too_hot) || fan_on;

endmodule
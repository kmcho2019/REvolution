module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Direct assignment based on mode and temperature conditions
    assign heater = mode && too_cold;
    assign aircon =!mode && too_hot;
    // Fan is on if heater or aircon is on, or if fan_on is asserted
    assign fan = (mode && too_cold) || (!mode && too_hot) || fan_on;

endmodule
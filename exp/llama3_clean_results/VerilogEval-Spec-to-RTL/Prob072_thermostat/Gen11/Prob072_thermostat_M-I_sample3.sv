module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Direct assignment of heater and aircon based on mode and temperature conditions
    assign heater = mode && too_cold;
    assign aircon = ~mode && too_hot;

    // The fan turns on if either heater or aircon is on, or if fan_on is asserted
    // Using the same logical operation as in the original solution, which is efficient
    assign fan = (heater || aircon) || fan_on;

endmodule
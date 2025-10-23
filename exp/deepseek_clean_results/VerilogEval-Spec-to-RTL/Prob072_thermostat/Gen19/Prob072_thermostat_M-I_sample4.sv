module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Temperature control signal - shared between heater and aircon
    wire temp_control = mode ? too_cold : too_hot;
    
    // Output assignments
    assign heater = mode & temp_control;
    assign aircon = ~mode & temp_control;
    assign fan = fan_on | temp_control;

endmodule
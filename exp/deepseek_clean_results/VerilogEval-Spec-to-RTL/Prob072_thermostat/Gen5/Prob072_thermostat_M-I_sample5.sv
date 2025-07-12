module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Combined temperature control signal - mutually exclusive
    wire temp_control = (mode & too_cold) | (~mode & too_hot);
    
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Optimized fan logic - temp_control already combines heater/aircon
    assign fan = temp_control | fan_on;

endmodule
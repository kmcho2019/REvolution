module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire not_mode = ~mode;
    
    assign heater = mode & too_cold;
    assign aircon = not_mode & too_hot;
    assign fan = heater | aircon | fan_on;

endmodule
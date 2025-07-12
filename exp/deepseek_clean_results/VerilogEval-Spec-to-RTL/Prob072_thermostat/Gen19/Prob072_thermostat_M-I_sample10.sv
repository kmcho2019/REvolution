module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode controls
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Fan turns on for either heating/cooling or manual request
    assign fan = fan_on | heater | aircon;

endmodule
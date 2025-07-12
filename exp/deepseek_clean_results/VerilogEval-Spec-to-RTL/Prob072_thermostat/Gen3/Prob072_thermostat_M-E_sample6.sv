module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Priority-based output generation
    assign fan = fan_on ? 1'b1 : (mode ? too_cold : too_hot);
    
    assign heater = ~fan_on & mode & too_cold;
    assign aircon = ~fan_on & ~mode & too_hot;

endmodule
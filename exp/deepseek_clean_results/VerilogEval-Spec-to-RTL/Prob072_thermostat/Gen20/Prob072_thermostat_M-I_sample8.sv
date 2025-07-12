module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heater_w = mode & too_cold;
    wire aircon_w = ~mode & too_hot;
    
    assign heater = heater_w;
    assign aircon = aircon_w;
    assign fan = heater_w | aircon_w | fan_on;

endmodule
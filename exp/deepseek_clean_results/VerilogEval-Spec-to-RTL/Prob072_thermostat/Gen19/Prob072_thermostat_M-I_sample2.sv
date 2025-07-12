module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heater_en = mode & too_cold;
    wire aircon_en = ~mode & too_hot;
    
    assign heater = heater_en;
    assign aircon = aircon_en;
    assign fan = fan_on | (heater_en | aircon_en);

endmodule
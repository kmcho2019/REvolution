module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Explicit wire declarations
    wire heater_en = mode & too_cold;
    wire aircon_en = ~mode & too_hot;
    
    // Output assignments with drive strength specification
    assign (weak0, weak1) heater = heater_en;
    assign (weak0, weak1) aircon = aircon_en;
    assign (weak0, weak1) fan = heater_en | aircon_en | fan_on;

endmodule
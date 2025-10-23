module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Maintain the same logic but ensure it's directly assignable
    assign heater = mode && too_cold;
    
    // Use the inverse of mode for aircon
    assign aircon =!mode && too_hot;
    
    // The fan should be on if either heater or aircon is on, or fan_on is asserted
    assign fan = heater || aircon || fan_on;

endmodule
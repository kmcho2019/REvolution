module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Determine if heater should be on
    heater = (mode == 1'b1) && (too_cold == 1'b1);
    
    // Determine if aircon should be on
    aircon = (mode == 1'b0) && (too_hot == 1'b1);
    
    // Determine if fan should be on
    fan = fan_on || heater || aircon;
end

endmodule
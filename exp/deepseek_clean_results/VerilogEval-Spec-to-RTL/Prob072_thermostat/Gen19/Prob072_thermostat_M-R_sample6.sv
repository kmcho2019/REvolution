module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Heating mode logic
    heater = mode & too_cold;
    
    // Cooling mode logic
    aircon = ~mode & too_hot;
    
    // Fan logic (OR of all conditions)
    fan = fan_on | heater | aircon;
end

endmodule
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
    // Default outputs off
    heater = 0;
    aircon = 0;
    fan = 0;
    
    if (mode) begin
        // Heating mode
        if (too_cold)
            heater = 1;
    end else begin
        // Cooling mode
        if (too_hot)
            aircon = 1;
    end
    
    // Fan on if heater or aircon on, or fan_on asserted
    fan = heater | aircon | fan_on;
end

endmodule
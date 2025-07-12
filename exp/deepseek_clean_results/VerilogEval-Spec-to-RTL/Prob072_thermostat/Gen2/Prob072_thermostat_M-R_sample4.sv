module TopModule (
    input  mode,      // 1=heating, 0=cooling
    input  too_cold,  // Temperature too low
    input  too_hot,   // Temperature too high
    input  fan_on,    // Manual fan request
    output reg heater,    // Heater control
    output reg aircon,    // Air conditioner control
    output reg fan        // Fan control
);

always @(*) begin
    // Default outputs
    heater = 0;
    aircon = 0;
    fan = fan_on;  // Fan can be on independently
    
    // Mode-dependent control
    if (mode) begin  // Heating mode
        heater = too_cold;
        fan = fan | heater;  // Fan on if heater is on
    end else begin   // Cooling mode
        aircon = too_hot;
        fan = fan | aircon;   // Fan on if aircon is on
    end
end

endmodule
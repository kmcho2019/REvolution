module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*)
    begin
        // Determine heater state based on mode and temperature
        heater = mode & too_cold;
        
        // Determine air conditioner state based on mode and temperature
        aircon = ~mode & too_hot;
        
        // Determine fan state based on heater, air conditioner, and fan_on
        fan = (heater | aircon | fan_on);
    end

endmodule
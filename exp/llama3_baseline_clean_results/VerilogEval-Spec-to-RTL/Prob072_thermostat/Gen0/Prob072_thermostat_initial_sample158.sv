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
    // Determine if the heater or air conditioner should be turned on
    if (mode == 1) // Heating mode
    begin
        heater = too_cold;
        aircon = 0;
    end
    else // Cooling mode
    begin
        heater = 0;
        aircon = too_hot;
    end
    
    // Determine if the fan should be turned on
    fan = heater | aircon | fan_on;
end

endmodule
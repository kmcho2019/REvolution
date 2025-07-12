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
        // Heating mode
        if (mode) 
        begin
            heater = too_cold;
            aircon = 1'b0;
        end 
        // Cooling mode
        else 
        begin
            heater = 1'b0;
            aircon = too_hot;
        end
        
        // Fan control
        fan = (heater | aircon) | fan_on;
    end

endmodule
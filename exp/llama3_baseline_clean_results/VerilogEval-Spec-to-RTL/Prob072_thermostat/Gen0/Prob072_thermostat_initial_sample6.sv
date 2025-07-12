module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(mode, too_cold, too_hot, fan_on) begin
        // In heating mode, turn on heater when too cold, keep air conditioner off
        if (mode) begin
            heater = too_cold;
            aircon = 0;
        end 
        // In cooling mode, turn on air conditioner when too hot, keep heater off
        else begin
            aircon = too_hot;
            heater = 0;
        end
        
        // Turn on fan if heater or air conditioner is on, or if user requests it
        fan = (heater | aircon) | fan_on;
    end

endmodule
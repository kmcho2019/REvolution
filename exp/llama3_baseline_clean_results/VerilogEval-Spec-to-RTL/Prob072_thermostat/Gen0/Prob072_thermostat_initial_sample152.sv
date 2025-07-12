module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(*) begin
        // In heating mode, turn heater on when too cold, and turn air conditioner off
        if (mode == 1) begin
            heater = too_cold;
            aircon = 0;
        end
        // In cooling mode, turn air conditioner on when too hot, and turn heater off
        else begin
            heater = 0;
            aircon = too_hot;
        end
        
        // Turn fan on when either heater or air conditioner is on, or when user requests it
        fan = (heater || aircon) || fan_on;
    end

endmodule
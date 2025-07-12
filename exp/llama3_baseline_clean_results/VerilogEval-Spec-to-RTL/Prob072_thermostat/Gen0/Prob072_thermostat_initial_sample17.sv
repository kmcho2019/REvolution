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
    // Initialize outputs to default values
    heater = 0;
    aircon = 0;
    fan = 0;

    // Check mode and temperature sensors
    if (mode) begin  // Heating mode
        if (too_cold) begin
            heater = 1;
        end
    end else begin  // Cooling mode
        if (too_hot) begin
            aircon = 1;
        end
    end

    // Turn on fan if heater or air conditioner is on, or if user requests it
    if (heater || aircon || fan_on) begin
        fan = 1;
    end
end

endmodule
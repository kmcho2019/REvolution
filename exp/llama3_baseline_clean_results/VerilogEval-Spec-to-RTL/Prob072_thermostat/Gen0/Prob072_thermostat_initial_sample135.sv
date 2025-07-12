module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Initialize outputs to 0
    heater = 0;
    aircon = 0;
    fan = 0;

    // Determine the state of the outputs based on the inputs
    if (mode == 1) begin // Heating mode
        if (too_cold == 1) begin
            heater = 1;
        end
    end else begin // Cooling mode
        if (too_hot == 1) begin
            aircon = 1;
        end
    end

    // Turn on the fan if the heater or air conditioner is on, or if the user requests it
    if (heater == 1 || aircon == 1 || fan_on == 1) begin
        fan = 1;
    end
end

endmodule
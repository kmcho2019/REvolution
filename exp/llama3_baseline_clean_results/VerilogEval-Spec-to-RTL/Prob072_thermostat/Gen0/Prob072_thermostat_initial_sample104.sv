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

    // Heating mode
    if (mode) begin
        if (too_cold) begin
            heater = 1;
        end
        fan = heater | fan_on;
    end
    // Cooling mode
    else begin
        if (too_hot) begin
            aircon = 1;
        end
        fan = aircon | fan_on;
    end
end

endmodule
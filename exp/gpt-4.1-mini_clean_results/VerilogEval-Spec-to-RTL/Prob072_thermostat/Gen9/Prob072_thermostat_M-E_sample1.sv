module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @* begin
        // Default outputs off
        heater = 0;
        aircon = 0;
        fan = 0;

        if (mode) begin
            // Heating mode
            if (too_cold) begin
                heater = 1;
                fan = 1;
            end
        end else begin
            // Cooling mode
            if (too_hot) begin
                aircon = 1;
                fan = 1;
            end
        end

        // User fan override turns on the fan regardless of heater or aircon
        if (fan_on)
            fan = 1;
    end

endmodule
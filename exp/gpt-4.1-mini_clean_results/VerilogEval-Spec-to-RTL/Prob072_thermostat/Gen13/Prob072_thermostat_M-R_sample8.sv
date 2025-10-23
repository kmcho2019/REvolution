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
        // Default outputs
        heater = 1'b0;
        aircon = 1'b0;
        fan = 1'b0;

        if (mode) begin
            // Heating mode
            if (too_cold) begin
                heater = 1'b1;
            end
        end else begin
            // Cooling mode
            if (too_hot) begin
                aircon = 1'b1;
            end
        end

        // Fan on if heater or aircon active or user requested
        fan = heater | aircon | fan_on;
    end

endmodule
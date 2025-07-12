module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        if (mode) begin
            // Heating mode
            if (too_cold) begin
                heater = 1'b1;
                aircon = 1'b0;
            end else begin
                heater = 1'b0;
                aircon = 1'b0;
            end
        end else begin
            // Cooling mode
            if (too_hot) begin
                heater = 1'b0;
                aircon = 1'b1;
            end else begin
                heater = 1'b0;
                aircon = 1'b0;
            end
        end

        // Fan logic: turn on if heater or aircon active, or if fan_on asserted
        fan = (heater | aircon) | fan_on;
    end

endmodule
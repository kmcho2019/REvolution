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
        // Default off outputs
        heater = 0;
        aircon = 0;
        fan = 0;

        if (mode) begin // Heating mode
            if (too_cold) begin
                heater = 1;
                fan = 1;
            end
        end else begin // Cooling mode
            if (too_hot) begin
                aircon = 1;
                fan = 1;
            end
        end

        // If fan is requested on independently
        if (fan_on)
            fan = 1;
    end

endmodule
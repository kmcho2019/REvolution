module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output fan
);

    reg fan_internal;

    always @(*) begin
        // Default off
        heater = 0;
        aircon = 0;

        if (mode) begin
            // Heating mode
            if (too_cold)
                heater = 1;
        end else begin
            // Cooling mode
            if (too_hot)
                aircon = 1;
        end
    end

    assign fan_internal = heater | aircon | fan_on;
    assign fan = fan_internal;

endmodule
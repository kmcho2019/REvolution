module TopModule(
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @* begin
        heater = 1'b0;
        aircon = 1'b0;

        if (mode) begin // heating mode
            if (too_cold)
                heater = 1'b1;
        end else begin  // cooling mode
            if (too_hot)
                aircon = 1'b1;
        end

        fan = heater | aircon | fan_on;
    end

endmodule
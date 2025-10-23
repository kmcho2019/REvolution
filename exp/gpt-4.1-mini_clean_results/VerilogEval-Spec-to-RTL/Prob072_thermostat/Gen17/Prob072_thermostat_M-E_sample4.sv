module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output reg heater, // Heater control output
    output reg aircon, // Air conditioner control output
    output reg fan     // Fan control output
);

    always @(*) begin
        // Default outputs
        heater = 0;
        aircon = 0;
        fan = 0;

        if (mode) begin
            // Heating mode
            if (too_cold)
                heater = 1;
        end else begin
            // Cooling mode
            if (too_hot)
                aircon = 1;
        end

        // Fan logic: on if heater or aircon is on, or if fan_on requested
        fan = heater | aircon | fan_on;
    end

endmodule
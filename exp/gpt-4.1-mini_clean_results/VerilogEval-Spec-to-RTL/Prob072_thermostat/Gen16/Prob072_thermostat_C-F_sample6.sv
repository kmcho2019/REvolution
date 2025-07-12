module TopModule (
    input  mode,        // 1: heating mode, 0: cooling mode
    input  too_cold,    // 1 if temperature is too cold
    input  too_hot,     // 1 if temperature is too hot
    input  fan_on,      // User request to turn on fan
    output reg heater,  // Heater control output
    output reg aircon,  // Air conditioner control output
    output reg fan      // Fan control output
);

    // Intermediate signals for heating and cooling states
    wire heating_active = mode & too_cold;
    wire cooling_active = (~mode) & too_hot;

    always @(*) begin
        // Initialize outputs
        heater = 1'b0;
        aircon = 1'b0;
        fan    = 1'b0;

        // Set heater and aircon outputs based on mode and temperature
        heater = heating_active;
        aircon = cooling_active;

        // Fan is on if heater or aircon is on, or if user requests fan_on
        if (heating_active || cooling_active || fan_on)
            fan = 1'b1;
    end

endmodule
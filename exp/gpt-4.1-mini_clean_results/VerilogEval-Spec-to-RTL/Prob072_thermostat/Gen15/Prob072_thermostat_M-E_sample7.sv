module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output fan
);

    // Update heater and aircon signals based on mode and temperature inputs
    always @(*) begin
        // Default off
        heater = 0;
        aircon = 0;

        if (mode) begin // Heating mode
            if (too_cold)
                heater = 1;
        end else begin   // Cooling mode
            if (too_hot)
                aircon = 1;
        end
    end

    // Fan is on if heater or aircon is on, or if fan_on input is asserted
    assign fan = heater | aircon | fan_on;

endmodule
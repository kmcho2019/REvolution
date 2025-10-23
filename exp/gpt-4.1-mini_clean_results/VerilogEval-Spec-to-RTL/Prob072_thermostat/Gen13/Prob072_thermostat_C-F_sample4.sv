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
        // Precompute heater and aircon enable signals
        wire heat_active = mode & too_cold;
        wire cool_active = ~mode & too_hot;

        // Assign outputs based on precomputed signals
        heater = heat_active;
        aircon = cool_active;
        fan    = heat_active | cool_active | fan_on;
    end

endmodule
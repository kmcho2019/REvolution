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
        // Compute heater and aircon based on mode and conditions
        heater = mode & too_cold;
        aircon = (~mode) & too_hot;

        // Fan enabled if heater or aircon active or user requests fan_on
        fan = heater | aircon | fan_on;
    end

endmodule
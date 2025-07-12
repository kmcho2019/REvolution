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
        // Intermediate signals based on mode and temperature
        heater = mode & too_cold;
        aircon = (~mode) & too_hot;

        // Fan is on if heater or aircon are on or if user requested fan_on
        fan = heater | aircon | fan_on;
    end

endmodule
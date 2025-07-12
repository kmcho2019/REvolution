module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        heater = mode & too_cold;
        aircon = ~mode & too_hot;
        fan = heater | aircon | fan_on;
    end

endmodule
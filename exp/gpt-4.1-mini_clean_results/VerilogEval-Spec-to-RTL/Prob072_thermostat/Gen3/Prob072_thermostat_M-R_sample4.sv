module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output fan
);

    always @(*) begin
        if (mode) begin
            heater = too_cold;
            aircon = 1'b0;
        end else begin
            heater = 1'b0;
            aircon = too_hot;
        end
    end

    assign fan = heater | aircon | fan_on;

endmodule
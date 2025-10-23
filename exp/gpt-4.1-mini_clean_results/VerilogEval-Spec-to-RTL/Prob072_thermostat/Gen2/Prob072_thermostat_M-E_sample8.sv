module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        if (mode) begin  // heating mode
            heater = too_cold ? 1'b1 : 1'b0;
            aircon = 1'b0;
        end else begin   // cooling mode
            heater = 1'b0;
            aircon = too_hot ? 1'b1 : 1'b0;
        end
        fan = fan_on | heater | aircon;
    end

endmodule
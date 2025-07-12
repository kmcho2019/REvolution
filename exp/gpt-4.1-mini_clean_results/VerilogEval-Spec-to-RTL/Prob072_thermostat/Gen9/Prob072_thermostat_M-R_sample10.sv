module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @* begin
        if (mode) begin // heating mode
            heater = too_cold;
            aircon = 1'b0;
        end else begin  // cooling mode
            heater = 1'b0;
            aircon = too_hot;
        end

        fan = heater | aircon | fan_on;
    end

endmodule
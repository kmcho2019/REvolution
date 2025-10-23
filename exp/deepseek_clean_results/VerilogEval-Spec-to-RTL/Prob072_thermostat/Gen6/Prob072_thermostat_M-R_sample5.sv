module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output fan
);

    always @(*) begin
        case (mode)
            1'b1: begin // Heating mode
                heater = too_cold;
                aircon = 1'b0;
            end
            1'b0: begin // Cooling mode
                heater = 1'b0;
                aircon = too_hot;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
            end
        endcase
    end

    // Fan remains combinational as it's mode-independent
    assign fan = heater | aircon | fan_on;

endmodule
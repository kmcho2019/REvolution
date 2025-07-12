module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        case ({mode, too_cold, too_hot, fan_on})
            4'b0000: begin heater = 0; aircon = 0; fan = 0; end
            4'b0001: begin heater = 0; aircon = 0; fan = 1; end
            4'b0010: begin heater = 0; aircon = 1; fan = 1; end
            4'b0011: begin heater = 0; aircon = 1; fan = 1; end
            4'b0100: begin heater = 0; aircon = 0; fan = 0; end
            4'b0101: begin heater = 0; aircon = 0; fan = 1; end
            4'b0110: begin heater = 0; aircon = 0; fan = 0; end
            4'b0111: begin heater = 0; aircon = 0; fan = 1; end
            4'b1000: begin heater = 0; aircon = 0; fan = 0; end
            4'b1001: begin heater = 0; aircon = 0; fan = 1; end
            4'b1010: begin heater = 1; aircon = 0; fan = 1; end
            4'b1011: begin heater = 1; aircon = 0; fan = 1; end
            4'b1100: begin heater = 1; aircon = 0; fan = 1; end
            4'b1101: begin heater = 1; aircon = 0; fan = 1; end
            4'b1110: begin heater = 1; aircon = 0; fan = 1; end
            4'b1111: begin heater = 1; aircon = 0; fan = 1; end
            default: begin heater = 0; aircon = 0; fan = 0; end
        endcase
    end

endmodule
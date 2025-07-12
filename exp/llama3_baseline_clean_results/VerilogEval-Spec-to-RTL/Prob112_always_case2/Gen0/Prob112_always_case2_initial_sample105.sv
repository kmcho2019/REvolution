module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        case(in)
            4'b0000: pos = 2'b00;
            4'b0001: pos = 2'b00; // output zero if first bit is high, but it's the least significant bit
            4'b0010: pos = 2'b01;
            4'b0011: pos = 2'b01; // if multiple bits are high, output position of the most significant one
            4'b0100: pos = 2'b10;
            4'b0101: pos = 2'b10;
            4'b0110: pos = 2'b10;
            4'b0111: pos = 2'b10;
            4'b1000: pos = 2'b11;
            4'b1001: pos = 2'b11;
            4'b1010: pos = 2'b11;
            4'b1011: pos = 2'b11;
            4'b1100: pos = 2'b11;
            4'b1101: pos = 2'b11;
            4'b1110: pos = 2'b11;
            4'b1111: pos = 2'b11;
            default: pos = 2'b00;
        endcase
    end

endmodule
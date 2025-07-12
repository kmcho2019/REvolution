module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [4:0] i, j;
    reg [24:0] out_reg;

    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                case ({i, j})
                    5'b00000: out_reg[24] = ~(a ^ a);
                    5'b00001: out_reg[23] = ~(a ^ b);
                    5'b00010: out_reg[22] = ~(a ^ c);
                    5'b00011: out_reg[21] = ~(a ^ d);
                    5'b00100: out_reg[20] = ~(a ^ e);
                    5'b01000: out_reg[19] = ~(b ^ a);
                    5'b01001: out_reg[18] = ~(b ^ b);
                    5'b01010: out_reg[17] = ~(b ^ c);
                    5'b01011: out_reg[16] = ~(b ^ d);
                    5'b01100: out_reg[15] = ~(b ^ e);
                    5'b10000: out_reg[14] = ~(c ^ a);
                    5'b10001: out_reg[13] = ~(c ^ b);
                    5'b10010: out_reg[12] = ~(c ^ c);
                    5'b10011: out_reg[11] = ~(c ^ d);
                    5'b10100: out_reg[10] = ~(c ^ e);
                    5'b11000: out_reg[9] = ~(d ^ a);
                    5'b11001: out_reg[8] = ~(d ^ b);
                    5'b11010: out_reg[7] = ~(d ^ c);
                    5'b11011: out_reg[6] = ~(d ^ d);
                    5'b11100: out_reg[5] = ~(d ^ e);
                    5'b10101: out_reg[4] = ~(e ^ a);
                    5'b10110: out_reg[3] = ~(e ^ b);
                    5'b10111: out_reg[2] = ~(e ^ c);
                    5'b11001: out_reg[1] = ~(e ^ d);
                    5'b11101: out_reg[0] = ~(e ^ e);
                    default: out_reg = 25'b0;
                endcase
            end
        end
        out = out_reg;
    end

endmodule
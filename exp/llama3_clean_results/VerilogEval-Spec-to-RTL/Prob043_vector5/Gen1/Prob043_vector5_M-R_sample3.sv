module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [4:0] i, j;

always @(*) begin
    for (i = 0; i <= 4; i++) begin
        for (j = 0; j <= 4; j++) begin
            case ({i, j})
                5'b0000: out[24] = ~(a ^ a);
                5'b0001: out[23] = ~(a ^ b);
                5'b0010: out[22] = ~(a ^ c);
                5'b0011: out[21] = ~(a ^ d);
                5'b0100: out[20] = ~(a ^ e);
                5'b0101: out[19] = ~(b ^ a);
                5'b0110: out[18] = ~(b ^ b);
                5'b0111: out[17] = ~(b ^ c);
                5'b1000: out[16] = ~(b ^ d);
                5'b1001: out[15] = ~(b ^ e);
                5'b1010: out[14] = ~(c ^ a);
                5'b1011: out[13] = ~(c ^ b);
                5'b1100: out[12] = ~(c ^ c);
                5'b1101: out[11] = ~(c ^ d);
                5'b1110: out[10] = ~(c ^ e);
                5'b0001_1: out[9]  = ~(d ^ a);
                5'b0010_1: out[8]  = ~(d ^ b);
                5'b0011_1: out[7]  = ~(d ^ c);
                5'b0100_1: out[6]  = ~(d ^ d);
                5'b0101_1: out[5]  = ~(d ^ e);
                5'b0110_1: out[4]  = ~(e ^ a);
                5'b0111_1: out[3]  = ~(e ^ b);
                5'b1000_1: out[2]  = ~(e ^ c);
                5'b1001_1: out[1]  = ~(e ^ d);
                5'b1010_1: out[0]  = ~(e ^ e);
                default: ;
            endcase
        end
    end
end

endmodule
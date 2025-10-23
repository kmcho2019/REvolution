module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

reg [4:0] i, j;

always @(a, b, c, d, e) begin
    for (i = 0; i <= 4; i++) begin
        for (j = 0; j <= 4; j++) begin
            case ({i, j})
                5'b00000: out[24] = ~(a ^ a);
                5'b00001: out[23] = ~(a ^ b);
                5'b00010: out[22] = ~(a ^ c);
                5'b00011: out[21] = ~(a ^ d);
                5'b00100: out[20] = ~(a ^ e);
                5'b00101: out[19] = ~(b ^ a);
                5'b00110: out[18] = ~(b ^ b);
                5'b00111: out[17] = ~(b ^ c);
                5'b01000: out[16] = ~(b ^ d);
                5'b01001: out[15] = ~(b ^ e);
                5'b01010: out[14] = ~(c ^ a);
                5'b01011: out[13] = ~(c ^ b);
                5'b01100: out[12] = ~(c ^ c);
                5'b01101: out[11] = ~(c ^ d);
                5'b01110: out[10] = ~(c ^ e);
                5'b01111: out[9]  = ~(d ^ a);
                5'b10000: out[8]  = ~(d ^ b);
                5'b10001: out[7]  = ~(d ^ c);
                5'b10010: out[6]  = ~(d ^ d);
                5'b10011: out[5]  = ~(d ^ e);
                5'b10100: out[4]  = ~(e ^ a);
                5'b10101: out[3]  = ~(e ^ b);
                5'b10110: out[2]  = ~(e ^ c);
                5'b10111: out[1]  = ~(e ^ d);
                5'b11000: out[0]  = ~(e ^ e);
                default: ;
            endcase
        end
    end
end

endmodule
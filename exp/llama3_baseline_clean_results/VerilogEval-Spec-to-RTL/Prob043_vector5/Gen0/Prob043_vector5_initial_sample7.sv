module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [24:0] temp_out;

    always @(a, b, c, d, e) begin
        temp_out[24] = ~(a ^ a);
        temp_out[23] = ~(a ^ b);
        temp_out[22] = ~(a ^ c);
        temp_out[21] = ~(a ^ d);
        temp_out[20] = ~(a ^ e);
        temp_out[19] = ~(b ^ a);
        temp_out[18] = ~(b ^ b);
        temp_out[17] = ~(b ^ c);
        temp_out[16] = ~(b ^ d);
        temp_out[15] = ~(b ^ e);
        temp_out[14] = ~(c ^ a);
        temp_out[13] = ~(c ^ b);
        temp_out[12] = ~(c ^ c);
        temp_out[11] = ~(c ^ d);
        temp_out[10] = ~(c ^ e);
        temp_out[9]  = ~(d ^ a);
        temp_out[8]  = ~(d ^ b);
        temp_out[7]  = ~(d ^ c);
        temp_out[6]  = ~(d ^ d);
        temp_out[5]  = ~(d ^ e);
        temp_out[4]  = ~(e ^ a);
        temp_out[3]  = ~(e ^ b);
        temp_out[2]  = ~(e ^ c);
        temp_out[1]  = ~(e ^ d);
        temp_out[0]  = ~(e ^ e);
        out = temp_out;
    end

endmodule
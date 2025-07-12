module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Binary codes for each input bit
    wire [4:0] a_code = {4'b0000, a};
    wire [4:0] b_code = {4'b0000, b};
    wire [4:0] c_code = {4'b0001, c};
    wire [4:0] d_code = {4'b0010, d};
    wire [4:0] e_code = {4'b0011, e};

    // Generate all pairwise comparisons using bitwise XOR
    assign out[24] = ~(a_code ^ a_code);
    assign out[23] = ~(a_code ^ b_code);
    assign out[22] = ~(a_code ^ c_code);
    assign out[21] = ~(a_code ^ d_code);
    assign out[20] = ~(a_code ^ e_code);
    assign out[19] = ~(b_code ^ a_code);
    assign out[18] = ~(b_code ^ b_code);
    assign out[17] = ~(b_code ^ c_code);
    assign out[16] = ~(b_code ^ d_code);
    assign out[15] = ~(b_code ^ e_code);
    assign out[14] = ~(c_code ^ a_code);
    assign out[13] = ~(c_code ^ b_code);
    assign out[12] = ~(c_code ^ c_code);
    assign out[11] = ~(c_code ^ d_code);
    assign out[10] = ~(c_code ^ e_code);
    assign out[9]  = ~(d_code ^ a_code);
    assign out[8]  = ~(d_code ^ b_code);
    assign out[7]  = ~(d_code ^ c_code);
    assign out[6]  = ~(d_code ^ d_code);
    assign out[5]  = ~(d_code ^ e_code);
    assign out[4]  = ~(e_code ^ a_code);
    assign out[3]  = ~(e_code ^ b_code);
    assign out[2]  = ~(e_code ^ c_code);
    assign out[1]  = ~(e_code ^ d_code);
    assign out[0]  = ~(e_code ^ e_code);

endmodule
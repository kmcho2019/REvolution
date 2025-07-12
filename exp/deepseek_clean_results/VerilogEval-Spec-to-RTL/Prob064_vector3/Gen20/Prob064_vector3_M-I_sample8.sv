module TopModule (
    input [4:0] a,  // 5-bit input
    input [4:0] b,  // 5-bit input
    input [4:0] c,  // 5-bit input
    input [4:0] d,  // 5-bit input
    input [4:0] e,  // 5-bit input
    input [4:0] f,  // 5-bit input
    output [7:0] w, // MSB 8 bits of {a,b,c,d,e,f,2'b11}
    output [7:0] x, // Next 8 bits
    output [7:0] y, // Next 8 bits
    output [7:0] z  // LSB 8 bits (includes padding)
);

    /* Concatenate all inputs (30 bits) with 2'b11 padding (32 bits total)
     * and split into four 8-bit outputs:
     * w = bits [31:24] = {a[4:0], b[4:2]}
     * x = bits [23:16] = {b[1:0], c[4:0], d[4:5]}
     * y = bits [15:8]  = {d[3:0], e[4:0], f[4:4]}
     * z = bits [7:0]   = {f[3:0], 2'b11}
     */
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule
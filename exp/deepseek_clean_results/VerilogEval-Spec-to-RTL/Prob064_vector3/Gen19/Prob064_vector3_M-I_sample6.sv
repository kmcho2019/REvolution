module TopModule (
    input [4:0] a,  // First 5-bit input (bits 29:25 of final output)
    input [4:0] b,  // Second 5-bit input (bits 24:20)
    input [4:0] c,  // Third 5-bit input (bits 19:15)
    input [4:0] d,  // Fourth 5-bit input (bits 14:10)
    input [4:0] e,  // Fifth 5-bit input (bits 9:5)
    input [4:0] f,  // Sixth 5-bit input (bits 4:0)
    output [7:0] w, // First 8-bit output (bits 31:24)
    output [7:0] x, // Second 8-bit output (bits 23:16)
    output [7:0] y, // Third 8-bit output (bits 15:8)
    output [7:0] z  // Fourth 8-bit output (bits 7:0, includes padding)
);

    /* Concatenation and output mapping:
     * Total input bits: 6 inputs × 5 bits = 30 bits
     * Padding: 2'b11 added as LSBs (bits 1:0)
     * Final 32-bit value: {a[4:0], b[4:0], c[4:0], d[4:0], e[4:0], f[4:0], 2'b11}
     * Output assignments:
     * w <= final_value[31:24]
     * x <= final_value[23:16]
     * y <= final_value[15:8]
     * z <= final_value[7:0] (includes padding bits)
     */
    assign {w, x, y, z} = {a[4:0], b[4:0], c[4:0], d[4:0], e[4:0], f[4:0], 2'b11};

endmodule
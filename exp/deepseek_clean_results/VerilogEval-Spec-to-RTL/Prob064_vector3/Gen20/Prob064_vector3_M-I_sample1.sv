module TopModule (
    input [4:0] a,  // First 5-bit input (bits 29:25 of final output)
    input [4:0] b,  // Second 5-bit input (bits 24:20)
    input [4:0] c,  // Third 5-bit input (bits 19:15)
    input [4:0] d,  // Fourth 5-bit input (bits 14:10)
    input [4:0] e,  // Fifth 5-bit input (bits 9:5)
    input [4:0] f,  // Sixth 5-bit input (bits 4:2)
    output [7:0] w, // First 8-bit output (bits 31:24)
    output [7:0] x, // Second 8-bit output (bits 23:16)
    output [7:0] y, // Third 8-bit output (bits 15:8)
    output [7:0] z  // Fourth 8-bit output (bits 7:0, includes padding)
);

    /* Optimized concatenation and output mapping:
     * Total input bits: 6 inputs × 5 bits = 30 bits
     * Padding: 2'b11 added directly to z output (bits 1:0)
     * Output assignments:
     * w <= {a, b[4:2]} (8 bits)
     * x <= {b[1:0], c, d[4:4]} (8 bits)
     * y <= {d[3:0], e} (8 bits)
     * z <= {f, 2'b11} (8 bits, includes padding)
     */
    assign w = {a, b[4:2]};
    assign x = {b[1:0], c, d[4:4]};
    assign y = {d[3:0], e};
    assign z = {f, 2'b11};

endmodule
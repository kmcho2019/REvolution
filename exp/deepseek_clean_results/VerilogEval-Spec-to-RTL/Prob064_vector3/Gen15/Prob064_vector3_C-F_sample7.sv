module TopModule (
    input [4:0] a,  // 5-bit input
    input [4:0] b,  // 5-bit input
    input [4:0] c,  // 5-bit input
    input [4:0] d,  // 5-bit input
    input [4:0] e,  // 5-bit input
    input [4:0] f,  // 5-bit input
    output [7:0] w, // 8-bit output (MSBs)
    output [7:0] x, // 8-bit output
    output [7:0] y, // 8-bit output
    output [7:0] z  // 8-bit output (includes padding LSBs)
);

    /* Bit allocation:
     * Total input bits: 6 inputs × 5 bits = 30 bits
     * Total output bits: 4 outputs × 8 bits = 32 bits
     * Padding needed: 2 bits (added as 2'b11 in LSB positions)
     *
     * Output mapping:
     * w[7:0] = {a, b[4:2]}       (bits 31:24)
     * x[7:0] = {b[1:0], c, d[4:4} (bits 23:16)
     * y[7:0] = {d[3:0], e}        (bits 15:8)
     * z[7:0] = {f, 2'b11}         (bits 7:0)
     */
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule
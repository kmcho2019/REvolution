/*
 * System Overview:
 * Combines six 5-bit inputs into four 8-bit outputs with padding
 * Total input bits: 6 × 5 = 30 bits
 * Total output bits: 4 × 8 = 32 bits
 * Padding: 2'b11 added as LSBs (bits 1:0)
 * Concatenation: {a, b, c, d, e, f, 2'b11}
 */

module TopModule (
    input [4:0] a,  // Input a (bits 29:25 of final 32-bit word)
    input [4:0] b,  // Input b (bits 24:20)
    input [4:0] c,  // Input c (bits 19:15)
    input [4:0] d,  // Input d (bits 14:10)
    input [4:0] e,  // Input e (bits 9:5)
    input [4:0] f,  // Input f (bits 4:2), with bits 1:0 being padding
    output [7:0] w, // Output w (bits 31:24)
    output [7:0] x, // Output x (bits 23:16)
    output [7:0] y, // Output y (bits 15:8)
    output [7:0] z  // Output z (bits 7:0, includes padding bits 1:0)
);

    /* Final 32-bit word composition:
     * [31:30] - Unused (will be 0 from input MSBs)
     * [29:25] - Input a
     * [24:20] - Input b
     * [19:15] - Input c
     * [14:10] - Input d
     * [9:5]   - Input e
     * [4:2]   - Input f[4:2]
     * [1:0]   - Padding (2'b11)
     */
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule
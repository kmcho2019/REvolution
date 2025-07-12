module TopModule (
    input [4:0] a,  // First 5-bit input
    input [4:0] b,  // Second 5-bit input
    input [4:0] c,  // Third 5-bit input
    input [4:0] d,  // Fourth 5-bit input
    input [4:0] e,  // Fifth 5-bit input
    input [4:0] f,  // Sixth 5-bit input
    output [7:0] w, // First 8-bit output (MSBs)
    output [7:0] x, // Second 8-bit output
    output [7:0] y, // Third 8-bit output
    output [7:0] z  // Fourth 8-bit output (includes padding)
);

    /* Parameters for clarity (not strictly needed but improves maintainability) */
    localparam INPUT_WIDTH = 5;
    localparam OUTPUT_WIDTH = 8;
    localparam NUM_INPUTS = 6;
    localparam NUM_OUTPUTS = 4;
    
    /* Bit allocation:
     * Total input bits: 6 inputs × 5 bits = 30 bits
     * Total output bits: 4 outputs × 8 bits = 32 bits
     * Padding needed: 2 bits (added as 2'b11 in LSB positions)
     *
     * Concatenation order:
     * {a, b, c, d, e, f, 2'b11} -> total 32 bits
     * Output mapping:
     * w gets bits [31:24]
     * x gets bits [23:16]
     * y gets bits [15:8]
     * z gets bits [7:0] (includes padding bits)
     */
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule
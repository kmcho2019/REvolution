module TopModule (
    input [4:0] a,  // Input vector A (5 bits)
    input [4:0] b,  // Input vector B (5 bits)
    input [4:0] c,  // Input vector C (5 bits)
    input [4:0] d,  // Input vector D (5 bits)
    input [4:0] e,  // Input vector E (5 bits)
    input [4:0] f,  // Input vector F (5 bits)
    output [7:0] w, // Output vector W (bits [31:24] of concatenation)
    output [7:0] x, // Output vector X (bits [23:16] of concatenation)
    output [7:0] y, // Output vector Y (bits [15:8] of concatenation)
    output [7:0] z  // Output vector Z (bits [7:0] of concatenation, includes padding)
);

    // Configuration parameters
    localparam INPUT_BITS = 5;
    localparam OUTPUT_BITS = 8;
    localparam NUM_INPUTS = 6;
    localparam NUM_OUTPUTS = 4;
    localparam PADDING_VALUE = 2'b11;  // Padding bits in LSB positions

    /* Module Description:
     * Concatenates six 5-bit inputs (30 bits total) with 2-bit padding
     * and distributes across four 8-bit outputs (32 bits total).
     * Padding bits (2'b11) are placed in the LSB positions (output z[1:0]).
     *
     * Bit allocation:
     * w[7:0] = {a[4:0], b[4:2]}       (8 bits)
     * x[7:0] = {b[1:0], c[4:0], d[4:5]} (8 bits)
     * y[7:0] = {d[3:0], e[4:0], f[4:4]} (8 bits)
     * z[7:0] = {f[3:0], PADDING_VALUE} (8 bits)
     */
    assign {w, x, y, z} = {a, b, c, d, e, f, PADDING_VALUE};

endmodule
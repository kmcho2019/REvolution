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
    output [7:0] z  // Fourth 8-bit output (LSBs)
);

    // Concatenate all inputs (6x5b = 30b) with 2'b11 padding as LSBs
    // Then split into four 8-bit outputs (32 bits total)
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule
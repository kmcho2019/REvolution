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

    // Create intermediate 32-bit signal with inputs and padding
    wire [31:0] combined = {a, b, c, d, e, f, 2'b11};

    // Assign each output from slices of the combined signal
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule
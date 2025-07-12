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

    // Concatenate all inputs (6x5b = 30b) and pad with 2'b11 to make 32 bits
    // The padding bits are added as LSBs (bits [1:0])
    wire [31:0] concatenated_data = {a, b, c, d, e, f, 2'b11};

    // Split the 32-bit concatenated data into four 8-bit outputs
    assign w = concatenated_data[31:24]; // MSBs
    assign x = concatenated_data[23:16];
    assign y = concatenated_data[15:8];
    assign z = concatenated_data[7:0];   // LSBs (includes the padding bits)

endmodule
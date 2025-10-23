module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // Create the 32-bit concatenated vector
    wire [31:0] full_vector = {a, b, c, d, e, f, 2'b11};

    // Distribute bits using shifting approach
    assign w = full_vector[31:24];  // First 8 bits
    assign x = full_vector[23:16];  // Next 8 bits
    assign y = full_vector[15:8];   // Next 8 bits
    assign z = full_vector[7:0];    // Last 8 bits (includes the two 1's)

endmodule
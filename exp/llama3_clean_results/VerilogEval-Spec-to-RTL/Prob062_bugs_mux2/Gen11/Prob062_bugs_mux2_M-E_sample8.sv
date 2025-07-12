module TopModule (
    input        sel, // Select signal (1-bit)
    input  [7:0] a,   // First 8-bit input vector
    input  [7:0] b,   // Second 8-bit input vector
    output [7:0] out  // Selected 8-bit output vector
);

    // Create a masked version of input vector a when sel is 0
    wire [7:0] a_masked;
    assign a_masked = a & (~sel);

    // Create a masked version of input vector b when sel is 1
    wire [7:0] b_masked;
    assign b_masked = b & sel;

    // Use an 8-bit OR gate to combine the masked vectors
    assign out = a_masked | b_masked;

endmodule
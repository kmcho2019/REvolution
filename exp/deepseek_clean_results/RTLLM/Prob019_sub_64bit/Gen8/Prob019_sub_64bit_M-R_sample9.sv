module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Split into upper and lower 32-bit segments
    wire [31:0] A_low = A[31:0];
    wire [31:0] A_high = A[63:32];
    wire [31:0] B_low = B[31:0];
    wire [31:0] B_high = B[63:32];

    // Compute lower 32 bits and carry out
    wire [31:0] result_low;
    wire carry_out;
    assign {carry_out, result_low} = {1'b0, A_low} - {1'b0, B_low};

    // Compute upper 32 bits with carry in
    wire [31:0] result_high;
    assign result_high = A_high - B_high - carry_out;

    // Combine results
    assign result = {result_high, result_low};

    // Overflow detection (same logic as original but computed in parallel)
    wire signs_differ = A[63] ^ B[63];
    wire result_sign_differs = A[63] ^ result[63];
    assign overflow = signs_differ & result_sign_differs;

endmodule
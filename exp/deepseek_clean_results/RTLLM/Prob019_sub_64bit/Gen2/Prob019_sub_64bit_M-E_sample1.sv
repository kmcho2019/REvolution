module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output reg overflow
);

    // Split into upper and lower 32-bit segments
    wire [31:0] A_lo = A[31:0];
    wire [31:0] A_hi = A[63:32];
    wire [31:0] B_lo = B[31:0];
    wire [31:0] B_hi = B[63:32];
    
    // First stage: lower 32 bits
    wire [32:0] diff_lo; // Extra bit for carry out
    assign diff_lo = {1'b0, A_lo} - {1'b0, B_lo};
    
    // Second stage: upper 32 bits with carry
    wire [32:0] diff_hi;
    assign diff_hi = {1'b0, A_hi} - {1'b0, B_hi} - {32'd0, diff_lo[32]};
    
    // Combine results
    assign result = {diff_hi[31:0], diff_lo[31:0]};
    
    // Overflow detection logic
    always @(*) begin
        // Detect if signs of A and B differ
        wire signs_differ = A[63] ^ B[63];
        
        // Detect if result sign differs from A sign
        wire result_sign_differs = A[63] ^ result[63];
        
        // Overflow occurs when signs differ and result sign differs from A
        overflow = signs_differ & result_sign_differs;
    end

endmodule
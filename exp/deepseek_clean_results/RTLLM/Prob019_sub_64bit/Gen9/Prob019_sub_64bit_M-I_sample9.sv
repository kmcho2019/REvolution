module sub_64bit (
    input signed [63:0] A,    // First signed operand
    input signed [63:0] B,    // Second signed operand (to subtract)
    output signed [63:0] result,  // Signed result of A - B
    output reg overflow       // Registered overflow flag for isolation
);

    // Perform signed subtraction (main critical path)
    wire signed [63:0] diff = A - B;
    
    // Shared sign comparison logic
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire diff_sign = diff[63];
    
    // Overflow detection with operand isolation
    always @(*) begin
        // Only evaluate overflow when inputs change
        overflow = (A_sign ^ B_sign) & (diff_sign ^ A_sign);
    end
    
    // Direct assignment for result
    assign result = diff;

endmodule
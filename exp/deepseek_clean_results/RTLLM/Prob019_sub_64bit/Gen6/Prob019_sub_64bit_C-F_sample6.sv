module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Continuous assignment for efficient subtraction
    assign result = A - B;
    
    // Structured overflow detection
    always_comb begin
        overflow = (A[63] != B[63]) && (A[63] != result[63]);
    end

endmodule
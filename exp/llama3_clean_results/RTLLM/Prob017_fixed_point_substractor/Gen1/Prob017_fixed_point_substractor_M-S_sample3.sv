module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits (integer and fractional)
) (
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

always @(*) begin
    // Directly perform the subtraction operation
    c = a - b;
    
    // Handle zero result
    if (c == 0) begin
        c = 0;
    end
end

endmodule
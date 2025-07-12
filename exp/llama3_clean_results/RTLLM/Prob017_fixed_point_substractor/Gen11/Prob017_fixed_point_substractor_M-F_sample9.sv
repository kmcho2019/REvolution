module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg signed [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Perform subtraction operation
    res = a - b;
    
    // Explicitly handle the case where the result is zero
    if (res == 0) begin
        c = 0;  // Set the output to 0 when the result is zero
    end else begin
        c = res;  // Otherwise, assign the result to the output
    end
end

endmodule
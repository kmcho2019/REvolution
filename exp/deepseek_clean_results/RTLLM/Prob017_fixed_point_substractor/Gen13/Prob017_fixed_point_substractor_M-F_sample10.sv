module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits (integer + fractional)
) (
    input wire [N-1:0] a,  // First fixed-point operand
    input wire [N-1:0] b,  // Second fixed-point operand
    output wire [N-1:0] c  // Fixed-point result (a - b)
);

    // Core subtraction operation using two's complement arithmetic
    wire [N-1:0] raw_result = a - b;
    
    // Detect zero result (all bits zero)
    wire result_zero = (raw_result == 0);
    
    // Output assignment: force positive zero when result is zero
    assign c = result_zero ? 0 : raw_result;

endmodule
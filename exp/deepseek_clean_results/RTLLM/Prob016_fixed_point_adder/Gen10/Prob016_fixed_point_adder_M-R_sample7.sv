module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Declare signals as signed for arithmetic operations
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform addition with extended bit width to prevent overflow
    wire signed [N:0] sum_ext = a_signed + b_signed;
    
    // Detect overflow conditions
    wire overflow_pos = ~a_signed[N-1] & ~b_signed[N-1] &  sum_ext[N];
    wire overflow_neg =  a_signed[N-1] &  b_signed[N-1] & ~sum_ext[N];
    
    // Apply saturation if overflow occurs
    wire signed [N-1:0] saturated_result = 
        overflow_pos ? {1'b0, {(N-1){1'b1}}} :  // Max positive
        overflow_neg ? {1'b1, {(N-1){1'b0}}} :  // Max negative
        sum_ext[N-1:0];                         // Normal result
    
    // Assign output while maintaining fixed-point precision
    assign c = saturated_result;

endmodule
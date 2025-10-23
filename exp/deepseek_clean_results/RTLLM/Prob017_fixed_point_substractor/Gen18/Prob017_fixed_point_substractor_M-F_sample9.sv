module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // The subtraction operation in two's complement is the same as addition
    // of the negative, so we can simply use a - b = a + (-b)
    // This handles all sign cases automatically
    wire [N-1:0] subtraction_result = a - b;

    // Zero detection - check if all bits except sign are zero
    wire is_zero = (subtraction_result[N-2:0] == {(N-1){1'b0}};

    // For zero result, ensure sign bit is explicitly 0
    assign c = is_zero ? {1'b0, {(N-1){1'b0}}} : subtraction_result;

    /* Alternative implementation with more explicit sign handling
    // Extract signs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Perform subtraction on magnitudes (absolute values)
    wire [N-1:0] mag_a = a_sign ? -a : a;
    wire [N-1:0] mag_b = b_sign ? -b : b;
    wire [N-1:0] mag_result = mag_a - mag_b;
    
    // Determine result sign
    wire result_sign = (a_sign ^ b_sign) ? a_sign : 
                      (mag_a > mag_b) ? a_sign : b_sign;
    
    // Final result with sign application
    assign c = result_sign ? -mag_result : mag_result;
    */

endmodule
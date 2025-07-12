module fixed_point_adder #(
    parameter integer N = 16,      // Total bits including sign bit
    parameter integer Q = 8        // Number of fractional bits (interface purpose)
)(
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c          // Fixed-point output result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Determine operation based on sign bits
    wire signs_equal = (a_sign == b_sign);

    // Add absolute values when signs equal
    wire [N:0] abs_sum = {1'b0, a_abs} + {1'b0, b_abs}; // N+1 bits to detect carry

    // Subtract absolute values when signs differ
    wire a_greater = (a_abs >= b_abs);
    wire [N-1:0] abs_diff = a_greater ? (a_abs - b_abs) : (b_abs - a_abs);

    // Compose result magnitude and sign
    wire [N-1:0] result_mag = signs_equal ? abs_sum[N-1:0] : abs_diff;

    // Determine result sign
    // If signs equal, result sign same as inputs
    // If signs differ, sign of the operand with larger absolute value; zero result sign 0
    wire result_sign = signs_equal ? a_sign : (a_greater ? a_sign : 
                         (abs_diff == 0 ? 1'b0 : b_sign));

    // Combine sign and magnitude
    wire [N-1:0] result = result_sign ? (~result_mag + 1'b1) : result_mag;

    // Assign output
    assign c = result;

endmodule
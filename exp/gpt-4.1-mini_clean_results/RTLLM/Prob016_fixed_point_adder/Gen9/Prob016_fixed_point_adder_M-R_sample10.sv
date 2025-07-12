module fixed_point_adder #(
    parameter integer Q = 8,         // Number of fractional bits (precision)
    parameter integer N = 16         // Total number of bits including sign
)(
    input  wire [N-1:0] a,           // Fixed-point input operand A
    input  wire [N-1:0] b,           // Fixed-point input operand B
    output wire [N-1:0] c            // Fixed-point addition result
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Intermediate results for addition or subtraction
    wire [N:0] sum_abs = abs_a + abs_b;          // N+1 bits to hold possible carry
    wire [N-1:0] diff_abs_ab = (abs_a >= abs_b) ? (abs_a - abs_b) : (abs_b - abs_a);

    // Determine output sign and magnitude based on sign bits and magnitude comparison
    wire result_sign;
    wire [N-1:0] result_mag;

    assign result_sign = (sign_a == sign_b) ? sign_a : 
                         (abs_a == abs_b)   ? 1'b0 : // result is zero -> positive zero
                         (abs_a > abs_b)    ? sign_a : sign_b;

    assign result_mag = (sign_a == sign_b) ?
                        sum_abs[N-1:0] : // sum of abs, discard overflow bit (saturation not implemented)
                        diff_abs_ab;

    // Final result: sign concatenated with magnitude (sign magnitude representation in N bits)
    // But since inputs and outputs are in two's complement fixed point, we convert sign+mag back to two's complement
    // Convert sign & magnitude to two's complement number:
    // If sign=0, result = magnitude
    // If sign=1, result = two's complement of magnitude

    wire [N-1:0] result_twos_comp = result_sign ? (~result_mag + 1'b1) : result_mag;

    assign c = result_twos_comp;

endmodule
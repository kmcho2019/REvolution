module fixed_point_adder #(
    parameter integer Q = 8,   // Number of fractional bits (precision)
    parameter integer N = 16   // Total number of bits including sign
)(
    input  wire [N-1:0] a,    // Fixed-point input operand A
    input  wire [N-1:0] b,    // Fixed-point input operand B
    output wire [N-1:0] c     // Fixed-point addition result
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values of a and b
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Compare absolute values
    wire a_gt_b = (abs_a > abs_b);
    wire abs_eq = (abs_a == abs_b);

    // Temporary result magnitude and sign
    wire [N-1:0] mag_sum;
    wire        res_sign;

    // Add absolute values if same sign
    wire [N:0] abs_add = {1'b0, abs_a} + {1'b0, abs_b};  // Extra bit for overflow

    // Subtract absolute values if different sign
    wire [N-1:0] abs_diff = a_gt_b ? (abs_a - abs_b) : (abs_b - abs_a);

    // Determine result sign and magnitude per problem spec
    assign res_sign = (sign_a == sign_b) ? sign_a  // Same sign: result sign = sign of inputs
                    : (abs_eq       ? 1'b0          // Equal absolute values => zero result positive sign
                    : (a_gt_b      ? sign_a        // Different sign: larger magnitude's sign
                                  : sign_b));

    assign mag_sum = (sign_a == sign_b) ? abs_add[N-1:0]   // Add absolute values and truncate if overflow
                    : abs_diff;                            // Subtract smaller from larger

    // Reconstruct result in sign-magnitude form
    wire [N-1:0] res_mag = mag_sum;

    // Convert sign-magnitude back to two's complement signed number:
    // If sign = 0, result is magnitude as is; if sign = 1, result = two's complement (negate magnitude)
    assign c = res_sign ? (~res_mag + 1'b1) : res_mag;

endmodule
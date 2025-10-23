module fixed_point_adder #(
    parameter integer N = 16,      // Total width (including sign bit)
    parameter integer Q = 8        // Number of fractional bits (informative)
) (
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c          // Fixed-point output result with saturation
);

    // Perform addition with carry out
    wire [N:0] sum_ext = {1'b0, a} + {1'b0, b};

    // Extract result and sign bits
    wire sum_sign = sum_ext[N];
    wire sum_msb = sum_ext[N-1];

    // Overflow detection for two's complement addition:
    // Overflow occurs if carry into MSB differs from carry out of MSB.
    // Using sign bits: overflow if sum of a and b results in invalid sign.
    wire overflow = (a[N-1] == b[N-1]) && (sum_msb != a[N-1]);

    // Define saturation limits
    localparam [N-1:0] POS_MAX = {1'b0, {(N-1){1'b1}}}; // max positive number
    localparam [N-1:0] NEG_MIN = {1'b1, {(N-1){1'b0}}}; // max negative number (most negative)

    // Result before saturation
    wire [N-1:0] sum = sum_ext[N-1:0];

    // Saturate on overflow
    // If overflow and inputs positive, saturate to POS_MAX
    // If overflow and inputs negative, saturate to NEG_MIN
    // Else output sum directly
    wire [N-1:0] saturated_sum = overflow ?
                                 (a[N-1] ? NEG_MIN : POS_MAX) :
                                 sum;

    assign c = saturated_sum;

endmodule
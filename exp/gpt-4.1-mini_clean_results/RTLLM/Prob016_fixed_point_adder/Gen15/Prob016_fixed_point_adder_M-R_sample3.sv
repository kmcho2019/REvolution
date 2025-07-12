module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits (precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c           // Fixed-point output result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute magnitudes (absolute values)
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Check if signs are equal
    wire same_sign = (a_sign == b_sign);

    // Magnitude comparison
    wire a_greater_equal = (a_mag >= b_mag);

    // Add magnitudes with one extra bit to prevent overflow in intermediate sum
    wire [N:0] sum_mag = {1'b0, a_mag} + {1'b0, b_mag};

    // Subtract magnitudes with one extra bit for borrow detection
    wire [N:0] diff_mag_a_b = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N:0] diff_mag_b_a = {1'b0, b_mag} - {1'b0, a_mag};

    // Determine result magnitude and sign based on sign conditions
    wire [N-1:0] res_mag = same_sign ? sum_mag[N-1:0] :
                           (a_greater_equal ? diff_mag_a_b[N-1:0] : diff_mag_b_a[N-1:0]);

    wire res_sign_prezero = same_sign ? a_sign :
                            (a_greater_equal ? a_sign : b_sign);

    // If result magnitude is zero, force sign to 0 (positive zero)
    wire res_zero = (res_mag == {N{1'b0}});
    wire res_sign = res_zero ? 1'b0 : res_sign_prezero;

    // Convert sign + magnitude back to two's complement
    wire [N-1:0] res_twos_complement = res_sign ? (~res_mag + 1'b1) : res_mag;

    assign c = res_twos_complement;

endmodule
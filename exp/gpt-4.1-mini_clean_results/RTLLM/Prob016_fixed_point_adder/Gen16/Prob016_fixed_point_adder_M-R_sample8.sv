module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits (precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c           // Fixed-point output result
);

    // Step 1: Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Step 2: Compute magnitude (absolute value)
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Step 3: Determine if signs are equal
    wire signs_equal = (a_sign == b_sign);

    // Step 4: Prepare wider vectors to prevent overflow in intermediate sums/differences
    wire [N:0] sum_mag = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N:0] diff_mag_ab = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N:0] diff_mag_ba = {1'b0, b_mag} - {1'b0, a_mag};

    // Step 5: Compare magnitudes to decide subtraction order when signs differ
    wire a_ge_b = (a_mag >= b_mag);

    // Step 6: Select magnitude and sign of the result
    wire [N-1:0] result_mag = signs_equal ? sum_mag[N-1:0] :
                              (a_ge_b ? diff_mag_ab[N-1:0] : diff_mag_ba[N-1:0]);

    wire result_sign_pre_zero = signs_equal ? a_sign :
                                (a_ge_b ? a_sign : b_sign);

    // Step 7: If result is zero magnitude, force sign to 0 (positive)
    wire result_zero = (result_mag == {N{1'b0}});
    wire result_sign = result_zero ? 1'b0 : result_sign_pre_zero;

    // Step 8: Convert sign and magnitude back to two's complement form
    wire [N-1:0] result_twos_complement = result_sign ? (~result_mag + 1'b1) : result_mag;

    // Output assignment
    assign c = result_twos_complement;

endmodule
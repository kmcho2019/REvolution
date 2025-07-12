module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision), default 8
    parameter integer N = 16          // Total number of bits including sign, default 16
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal signals for sign and magnitude extraction
    reg sign_a;
    reg sign_b;
    reg [N-2:0] mag_a;
    reg [N-2:0] mag_b;

    // Intermediate signals for magnitude sum, difference, and comparisons
    reg [N-1:0] mag_sum;
    reg [N-1:0] mag_diff;
    reg a_greater_eq_b;
    reg res_sign;
    reg [N-2:0] res_mag;
    reg zero_mag;
    reg final_sign;

    always @(*) begin
        // Extract sign bits
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute magnitude (absolute value) of a and b
        mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
        mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

        // Compare magnitudes
        a_greater_eq_b = (mag_a >= mag_b);

        // Calculate sum and difference of magnitudes with zero-extended MSB to avoid overflow issues
        mag_sum = {1'b0, mag_a} + {1'b0, mag_b};
        mag_diff = a_greater_eq_b ? ({1'b0, mag_a} - {1'b0, mag_b})
                                  : ({1'b0, mag_b} - {1'b0, mag_a});

        // Determine result sign
        if (sign_a == sign_b) begin
            // Same signs => add magnitudes
            res_sign = sign_a;
            res_mag  = mag_sum[N-2:0];
        end else begin
            // Different signs => subtract magnitudes
            if (a_greater_eq_b) begin
                res_sign = sign_a;
                res_mag  = mag_diff[N-2:0];
            end else begin
                res_sign = sign_b;
                res_mag  = mag_diff[N-2:0];
            end
        end

        // Check for zero magnitude to force positive zero
        zero_mag = (res_mag == { (N-1){1'b0} });
        final_sign = zero_mag ? 1'b0 : res_sign;

        // Construct two's complement output
        if (final_sign)
            c = {1'b1, (~res_mag + 1'b1)};
        else
            c = {1'b0, res_mag};
    end

endmodule
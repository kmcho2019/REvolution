module fixed_point_adder #(
    parameter integer N = 16,        // Total bits width (including sign)
    parameter integer Q = 8          // Fractional bits (for user reference)
)(
    input  wire [N-1:0] a,           // Input fixed-point operand a (two's complement)
    input  wire [N-1:0] b,           // Input fixed-point operand b (two's complement)
    output reg  [N-1:0] c            // Output fixed-point result (two's complement)
);

    // Internal signals
    reg          a_sign, b_sign;
    reg [N-2:0]  a_mag, b_mag;       // Magnitudes (N-1 bits, excluding sign bit)
    reg [N-1:0]  mag_sum;             // Sum of magnitudes, can be up to N bits
    reg [N-1:0]  mag_diff;            // Difference of magnitudes
    reg          res_sign;
    reg [N-1:0]  res_mag;
    reg          signs_equal;
    reg          a_greater_mag;

    // Convert inputs from two's complement to sign-magnitude
    // Magnitude is absolute value of a and b
    always @* begin
        // Extract sign bits
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Compute magnitude by absolute value (sign-magnitude)
        // If sign bit = 1, magnitude = two's complement (invert + 1)
        if (a_sign)
            a_mag = (~a[N-2:0] + 1'b1);
        else
            a_mag = a[N-2:0];

        if (b_sign)
            b_mag = (~b[N-2:0] + 1'b1);
        else
            b_mag = b[N-2:0];

        // Check if signs are equal
        signs_equal = (a_sign == b_sign);

        if (signs_equal) begin
            // Same sign: add magnitudes
            mag_sum = a_mag + b_mag;
            // Assign magnitude and sign
            // If sum overflows beyond N-1 bits, overflow wraps naturally
            res_mag  = mag_sum[N-2:0];  // Take lower N-1 bits
            res_sign = a_sign;
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            a_greater_mag = (a_mag >= b_mag);
            if (a_greater_mag) begin
                mag_diff = a_mag - b_mag;
                res_sign = a_sign;       // sign of the larger magnitude
            end else begin
                mag_diff = b_mag - a_mag;
                res_sign = b_sign;
            end
            res_mag = mag_diff[N-2:0];   // Lower N-1 bits

            // If difference is zero, set sign to zero (positive zero)
            if (mag_diff == 0)
                res_sign = 1'b0;
        end

        // Convert sign-magnitude back to two's complement
        if (res_sign)
            c = {1'b1, (~res_mag + 1'b1)};
        else
            c = {1'b0, res_mag};
    end

endmodule
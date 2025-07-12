module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits (not directly used but defines precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Internal registers for sign, magnitude, and result
    reg a_sign, b_sign;
    reg [N-1:0] a_abs, b_abs;
    reg signs_equal;
    reg [N:0] sum_abs;    // N+1 bits to hold carry
    reg [N-1:0] diff_abs;
    reg a_greater;
    reg [N-1:0] res_mag;
    reg res_sign;
    reg [N-1:0] res_val;

    always @* begin
        // Extract signs
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Calculate absolute values (magnitude) via two's complement if negative
        a_abs = a_sign ? (~a + 1'b1) : a;
        b_abs = b_sign ? (~b + 1'b1) : b;

        // Determine if signs are equal
        signs_equal = (a_sign == b_sign);

        // Compute sum and difference magnitudes
        sum_abs = {1'b0, a_abs} + {1'b0, b_abs}; // N+1 bits to detect overflow

        a_greater = (a_abs >= b_abs);
        diff_abs = a_greater ? (a_abs - b_abs) : (b_abs - a_abs);

        // Determine result magnitude and sign based on operand signs
        if (signs_equal) begin
            // Same signs: add magnitudes, sign remains same
            res_mag  = sum_abs[N-1:0];    // Take lower N bits (drop carry)
            res_sign = a_sign;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            res_mag  = diff_abs;
            if (res_mag == 0) begin
                res_sign = 1'b0;          // Zero is positive by convention
            end else begin
                res_sign = a_greater ? a_sign : b_sign;
            end
        end

        // Convert magnitude and sign back to two's complement
        if (res_sign)
            res_val = ~res_mag + 1'b1;
        else
            res_val = res_mag;

        // Assign to output
        c = res_val;
    end

endmodule
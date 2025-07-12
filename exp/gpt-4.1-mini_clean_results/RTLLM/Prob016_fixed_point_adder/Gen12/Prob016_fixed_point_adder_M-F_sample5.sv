module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign bit)
    parameter integer Q = 8         // Number of fractional bits (fixed-point precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point output result (two's complement)
);

    // Internal registers
    reg a_sign, b_sign;
    reg [N-1:0] a_abs, b_abs;
    reg signs_equal;
    reg [N:0] sum_abs;             // N+1 bits to hold carry out of addition
    reg [N-1:0] diff_abs;
    reg a_greater;
    reg [N-1:0] res_mag;
    reg res_sign;
    reg [N-1:0] res_val;

    always @* begin
        // Extract sign bits
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Calculate absolute values using two's complement if negative
        a_abs = a_sign ? (~a + 1'b1) : a;
        b_abs = b_sign ? (~b + 1'b1) : b;

        // Determine if signs are equal
        signs_equal = (a_sign == b_sign);

        if (signs_equal) begin
            // Same sign: add magnitudes
            sum_abs = {1'b0, a_abs} + {1'b0, b_abs};
            res_mag  = sum_abs[N-1:0];    // Lower N bits (drop carry out)
            res_sign = a_sign;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            a_greater = (a_abs >= b_abs);
            diff_abs = a_greater ? (a_abs - b_abs) : (b_abs - a_abs);

            res_mag = diff_abs;
            if (res_mag == 0) begin
                // Result is zero, conventionally positive sign
                res_sign = 1'b0;
            end else begin
                // Sign is sign of operand with larger magnitude
                res_sign = a_greater ? a_sign : b_sign;
            end
        end

        // Convert magnitude and sign back to two's complement
        if (res_sign)
            res_val = ~res_mag + 1'b1;   // Negative number
        else
            res_val = res_mag;            // Positive number

        // Assign to output
        c = res_val;
    end

endmodule
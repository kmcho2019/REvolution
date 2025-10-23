module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total bits (including sign bit)
)(
    input  wire [N-1:0] a,       // Fixed-point input a (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input b (two's complement)
    output reg  [N-1:0] c        // Fixed-point sum output (two's complement)
);

    // Internal signals for sign and magnitude extraction
    reg sign_a, sign_b, sign_res;
    reg [N-2:0] mag_a, mag_b;       // Magnitudes of a and b (without sign bit)
    reg [N-1:0] sum_mag;             // For addition result (one bit wider)
    reg [N-2:0] diff_mag;            // For subtraction result (same width as magnitude)

    always @(*) begin
        // Extract sign bits (MSB)
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute absolute values by two's complement if negative
        mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
        mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            sum_mag = {1'b0, mag_a} + {1'b0, mag_b};  // One bit wider addition
            sign_res = sign_a;

            // Take lower N-1 bits (discard overflow bit)
            // Overflow is ignored (could be saturation or wrap-around in real designs)
            c = {sign_res, sum_mag[N-2:0]};
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a > mag_b) begin
                diff_mag = mag_a - mag_b;
                sign_res = sign_a;
                c = {sign_res, diff_mag};
            end else if (mag_b > mag_a) begin
                diff_mag = mag_b - mag_a;
                sign_res = sign_b;
                c = {sign_res, diff_mag};
            end else begin
                // Magnitudes equal => result zero (positive zero)
                c = {1'b0, {(N-1){1'b0}}};
            end
        end
    end

endmodule
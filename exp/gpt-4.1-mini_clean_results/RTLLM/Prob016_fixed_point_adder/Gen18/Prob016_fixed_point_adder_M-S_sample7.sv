module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total bits (including sign)
)(
    input  wire [N-1:0] a,       // Fixed-point input a (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input b (two's complement)
    output reg  [N-1:0] c        // Fixed-point sum output (two's complement)
);

    // Internal signals for sign and magnitude
    reg sign_a, sign_b, sign_res;
    reg [N-2:0] mag_a, mag_b, mag_res;
    reg [N-1:0] sum_mag;          // For magnitude addition with carry
    reg [N-2:0] diff_mag;

    always @(*) begin
        // Extract sign bits
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute absolute values
        mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
        mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            sum_mag = {1'b0, mag_a} + {1'b0, mag_b};
            sign_res = sign_a;
            // Take lower N-1 bits; overflow ignored for simplicity
            mag_res = sum_mag[N-2:0];
            c = {sign_res, mag_res};
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a >= mag_b) begin
                diff_mag = mag_a - mag_b;
                sign_res = (mag_a == mag_b) ? 1'b0 : sign_a;  // zero result => positive zero
                c = {sign_res, diff_mag};
            end else begin
                diff_mag = mag_b - mag_a;
                sign_res = sign_b;
                c = {sign_res, diff_mag};
            end
        end
    end

endmodule
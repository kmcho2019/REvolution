module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits (precision)
    parameter integer N = 16     // Total number of bits including sign
)(
    input  wire [N-1:0] a,       // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c        // Fixed-point addition result (two's complement)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract magnitudes: if negative, magnitude = two's complement of input, else input as is
    wire [N-1:0] mag_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] mag_b = sign_b ? (~b + 1'b1) : b;

    // Determine if signs are equal
    wire signs_equal = (sign_a == sign_b);

    // Magnitude addition (with carry-out)
    wire [N:0] mag_add = {1'b0, mag_a} + {1'b0, mag_b};

    // Magnitude subtraction: subtract smaller magnitude from larger
    wire mag_a_gt_b = (mag_a > mag_b);
    wire [N-1:0] mag_diff = mag_a_gt_b ? (mag_a - mag_b) : (mag_b - mag_a);

    // Result magnitude and sign signals (combinational)
    reg [N-1:0] res_mag;
    reg         res_sign;

    // Saturation magnitude max (all ones except MSB zero)
    localparam [N-1:0] MAX_MAG = {1'b0, {(N-1){1'b1}}};

    always @(*) begin
        if (signs_equal) begin
            // Same sign: add magnitudes
            if (mag_add[N]) begin
                // Overflow in magnitude addition - saturate to max magnitude
                res_mag = MAX_MAG;
            end else begin
                res_mag = mag_add[N-1:0];
            end
            res_sign = sign_a;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a == mag_b) begin
                // Magnitudes equal -> result zero
                res_mag = {N{1'b0}};
                res_sign = 1'b0;
            end else if (mag_a_gt_b) begin
                res_mag = mag_diff;
                res_sign = sign_a;  // sign of larger magnitude
            end else begin
                res_mag = mag_diff;
                res_sign = sign_b;
            end
        end
    end

    // Convert from sign and magnitude to two's complement
    // If sign is zero (positive), c = res_mag
    // If sign is one (negative), c = two's complement of res_mag
    wire [N-1:0] res_twos_comp = res_sign ? (~res_mag + 1'b1) : res_mag;

    // Register the result as specified
    reg [N-1:0] res;
    always @(*) begin
        res = res_twos_comp;
    end

    // Output assignment
    always @(*) begin
        c = res;
    end

endmodule
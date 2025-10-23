module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits (precision)
    parameter integer N = 16       // Total number of bits including sign
)(
    input  wire signed [N-1:0] a, // Fixed-point input operand A (two's complement signed)
    input  wire signed [N-1:0] b, // Fixed-point input operand B (two's complement signed)
    output reg  signed [N-1:0] c  // Fixed-point addition result (two's complement signed)
);

    // Internal signals for sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute value function for signed input (returns magnitude as unsigned)
    function automatic [N-1:0] abs_val(input signed [N-1:0] val);
        begin
            abs_val = (val < 0) ? -val : val;
        end
    endfunction

    // Compute magnitudes (absolute values)
    wire [N-1:0] mag_a = abs_val(a);
    wire [N-1:0] mag_b = abs_val(b);

    // Compare magnitudes
    wire mag_a_gt_b = (mag_a > mag_b);
    wire mag_a_eq_b = (mag_a == mag_b);

    // Addition and subtraction of magnitudes (with 1 extra bit to avoid overflow)
    wire [N:0] mag_sum = {1'b0, mag_a} + {1'b0, mag_b};
    wire [N:0] mag_diff_a_b = {1'b0, mag_a} - {1'b0, mag_b};
    wire [N:0] mag_diff_b_a = {1'b0, mag_b} - {1'b0, mag_a};

    // Determine if signs are equal
    wire signs_equal = (sign_a == sign_b);

    // Result variables
    reg [N-1:0] res_mag;      // magnitude of result
    reg         res_sign;     // sign bit of result

    always @(*) begin
        if (signs_equal) begin
            // Same sign: add magnitudes, sign remains same
            // If mag_sum overflows N bits, clip to max magnitude (saturation)
            if (mag_sum[N]) begin
                // Overflow: saturate to max positive or max negative based on sign
                if (sign_a == 0) begin
                    res_mag = {1'b0, {(N-1){1'b1}}}; // max positive magnitude
                end else begin
                    res_mag = {1'b1, {(N-1){1'b0}}}; // max negative magnitude in magnitude form (?)
                end
            end else begin
                res_mag = mag_sum[N-1:0];
            end
            res_sign = sign_a;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a_gt_b) begin
                res_mag = mag_diff_a_b[N-1:0];
                res_sign = sign_a;
            end else if (mag_a_eq_b) begin
                // Result zero, positive zero sign
                res_mag = {N{1'b0}};
                res_sign = 1'b0;
            end else begin
                res_mag = mag_diff_b_a[N-1:0];
                res_sign = sign_b;
            end
        end
    end

    // Convert magnitude and sign back to signed two's complement result
    wire signed [N-1:0] res_twos_comp = res_sign ? -res_mag : res_mag;

    always @(*) begin
        c = res_twos_comp;
    end

endmodule
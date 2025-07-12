module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits (precision)
    parameter integer N = 16       // Total number of bits including sign
)(
    input  wire [N-1:0] a,         // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c          // Fixed-point addition result (two's complement)
);

    // Internal registers to hold sign bits and magnitudes
    reg         sign_a, sign_b;                      // Sign bits of inputs
    reg [N-2:0] mag_a, mag_b;                        // Magnitudes (N-1 bits)
    reg [N-1:0] mag_sum;                             // Sum of magnitudes (N bits wide for addition)
    reg [N-1:0] mag_diff;                            // Difference of magnitudes (N bits wide for subtraction)
    reg         res_sign;                            // Result sign bit
    reg [N-2:0] res_mag;                             // Result magnitude (N-1 bits)
    reg         mag_a_gt_mag_b;                      // Flag: mag_a > mag_b

    // Convert two's complement input to sign and magnitude
    // sign = MSB, magnitude = abs(value)
    // magnitude calculated as: if sign == 1, mag = (~val[N-2:0] + 1)
    //                           else mag = val[N-2:0]
    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        if (sign_a)
            mag_a = (~a[N-2:0]) + 1'b1; // Two's complement magnitude
        else
            mag_a = a[N-2:0];

        if (sign_b)
            mag_b = (~b[N-2:0]) + 1'b1;
        else
            mag_b = b[N-2:0];
    end

    // Compare magnitudes
    always @(*) begin
        mag_a_gt_mag_b = (mag_a > mag_b);
    end

    // Arithmetic operation based on sign bits
    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            mag_sum = {1'b0, mag_a} + {1'b0, mag_b}; // N bits to hold carry
            // Check overflow of magnitude addition - clamp if needed
            // Overflow detection: if mag_sum[N-1] is set, saturate magnitude
            // To keep it simple, truncate higher bit if overflow (wrap-around)
            res_sign = sign_a;
            res_mag = mag_sum[N-1:1]; // Discard LSB or carry out of magnitude
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a_gt_mag_b) begin
                mag_diff = {1'b0, mag_a} - {1'b0, mag_b};
                res_sign = sign_a;       // Sign of larger magnitude
                res_mag = mag_diff[N-2:0];
            end else if (mag_b > mag_a) begin
                mag_diff = {1'b0, mag_b} - {1'b0, mag_a};
                res_sign = sign_b;       // Sign of larger magnitude
                res_mag = mag_diff[N-2:0];
            end else begin
                // Equal magnitude: result is zero
                res_sign = 1'b0;
                res_mag = { (N-1) {1'b0} };
            end
        end
    end

    // Convert result sign and magnitude back to two's complement
    always @(*) begin
        if (res_sign)
            c = {1'b1, (~res_mag) + 1'b1}; // Negative number
        else
            c = {1'b0, res_mag};            // Positive number or zero
    end

endmodule
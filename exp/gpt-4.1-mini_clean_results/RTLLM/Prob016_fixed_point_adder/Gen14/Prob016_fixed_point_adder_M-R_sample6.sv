module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits (precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c           // Fixed-point output result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute magnitudes (absolute values)
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Determine if signs are equal
    wire same_sign = (a_sign == b_sign);

    // Add or subtract magnitudes depending on sign conditions
    wire [N:0] add_mag = {1'b0, a_mag} + {1'b0, b_mag};  // one extra bit for overflow
    wire [N:0] sub_mag_a_b = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N:0] sub_mag_b_a = {1'b0, b_mag} - {1'b0, a_mag};

    // Determine magnitude comparison for different sign case
    wire a_greater = (a_mag >= b_mag);

    // Result magnitude and sign determination
    reg [N-1:0] res;
    reg res_sign;

    always @(*) begin
        if (same_sign) begin
            // Same sign: sum magnitudes, sign same as inputs
            // Truncate add_mag to N bits (lower bits)
            res = add_mag[N-1:0];
            res_sign = a_sign;
        end else begin
            // Different sign: subtract smaller magnitude from larger
            if (a_greater) begin
                res = sub_mag_a_b[N-1:0];
                res_sign = a_sign;  // sign of larger magnitude operand (a here)
            end else begin
                res = sub_mag_b_a[N-1:0];
                res_sign = b_sign;  // sign of larger magnitude operand (b here)
            end
        end

        // If result magnitude is zero, force sign to 0 (positive zero)
        if (res == {N{1'b0}})
            res_sign = 1'b0;
    end

    // Recombine sign and magnitude into two's complement output
    wire [N-1:0] c_temp = res_sign ? (~res + 1'b1) : res;

    assign c = c_temp;

endmodule
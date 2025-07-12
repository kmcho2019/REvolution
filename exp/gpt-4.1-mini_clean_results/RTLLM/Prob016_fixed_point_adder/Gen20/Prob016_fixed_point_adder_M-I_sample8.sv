module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits (precision)
    parameter integer N = 16    // Total bits (including sign bit)
)(
    input  wire [N-1:0] a,      // First fixed-point operand (two's complement)
    input  wire [N-1:0] b,      // Second fixed-point operand (two's complement)
    output reg  [N-1:0] c       // Result fixed-point sum (two's complement)
);

    // Internal register for result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract absolute values (magnitude)
    wire [N-2:0] a_abs = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_abs = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Intermediate variables for addition and subtraction
    reg [N-2:0] mag_sum;
    reg [N-2:0] mag_diff;
    reg sign_res;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            mag_sum = a_abs + b_abs;

            // Check for carry-out beyond (N-1) bits (overflow)
            // For fixed-point add, overflow saturates at max or min value
            // But per problem, we keep result truncated (wrap-around behavior)
            // To saturate, check if mag_sum overflows (higher bits lost)
            // We truncate to (N-1) bits; if overflow, saturate

            // However, the problem states "overflow is managed internally by observing MSB"
            // We'll limit mag_sum to N-1 bits by truncation (wrap-around)

            // If overflow in magnitude addition: saturate output
            // Detect carry out by summing with an extra bit
            wire carry_out;
            assign carry_out = (a_abs + b_abs) > { {(N-1){1'b1}} }; // magnitude max

            // Since in always block, use a temporary for carry
            // Instead, do magnitude addition with one extra bit
            // We'll do it explicitly here

            reg [N-1:0] mag_sum_wide;
            mag_sum_wide = {1'b0, a_abs} + {1'b0, b_abs};

            if (mag_sum_wide[N-1]) begin
                // Overflow: saturate to max or min depending on sign
                if (a_sign == 1'b0)
                    res = {1'b0, {(N-1){1'b1}}};        // Max positive: sign=0, all ones
                else
                    res = {1'b1, {(N-1){1'b0}}};        // Max negative (min value)
            end else begin
                // No overflow
                res = {a_sign, mag_sum_wide[N-2:0]};
            end
        end else begin
            // Different signs: subtract smaller abs from bigger abs
            if (a_abs == b_abs) begin
                // Equal magnitude but different signs: result zero (positive zero)
                res = {1'b0, {(N-1){1'b0}}};
            end else if (a_abs > b_abs) begin
                mag_diff = a_abs - b_abs;
                sign_res = a_sign; // sign of larger magnitude operand
                res = {sign_res, mag_diff};
            end else begin
                mag_diff = b_abs - a_abs;
                sign_res = b_sign; // sign of larger magnitude operand
                res = {sign_res, mag_diff};
            end
        end

        // Assign output
        c = res;
    end

endmodule
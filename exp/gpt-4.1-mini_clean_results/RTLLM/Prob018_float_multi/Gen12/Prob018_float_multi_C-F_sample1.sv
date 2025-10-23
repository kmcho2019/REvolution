module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // IEEE-754 single precision bias
    localparam EXP_BIAS = 127;

    // FSM cycle states
    localparam IDLE      = 3'd0;
    localparam DECODE    = 3'd1;
    localparam MULTIPLY  = 3'd2;
    localparam NORMALIZE = 3'd3;
    localparam ROUND     = 3'd4;
    localparam PACK      = 3'd5;

    reg [2:0] cycle;

    // Inputs decoded and registered
    reg        a_sign, b_sign;
    reg [7:0]  a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special case flags for inputs
    reg a_zero, b_zero;
    reg a_inf,  b_inf;
    reg a_nan,  b_nan;

    // Mantissas with implicit leading bit (24 bits)
    reg [23:0] a_mantissa, b_mantissa;

    // Result sign register
    reg z_sign;

    // Exponent sum with margin for overflow/underflow (signed 10 bits)
    reg signed [9:0] exp_sum;

    // Mantissa product (24x24 = 48 bits)
    reg [47:0] product;

    // Normalized mantissa and exponent after normalization
    reg [23:0] norm_mantissa;
    reg signed [9:0] norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa (25 bits to catch carry)
    reg [24:0] mant_rounded;

    // Final exponent and mantissa after rounding
    reg [7:0] final_exp;
    reg [22:0] final_mantissa;

    // Special flags for final output
    reg special_nan;
    reg special_inf;
    reg special_zero;
    reg special_nan_from_inf_zero;

    // Sticky bit helper (OR reduction)
    wire sticky_helper;

    assign sticky_helper = |product[21:0];

    // Helper functions for special case detection
    function automatic is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction
    function automatic is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction
    function automatic is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Main sequential FSM controlling multi-cycle operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycle <= IDLE;
            z <= 32'd0;

            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf  <= 1'b0; b_inf  <= 1'b0;
            a_nan  <= 1'b0; b_nan  <= 1'b0;

            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            z_sign <= 1'b0;

            exp_sum <= 10'sd0;
            product <= 48'd0;

            norm_mantissa <= 24'd0;
            norm_exp <= 10'sd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            mant_rounded <= 25'd0;

            final_exp <= 8'd0;
            final_mantissa <= 23'd0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;
            special_nan_from_inf_zero <= 1'b0;
        end else begin
            case (cycle)
            IDLE: begin
                // Wait for inputs (can start immediately)
                cycle <= DECODE;
                z <= 32'd0; // output cleared until result ready
            end

            DECODE: begin
                // Extract sign, exponent, fraction
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp <= a[30:23];
                b_exp <= b[30:23];
                a_frac <= a[22:0];
                b_frac <= b[22:0];

                // Detect special cases
                a_zero <= is_zero(a[30:23], a[22:0]);
                b_zero <= is_zero(b[30:23], b[22:0]);
                a_inf <= is_inf(a[30:23], a[22:0]);
                b_inf <= is_inf(b[30:23], b[22:0]);
                a_nan <= is_nan(a[30:23], a[22:0]);
                b_nan <= is_nan(b[30:23], b[22:0]);

                // Prepare mantissas with implicit leading 1 if normalized, else 0 for denormal
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Calculate sign of the result
                z_sign <= a[31] ^ b[31];

                cycle <= MULTIPLY;
            end

            MULTIPLY: begin
                // Multiply mantissas (24b x 24b = 48b)
                product <= a_mantissa * b_mantissa;

                // Add exponents with bias subtraction, extend to signed 10-bit
                exp_sum <= $signed({2'b00, a_exp}) + $signed({2'b00, b_exp}) - EXP_BIAS;

                // Set special case flags for output stage
                special_nan <= a_nan || b_nan;
                special_inf <= (a_inf || b_inf) && !(a_zero || b_zero);
                special_zero <= a_zero || b_zero;
                special_nan_from_inf_zero <= ((a_inf && b_zero) || (b_inf && a_zero));

                cycle <= NORMALIZE;
            end

            NORMALIZE: begin
                // Check top bit of product (bit 47)
                if (product[47]) begin
                    // Leading one at bit 47: shift right by 1, exponent +1
                    norm_mantissa <= product[47:24];
                    norm_exp <= exp_sum + 1;
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_bit <= |product[21:0];
                end else begin
                    // Leading one at bit 46: use bits [46:23], exponent unchanged
                    norm_mantissa <= product[46:23];
                    norm_exp <= exp_sum;
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky_bit <= |product[20:0];
                end
                cycle <= ROUND;
            end

            ROUND: begin
                // Round to nearest even:
                // Round increment if guard_bit=1 and (round_bit=1 or sticky_bit=1 or LSB=1)
                if (guard_bit && (round_bit || sticky_bit || norm_mantissa[0])) begin
                    mant_rounded <= {1'b0, norm_mantissa} + 25'd1;
                end else begin
                    mant_rounded <= {1'b0, norm_mantissa};
                end
                cycle <= PACK;
            end

            PACK: begin
                // Handle mantissa overflow after rounding
                if (mant_rounded[24]) begin
                    // Mantissa overflowed, shift right by 1, increment exponent
                    final_exp <= norm_exp + 1;
                    final_mantissa <= mant_rounded[23:1]; // 23 bits mantissa (remove implicit leading 1)
                end else begin
                    final_exp <= norm_exp[7:0];
                    final_mantissa <= mant_rounded[22:0];
                end

                // Final output assembling with special case handling:
                // Priority: NaN > Inf*0 (NaN) > Inf > Zero > Normal numbers

                if (special_nan) begin
                    // Quiet NaN canonical: sign 0, exp=255, mantissa MSB=1
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_nan_from_inf_zero) begin
                    // Inf*0 => NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf) begin
                    // Infinity with correct sign
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero with correct sign
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal number: check overflow/underflow
                    if (final_exp >= 8'hFF) begin
                        // Overflow => Infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (final_exp == 0 || final_exp[8] == 1'b1) begin
                        // Underflow or exponent <=0 -> flush to zero (no subnormal support)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Assemble normal float
                        z <= {z_sign, final_exp, final_mantissa};
                    end
                end

                cycle <= IDLE;
            end

            default: cycle <= IDLE;
            endcase
        end
    end

endmodule
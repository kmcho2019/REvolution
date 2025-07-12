module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters
    localparam EXP_BIAS = 127;
    localparam IDLE      = 3'd0;
    localparam DECODE    = 3'd1;
    localparam MULTIPLY  = 3'd2;
    localparam NORMALIZE = 3'd3;
    localparam ROUND     = 3'd4;
    localparam PACK      = 3'd5;

    reg [2:0]  cycle;

    // Internal registers for inputs split
    reg        a_sign, b_sign;
    reg [7:0]  a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    reg        a_is_zero, b_is_zero;
    reg        a_is_inf,  b_is_inf;
    reg        a_is_nan,  b_is_nan;

    // Prepared mantissas with implicit bit
    reg [23:0] a_mant, b_mant;

    // Sign of the result
    reg z_sign;

    // Exponent sum (allow some margin)
    reg signed [9:0] exp_sum;

    // Mantissa product
    reg [47:0] product;

    // Normalized mantissa and exponent (after normalization)
    reg [23:0] norm_mant;
    reg signed [9:0] norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa after round to nearest even
    reg [24:0] mant_rounded; // 25 bits for carry

    // Final exponent and mantissa
    reg [7:0] final_exp;
    reg [22:0] final_mant;

    // Special flags for final output
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Sticky calculation temp
    reg sticky_temp;

    // FSM to control multi-cycle operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycle <= IDLE;
            z <= 32'd0;
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_nan <= 0; b_is_nan <= 0;
            a_mant <= 0; b_mant <= 0;
            z_sign <= 0;
            exp_sum <= 0;
            product <= 0;
            norm_mant <= 0;
            norm_exp <= 0;
            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            mant_rounded <= 0;
            final_exp <= 0;
            final_mant <= 0;
            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;
        end else begin
            case (cycle)
            IDLE: begin
                // Wait for inputs, start decoding immediately
                cycle <= DECODE;
            end

            DECODE: begin
                // Extract sign, exponent, fraction
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp <= a[30:23];
                b_exp <= b[30:23];
                a_frac <= a[22:0];
                b_frac <= b[22:0];

                // Detect zero (exp=0, frac=0)
                a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                // Detect infinity (exp=255, frac=0)
                a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                // Detect NaN (exp=255, frac!=0)
                a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                // Prepare mantissas (implicit leading 1 for normalized numbers)
                a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Calculate sign of the result
                z_sign <= a[31] ^ b[31];

                cycle <= MULTIPLY;
            end

            MULTIPLY: begin
                // Multiply mantissas: 24b x 24b = 48b product
                product <= a_mant * b_mant;

                // Add exponents with bias correction
                exp_sum <= $signed({1'b0, a_exp}) + $signed({1'b0, b_exp}) - EXP_BIAS;

                // Carry special case flags for later
                special_nan <= a_is_nan || b_is_nan;
                special_inf <= (a_is_inf || b_is_inf) && !(a_is_zero || b_is_zero);
                special_zero <= a_is_zero || b_is_zero;

                cycle <= NORMALIZE;
            end

            NORMALIZE: begin
                // Normalize product:
                // Check top bit (bit 47) of product for normalization
                if (product[47]) begin
                    // Leading 1 at bit 47, shift product right by 24 to get 24-bit mantissa
                    norm_mant <= product[47:24];
                    norm_exp <= exp_sum + 1; // increment exponent
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_bit <= |product[21:0];
                end else begin
                    // Leading 1 at bit 46 or below, shift right by 23 bits
                    norm_mant <= product[46:23];
                    norm_exp <= exp_sum;
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky_bit <= |product[20:0];
                end
                cycle <= ROUND;
            end

            ROUND: begin
                // Round to nearest even:
                // Round increment if guard=1 and (round=1 or sticky=1 or LSB=1)
                if (guard_bit && (round_bit || sticky_bit || norm_mant[0])) begin
                    mant_rounded <= {1'b0, norm_mant} + 25'd1;
                end else begin
                    mant_rounded <= {1'b0, norm_mant};
                end
                cycle <= PACK;
            end

            PACK: begin
                // Check overflow of mantissa after rounding
                if (mant_rounded[24]) begin
                    // Mantissa overflowed, shift right by 1 and increment exponent
                    final_exp <= norm_exp + 1;
                    final_mant <= mant_rounded[24:2]; // discard LSB after shift
                end else begin
                    final_exp <= norm_exp[7:0]; // truncating extra bits
                    final_mant <= mant_rounded[22:0];
                end

                // Special cases handled with priority:
                // NaN has highest priority
                if (special_nan) begin
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN: exponent=255, mantissa MSB=1
                end else if ((special_inf) && (a_is_zero || b_is_zero)) begin
                    // Inf * 0 -> NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf) begin
                    // Inf * non-zero -> Inf with correct sign
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero * anything -> zero with sign
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal numbers: check overflow and underflow
                    if (final_exp >= 8'hFF) begin
                        // Overflow -> Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (final_exp <= 0) begin
                        // Underflow or denormals flushed to zero here (simplification)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal case: assemble float
                        z <= {z_sign, final_exp, final_mant};
                    end
                end

                cycle <= IDLE; // Ready for next operation
            end

            default: cycle <= IDLE;
            endcase
        end
    end

endmodule
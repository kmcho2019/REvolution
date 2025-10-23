module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;
    reg [2:0] counter;

    // Inputs decoded
    reg         a_sign, b_sign, z_sign;
    reg [8:0]   a_exp, b_exp, z_exp;          // 9 bits for intermediate exponent sums
    reg [23:0]  a_mantissa, b_mantissa;       // Including implicit bit for normals
    reg [47:0]  product;

    // Special cases
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Normalization and rounding
    reg [23:0] norm_mantissa;      // Normalized mantissa before rounding (24 bits)
    reg guard_bit, round_bit, sticky_bit;
    reg round_increment;

    // Extended exponent before bias adjustment
    reg [9:0] exp_sum;

    // Sticky bit temp
    reg sticky_accum;

    // Stage registers for outputs of each step to next step
    reg a_sign_r, b_sign_r;
    reg [8:0] a_exp_r, b_exp_r;
    reg [23:0] a_mantissa_r, b_mantissa_r;
    reg a_zero_r, b_zero_r, a_inf_r, b_inf_r, a_nan_r, b_nan_r;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'd0;
            a_sign_r <= 0; b_sign_r <= 0;
            a_exp_r <= 0; b_exp_r <= 0;
            a_mantissa_r <= 0; b_mantissa_r <= 0;
            a_zero_r <= 0; b_zero_r <= 0;
            a_inf_r <= 0; b_inf_r <= 0;
            a_nan_r <= 0; b_nan_r <= 0;
            product <= 0;
            norm_mantissa <= 0;
            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            round_increment <= 0;
            z_sign <= 0; z_exp <= 0;
        end else begin
            case (counter)
                3'd0: begin
                    // Cycle 0: Extract fields and detect special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= {1'b0, a[30:23]};  // zero extend for calculation (9 bits)
                    b_exp <= {1'b0, b[30:23]};
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Save for next stage
                    a_sign_r <= a_sign;
                    b_sign_r <= b_sign;
                    a_exp_r <= a_exp;
                    b_exp_r <= b_exp;
                    a_mantissa_r <= a_mantissa;
                    b_mantissa_r <= b_mantissa;
                    a_zero_r <= a_zero;
                    b_zero_r <= b_zero;
                    a_inf_r <= a_inf;
                    b_inf_r <= b_inf;
                    a_nan_r <= a_nan;
                    b_nan_r <= b_nan;

                    counter <= 3'd1;
                end
                3'd1: begin
                    // Cycle 1: Check special cases and multiply mantissas if valid
                    z_sign <= a_sign_r ^ b_sign_r;

                    if (a_nan_r || b_nan_r) begin
                        // NaN propagates
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                        counter <= 3'd0;
                    end else if ((a_inf_r && b_zero_r) || (b_inf_r && a_zero_r)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd0;
                    end else if (a_inf_r || b_inf_r) begin
                        // Inf times non-zero or Inf times Inf = Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                        counter <= 3'd0;
                    end else if (a_zero_r || b_zero_r) begin
                        // Zero times anything = zero
                        z <= {z_sign, 31'd0};
                        counter <= 3'd0;
                    end else begin
                        // Normal case multiply
                        product <= a_mantissa_r * b_mantissa_r;  // 24x24 = 48 bits
                        exp_sum <= a_exp_r + b_exp_r - EXP_BIAS; // Sum exponents minus bias
                        counter <= 3'd2;
                    end
                end
                3'd2: begin
                    // Cycle 2: Normalize product and extract rounding bits
                    if (product[47]) begin
                        // Leading 1 at bit 47, shift right 1 and increment exponent
                        norm_mantissa <= product[47:24]; // 24 bits, includes implicit 1
                        z_exp <= exp_sum + 1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        // sticky is OR of bits [21:0]
                        sticky_accum = |product[21:0];
                        sticky_bit <= sticky_accum;
                    end else begin
                        // Leading 1 at bit 46 or less, no shift exponent
                        norm_mantissa <= product[46:23]; // 24 bits mantissa
                        z_exp <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_accum = |product[20:0];
                        sticky_bit <= sticky_accum;
                    end
                    counter <= 3'd3;
                end
                3'd3: begin
                    // Cycle 3: Rounding according to round-to-nearest-even
                    round_increment <= 0;
                    if (guard_bit) begin
                        if (round_bit || sticky_bit || norm_mantissa[0])
                            round_increment <= 1'b1;
                    end

                    counter <= 3'd4;
                end
                3'd4: begin
                    // Cycle 4: Apply rounding and check for overflow/underflow, create output
                    reg [24:0] mantissa_rounded;
                    mantissa_rounded = {1'b0, norm_mantissa} + round_increment;

                    if (mantissa_rounded[24]) begin
                        // Rounding overflow, shift mantissa and increment exponent
                        z_exp <= z_exp + 1;
                        norm_mantissa <= mantissa_rounded[24:1];
                    end else begin
                        norm_mantissa <= mantissa_rounded[23:0];
                    end

                    // Handle overflow, underflow, output final value
                    if (z_exp >= 9'd255) begin
                        // Overflow to Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (z_exp <= 0) begin
                        // Underflow to zero (no subnormal support)
                        z <= {z_sign, 31'd0};
                    end else begin
                        z <= {z_sign, z_exp[7:0], norm_mantissa[22:0]};
                    end

                    counter <= 3'd0; // Ready for next input
                end
                default: begin
                    counter <= 3'd0;
                    z <= 32'd0;
                end
            endcase
        end
    end
endmodule
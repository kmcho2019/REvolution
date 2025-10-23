module float_multi(
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Extracted inputs
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special case flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf,  b_is_inf;
    reg a_is_nan,  b_is_nan;

    // Mantissas with implicit leading 1 for normals, 0 for denormals
    reg [23:0] a_mant, b_mant;

    // Intermediate signals
    reg sign;
    reg [9:0] exp_sum;      // wider to hold addition and bias subtraction
    reg [47:0] product;     // 24x24=48 bits

    // Normalized mantissa and exponent
    reg [23:0] mant_norm;
    reg [9:0] exp_norm;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounding increment and mantissa after rounding
    reg round_inc;
    reg [24:0] mant_rounded;

    // Final exponent and mantissa for output
    reg [7:0] exp_out;
    reg [22:0] mant_out;
    reg sign_out;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'd0;

            // Clear all registers
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
            a_is_inf <= 0;  b_is_inf <= 0;
            a_is_nan <= 0;  b_is_nan <= 0;
            a_mant <= 0; b_mant <= 0;
            sign <= 0;
            exp_sum <= 0;
            product <= 0;
            mant_norm <= 0;
            exp_norm <= 0;
            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            round_inc <= 0;
            mant_rounded <= 0;
            exp_out <= 0;
            mant_out <= 0;
            sign_out <= 0;
        end else begin
            counter <= counter + 3'd1;

            case(counter)
                3'd1: begin
                    // Extract fields and detect special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);

                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

                    // Prepare mantissas
                    a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    sign <= a[31] ^ b[31];
                end
                3'd2: begin
                    // Multiply mantissas and add exponents
                    product <= a_mant * b_mant; // 24x24=48 bits
                    exp_sum <= a_exp + b_exp - EXP_BIAS;
                end
                3'd3: begin
                    // Normalize product
                    if (product[47]) begin
                        // MSB set: shift right by 1 and increment exponent
                        mant_norm <= product[47:24];
                        exp_norm <= exp_sum + 10'd1;

                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB not set: take bits as is
                        mant_norm <= product[46:23];
                        exp_norm <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end
                3'd4: begin
                    // Round to nearest even
                    round_inc <= guard_bit && (round_bit || sticky_bit || mant_norm[0]);

                    mant_rounded <= {1'b0, mant_norm} + (round_inc ? 25'd1 : 25'd0);

                    // Handle mantissa overflow after rounding
                    if (mant_rounded[24]) begin
                        exp_out <= exp_norm[7:0] + 8'd1;
                        mant_out <= mant_rounded[24:2]; // shift right 1 to fit 23 bits
                    end else begin
                        exp_out <= exp_norm[7:0];
                        mant_out <= mant_rounded[22:0];
                    end

                    sign_out <= sign;

                    // Handle special cases and generate output
                    if (a_is_nan || b_is_nan) begin
                        // Quiet NaN: sign=0, exponent all 1s, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * non-zero or Inf * Inf = Inf
                        z <= {sign_out, 8'hFF, 23'd0};
                    end else if (a_is_zero || b_is_zero) begin
                        // Zero * anything = zero
                        z <= {sign_out, 31'd0};
                    end else begin
                        // Normal output with overflow and underflow check
                        if (exp_out >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {sign_out, 8'hFF, 23'd0};
                        end else if (exp_out <= 0) begin
                            // Underflow to zero (flush)
                            z <= {sign_out, 31'd0};
                        end else begin
                            z <= {sign_out, exp_out, mant_out};
                        end
                    end
                end
                default: begin
                    // Hold state or wait
                    z <= z;
                end
            endcase
        end
    end
endmodule
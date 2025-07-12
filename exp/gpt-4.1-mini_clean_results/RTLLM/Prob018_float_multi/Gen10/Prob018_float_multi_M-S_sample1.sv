module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    reg [2:0]   counter;

    // Inputs decomposition
    reg         a_sign, b_sign, z_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    // Flags for special cases
    reg         a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Mantissas with implicit leading bit
    reg [23:0]  a_mantissa, b_mantissa;
    reg [47:0]  product;

    // Exponent sum extended for overflow check
    reg [9:0]   exp_sum;

    // Normalized mantissa and exponent
    reg [23:0]  mant_norm;
    reg [9:0]   exp_norm;

    // Rounding bits
    reg         guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [24:0]  mant_rounded;
    reg [9:0]   exp_rounded;

    // Round increment
    wire round_inc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter     <= 3'd0;
            z           <= 32'd0;
            a_sign      <= 1'b0; b_sign <= 1'b0;
            a_exp       <= 8'd0; b_exp <= 8'd0;
            a_frac      <= 23'd0; b_frac <= 23'd0;
            a_zero      <= 1'b0; b_zero <= 1'b0;
            a_inf       <= 1'b0; b_inf <= 1'b0;
            a_nan       <= 1'b0; b_nan <= 1'b0;
            a_mantissa  <= 24'd0; b_mantissa <= 24'd0;
            product     <= 48'd0;
            exp_sum     <= 10'd0;
            mant_norm   <= 24'd0;
            exp_norm    <= 10'd0;
            guard_bit   <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            mant_rounded <= 25'd0;
            exp_rounded <= 10'd0;
            z_sign      <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract input fields
                    a_sign  <= a[31]; b_sign <= b[31];
                    a_exp   <= a[30:23]; b_exp <= b[30:23];
                    a_frac  <= a[22:0]; b_frac <= b[22:0];

                    // Special cases
                    a_zero  <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero  <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    a_inf   <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf   <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    a_nan   <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan   <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas with implicit leading 1 for normalized numbers
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Compute sign of product
                    z_sign <= a[31] ^ b[31];

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Multiply mantissas (24x24=48 bits)
                    product <= a_mantissa * b_mantissa;

                    // Add exponents and subtract bias
                    exp_sum <= a_exp + b_exp - EXP_BIAS;

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Normalize product
                    if (product[47]) begin
                        // Leading one at bit 47
                        mant_norm <= product[47:24];
                        exp_norm <= exp_sum + 1;

                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // Leading one at bit 46 or less
                        mant_norm <= product[46:23];
                        exp_norm <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Round to nearest even
                    // Increment if guard bit = 1 and (round bit or sticky bit or LSB=1)
                    if (guard_bit && (round_bit || sticky_bit || mant_norm[0]))
                        mant_rounded <= {1'b0, mant_norm} + 1'b1;
                    else
                        mant_rounded <= {1'b0, mant_norm};

                    exp_rounded <= exp_norm;

                    // Handle mantissa overflow after rounding
                    if (mant_rounded[24]) begin
                        exp_rounded <= exp_norm + 1;
                        mant_norm <= mant_rounded[24:2]; // Shift right 1 to normalize again
                    end else begin
                        mant_norm <= mant_rounded[23:1]; // Take top 23 bits
                    end

                    // Output sign stable
                    z_sign <= z_sign;

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Final output assembly with special cases handling

                    // NaN if any input is NaN or invalid inf*0
                    if (a_nan || b_nan || ((a_inf && b_zero) || (b_inf && a_zero))) begin
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                    end else if (a_inf || b_inf) begin
                        // Infinity * non-zero => infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero * anything => zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal result
                        if (exp_rounded >= 8'hFF) begin
                            // Overflow -> Infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (exp_rounded <= 0) begin
                            // Underflow -> zero
                            z <= {z_sign, 31'd0};
                        end else begin
                            z <= {z_sign, exp_rounded[7:0], mant_norm[22:0]};
                        end
                    end

                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule
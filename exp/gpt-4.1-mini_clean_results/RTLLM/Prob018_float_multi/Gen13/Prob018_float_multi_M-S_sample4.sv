module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;
    localparam EXP_MIN = 8'h00;

    // Internal registers for operands and intermediate results
    reg [2:0] counter;

    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    reg [23:0] a_mantissa, b_mantissa; // mantissa with implicit bit
    reg [9:0] a_exp_ext, b_exp_ext;    // extended exponent for calculations

    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    reg res_sign;
    reg [9:0] exp_sum;       // exponent sum extended width
    reg [47:0] product;      // product of mantissas

    reg product_msb;
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // After rounding
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;

    reg exponent_overflow, exponent_underflow;
    reg [7:0] final_exponent;

    reg [31:0] res;  // Final result before register

    always @(posedge clk) begin
        if (rst) begin
            // Reset all registers
            counter <= 3'd0;
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            a_exp_ext <= 10'd0; b_exp_ext <= 10'd0;
            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;
            res_sign <= 1'b0;
            exp_sum <= 10'd0;
            product <= 48'd0;
            product_msb <= 1'b0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            rounded_mantissa_pre <= 25'd0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 10'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            final_exponent <= 8'd0;
            res <= 32'd0;
            z <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Initialize and extract input fields
                    a_sign <= a[31];
                    a_exp <= a[30:23];
                    a_frac <= a[22:0];
                    b_sign <= b[31];
                    b_exp <= b[30:23];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_zero <= (a[30:0] == 31'd0);
                    b_zero <= (b[30:0] == 31'd0);
                    a_inf <= (a_exp == 8'hFF) && (a_frac == 23'd0);
                    b_inf <= (b_exp == 8'hFF) && (b_frac == 23'd0);
                    a_nan <= (a_exp == 8'hFF) && (a_frac != 23'd0);
                    b_nan <= (b_exp == 8'hFF) && (b_frac != 23'd0);

                    // Compute result sign
                    res_sign <= a[31] ^ b[31];

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Prepare mantissas (add implicit leading 1 for normal numbers, 0 for denormals and zero)
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Extended exponent for calculation (treat denormals as exponent 1)
                    a_exp_ext <= (a_exp == 8'd0) ? 10'd1 : {2'd0, a_exp};
                    b_exp_ext <= (b_exp == 8'd0) ? 10'd1 : {2'd0, b_exp};

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Multiply mantissas (24x24)
                    product <= a_mantissa * b_mantissa;

                    // Sum exponents and subtract bias
                    exp_sum <= a_exp_ext + b_exp_ext - EXP_BIAS;

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Normalize product
                    product_msb <= product[47];
                    if (product[47]) begin
                        norm_mantissa <= product[47:24];
                        norm_exponent <= exp_sum + 10'd1;
                    end else begin
                        norm_mantissa <= product[46:23] << 1; // shift left by 1, keep 24 bits
                        norm_exponent <= exp_sum;
                    end

                    // Extract rounding bits
                    guard_bit <= product_msb ? product[23] : product[22];
                    round_bit <= product_msb ? product[22] : product[21];
                    sticky_bit <= product_msb ? (|product[21:0]) : (|product[20:0]);

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Rounding to nearest even
                    rounded_mantissa_pre <= {1'b0, norm_mantissa} +
                        ((guard_bit && (round_bit | sticky_bit | norm_mantissa[0])) ? 25'd1 : 25'd0);

                    mantissa_carry <= rounded_mantissa_pre[24];

                    // Adjust exponent if carry out
                    final_exponent_pre <= mantissa_carry ? norm_exponent + 10'd1 : norm_exponent;
                    final_mantissa <= mantissa_carry ? rounded_mantissa_pre[24:2] : rounded_mantissa_pre[22:0];

                    // Check for overflow/underflow
                    exponent_overflow <= (final_exponent_pre >= 10'd255);
                    exponent_underflow <= (final_exponent_pre <= 10'd0);

                    final_exponent <= (final_exponent_pre >= 10'd255) ? 8'hFF :
                                      (final_exponent_pre <= 10'd0) ? 8'd0 :
                                      final_exponent_pre[7:0];

                    counter <= 3'd5;
                end

                3'd5: begin
                    // Assemble final result with special case handling

                    if (a_nan || b_nan) begin
                        // quiet NaN
                        res <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        res <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Inf * non-zero = Inf with correct sign
                        res <= {res_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // zero * anything = zero with sign
                        res <= {res_sign, 31'd0};
                    end else begin
                        if (exponent_overflow) begin
                            // overflow => Inf
                            res <= {res_sign, 8'hFF, 23'd0};
                        end else if (exponent_underflow) begin
                            // underflow => zero (flush to zero)
                            res <= {res_sign, 31'd0};
                        end else begin
                            // Normal result
                            res <= {res_sign, final_exponent, final_mantissa};
                        end
                    end

                    counter <= 3'd0; // restart cycle
                end
            endcase

            // Register output result
            if (counter == 3'd0) begin
                z <= res;
            end
        end
    end

endmodule
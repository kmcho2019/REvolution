module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;

    // Internal registers
    reg [2:0] counter;

    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    reg a_zero, a_denorm, a_inf, a_nan;
    reg b_zero, b_denorm, b_inf, b_nan;

    // Extended exponents for calculations
    reg [9:0] a_exp_ext, b_exp_ext;
    reg [9:0] exp_sum;

    // Mantissas with implicit leading bit
    reg [23:0] a_mantissa, b_mantissa;

    // Product mantissa and normalization
    reg [47:0] product;

    reg product_msb;

    // Normalized mantissa and exponent after possible shift
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent after rounding
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;

    // Final exponent overflow/underflow
    reg exponent_overflow;
    reg exponent_underflow;
    reg [7:0] final_exponent;

    // Result sign
    reg res_sign;

    // Output register next value
    reg [31:0] res;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract fields
                    a_sign <= a[31];
                    a_exp <= a[30:23];
                    a_frac <= a[22:0];
                    b_sign <= b[31];
                    b_exp <= b[30:23];
                    b_frac <= b[22:0];

                    // Detect special cases for a
                    a_zero <= (a_exp == 8'd0) && (a_frac == 23'd0);
                    a_denorm <= (a_exp == 8'd0) && (a_frac != 23'd0);
                    a_inf <= (a_exp == 8'hFF) && (a_frac == 23'd0);
                    a_nan <= (a_exp == 8'hFF) && (a_frac != 23'd0);

                    // Detect special cases for b
                    b_zero <= (b_exp == 8'd0) && (b_frac == 23'd0);
                    b_denorm <= (b_exp == 8'd0) && (b_frac != 23'd0);
                    b_inf <= (b_exp == 8'hFF) && (b_frac == 23'd0);
                    b_nan <= (b_exp == 8'hFF) && (b_frac != 23'd0);

                    res_sign <= a[31] ^ b[31];

                    // Prepare mantissas with implicit leading 1 for normal numbers, 0 for denormals and zero
                    a_mantissa <= (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Extended exponent for calculation: denormals treated as exponent 1
                    a_exp_ext <= (a_exp == 0) ? 10'd1 : {2'd0, a_exp};
                    b_exp_ext <= (b_exp == 0) ? 10'd1 : {2'd0, b_exp};

                    counter <= 3'd1;
                end
                3'd1: begin
                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa;

                    // Add exponents and subtract bias
                    exp_sum <= a_exp_ext + b_exp_ext - EXP_BIAS;

                    counter <= 3'd2;
                end
                3'd2: begin
                    // Normalization
                    product_msb <= product[47];

                    if (product[47]) begin
                        // MSB=1, product >=2.0, shift right 1, increment exponent
                        norm_mantissa <= product[47:24];
                        norm_exponent <= exp_sum + 10'd1;

                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB=0, shift left 1 to normalize
                        norm_mantissa <= product[46:23];
                        norm_exponent <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= 3'd3;
                end
                3'd3: begin
                    // Rounding to nearest even
                    rounded_mantissa_pre <= {1'b0, norm_mantissa} + 
                        ((guard_bit && (round_bit | sticky_bit | norm_mantissa[0])) ? 25'd1 : 25'd0);

                    mantissa_carry <= (rounded_mantissa_pre[24] == 1'b1);

                    final_mantissa <= mantissa_carry ? rounded_mantissa_pre[24:2] : rounded_mantissa_pre[22:0];
                    final_exponent_pre <= mantissa_carry ? norm_exponent + 10'd1 : norm_exponent;

                    // Overflow/underflow detection
                    exponent_overflow <= (final_exponent_pre >= 10'd255);
                    exponent_underflow <= (final_exponent_pre <= 10'd0);

                    final_exponent <= exponent_overflow ? 8'hFF : 
                                      (exponent_underflow ? 8'd0 : final_exponent_pre[7:0]);

                    // Special cases priority handled here
                    if (a_nan || b_nan) begin
                        res <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        res <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN for inf*0
                    end else if (a_inf || b_inf) begin
                        res <= {res_sign, 8'hFF, 23'd0}; // Inf with sign
                    end else if (a_zero || b_zero) begin
                        res <= {res_sign, 31'd0}; // zero with sign
                    end else if (exponent_overflow) begin
                        res <= {res_sign, 8'hFF, 23'd0}; // overflow to Inf
                    end else if (exponent_underflow) begin
                        res <= {res_sign, 31'd0}; // underflow to zero
                    end else begin
                        res <= {res_sign, final_exponent, final_mantissa};
                    end

                    z <= res;

                    // Cycle back
                    counter <= 3'd0;
                end
                default: counter <= 3'd0;
            endcase
        end
    end

endmodule
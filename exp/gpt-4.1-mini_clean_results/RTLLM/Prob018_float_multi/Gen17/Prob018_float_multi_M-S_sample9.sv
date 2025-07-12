module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // IEEE 754 single precision parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;
    localparam EXP_MIN = 8'h00;

    // Internal cycle counter (3 bits)
    reg [2:0] counter;

    // Internal registers for operand fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Internal mantissas with implicit leading bit
    reg [23:0] a_mantissa, b_mantissa;
    reg [9:0] a_exp_adj, b_exp_adj;

    // Internal registers for product and exponent/sign
    reg [47:0] product;
    reg [9:0] exp_sum;
    reg res_sign;

    // Normalization and rounding registers
    reg product_msb;
    reg [47:0] shifted_product;
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;

    reg round_increment;
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;
    reg exponent_overflow, exponent_underflow;
    reg [7:0] final_exponent;

    // Special case flags
    reg a_zero, a_denormal, a_inf, a_nan;
    reg b_zero, b_denormal, b_inf, b_nan;
    reg special_nan;
    reg special_inf_zero;

    // Intermediate result register
    reg [31:0] res;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear internal regs on reset
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            a_exp_adj <= 10'd0; b_exp_adj <= 10'd0;
            product <= 48'd0;
            exp_sum <= 10'd0;
            res_sign <= 1'b0;
            product_msb <= 1'b0;
            shifted_product <= 48'd0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            round_increment <= 1'b0;
            rounded_mantissa_pre <= 25'd0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 10'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            final_exponent <= 8'd0;
            a_zero <= 1'b0; a_denormal <= 1'b0; a_inf <= 1'b0; a_nan <= 1'b0;
            b_zero <= 1'b0; b_denormal <= 1'b0; b_inf <= 1'b0; b_nan <= 1'b0;
            special_nan <= 1'b0;
            special_inf_zero <= 1'b0;
            res <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Wait cycle or idle
                    z <= z; // Hold previous output
                    counter <= 3'd1;
                end
                3'd1: begin
                    // Extract inputs
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases for a
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    a_denormal <= (a[30:23] == 8'd0) && (a[22:0] != 23'd0);
                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

                    // Detect special cases for b
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    b_denormal <= (b[30:23] == 8'd0) && (b[22:0] != 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Adjust exponent for calculation
                    a_exp_adj <= (a[30:23] == 8'd0) ? 10'd1 : {2'd0, a[30:23]};
                    b_exp_adj <= (b[30:23] == 8'd0) ? 10'd1 : {2'd0, b[30:23]};

                    // Compute result sign
                    res_sign <= a[31] ^ b[31];

                    counter <= 3'd2;
                end
                3'd2: begin
                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa;

                    // Add exponents and subtract bias
                    exp_sum <= a_exp_adj + b_exp_adj - EXP_BIAS;

                    counter <= 3'd3;
                end
                3'd3: begin
                    // Normalization
                    product_msb <= product[47];
                    if (product[47]) begin
                        shifted_product <= product;
                        norm_exponent <= exp_sum + 10'd1;
                    end else begin
                        shifted_product <= product << 1;
                        norm_exponent <= exp_sum;
                    end

                    norm_mantissa <= product[47] ? product[47:24] : (product << 1)[47:24];

                    // Extract rounding bits
                    guard_bit <= shifted_product[23];
                    round_bit <= shifted_product[22];
                    sticky_bit <= |shifted_product[21:0];

                    counter <= 3'd4;
                end
                3'd4: begin
                    // Rounding
                    round_increment <= guard_bit && (round_bit | sticky_bit | norm_mantissa[0]);
                    rounded_mantissa_pre <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

                    // Check carry out after rounding
                    mantissa_carry <= rounded_mantissa_pre[24];

                    // Adjust mantissa and exponent accordingly
                    if (rounded_mantissa_pre[24]) begin
                        final_mantissa <= rounded_mantissa_pre[24:2];
                        final_exponent_pre <= norm_exponent + 10'd1;
                    end else begin
                        final_mantissa <= rounded_mantissa_pre[22:0];
                        final_exponent_pre <= norm_exponent;
                    end

                    counter <= 3'd5;
                end
                3'd5: begin
                    // Check overflow and underflow
                    exponent_overflow <= (final_exponent_pre >= 10'd255);
                    exponent_underflow <= (final_exponent_pre <= 10'd0);

                    // Clamp exponent for output
                    if (exponent_overflow)
                        final_exponent <= 8'hFF;
                    else if (exponent_underflow)
                        final_exponent <= 8'd0;
                    else
                        final_exponent <= final_exponent_pre[7:0];

                    // Handle special cases:
                    special_nan <= a_nan || b_nan;
                    special_inf_zero <= (a_inf && b_zero) || (b_inf && a_zero);

                    counter <= 3'd6;
                end
                3'd6: begin
                    // Assemble output result
                    if (special_nan) begin
                        // Quiet NaN with MSB of mantissa set
                        res <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf_zero) begin
                        // Inf * 0 = NaN
                        res <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Inf * nonzero = Inf
                        res <= {res_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero * anything = zero
                        res <= {res_sign, 31'd0};
                    end else begin
                        // Normal/denormal result
                        if (exponent_overflow) begin
                            // Overflow => Inf
                            res <= {res_sign, 8'hFF, 23'd0};
                        end else if (exponent_underflow) begin
                            // Underflow => zero (flush to zero)
                            res <= {res_sign, 31'd0};
                        end else begin
                            // Normal result
                            res <= {res_sign, final_exponent, final_mantissa};
                        end
                    end
                    counter <= 3'd7;
                end
                3'd7: begin
                    // Output registered
                    z <= res;
                    // Optionally restart operation cycle
                    counter <= 3'd1;
                end
                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule
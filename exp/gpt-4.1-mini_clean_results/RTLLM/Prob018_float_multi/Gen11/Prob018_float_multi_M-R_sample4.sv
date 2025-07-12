module float_multi (
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

    // Cycle counter as FSM state: 0..3
    reg [2:0] counter;

    // Registers for extracted fields and intermediate data
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mantissa, b_mantissa; // 1 hidden bit + 23 fraction bits
    reg [9:0] a_exponent, b_exponent;   // extended 10-bit for arithmetic
    reg [49:0] product;                  // 24x24 multiplication product (up to 48 bits, use 50 bits to align later)
    reg product_msb;                    // MSB of product
    reg [9:0] exp_sum;
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;

    // Special cases flags
    reg a_zero, a_denormal, a_inf, a_nan;
    reg b_zero, b_denormal, b_inf, b_nan;

    // Rounding intermediate signals
    reg round_increment;
    reg [24:0] rounded_mantissa_pre; // one extra bit for carry
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;
    reg exponent_overflow, exponent_underflow;
    reg [7:0] final_exponent;

    // Temporary registers for special cases result
    reg [31:0] res_special;
    reg is_special_case;

    // Sequential FSM to perform each step per clock cycle
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear all intermediate regs
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            a_exponent <= 10'd0; b_exponent <= 10'd0;
            product <= 50'd0;
            product_msb <= 1'b0;
            exp_sum <= 10'd0;
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
            res_special <= 32'd0;
            is_special_case <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Cycle 0: Extract fields and detect special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];

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

                    // Prepare mantissas with implicit leading 1 for normal, 0 for denormals and zero
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Adjust exponents: treat denormals as exponent=1 for calculation
                    a_exponent <= (a_exp == 8'd0) ? 10'd1 : {2'd0, a_exp};
                    b_exponent <= (b_exp == 8'd0) ? 10'd1 : {2'd0, b_exp};

                    // Set product MSB and exp_sum default to zero
                    product_msb <= 1'b0;
                    exp_sum <= 10'd0;

                    // Clear special case flag for now
                    is_special_case <= 1'b0;

                    counter <= counter + 1'b1;
                end
                3'd1: begin
                    // Cycle 1: Multiply mantissas and compute exponent sum
                    product <= a_mantissa * b_mantissa; // 24x24 = 48 bits stored in lower 48 bits
                    exp_sum <= a_exponent + b_exponent - EXP_BIAS;
                    z_sign <= a_sign ^ b_sign;

                    counter <= counter + 1'b1;
                end
                3'd2: begin
                    // Cycle 2: Normalize product and prepare for rounding
                    product_msb <= product[47]; // MSB of product, bit 47 (48 bits product)
                    if (product[47]) begin
                        // If MSB=1, product >= 2.0, shift right 1 and increment exponent
                        norm_mantissa <= product[47:24]; // top 24 bits after shift 0
                        norm_exponent <= exp_sum + 10'd1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB=0, shift left 1 (multiply by 2) for normalization and keep exponent as is
                        // However, product is 48 bits, shifting left by 1 moves bits [46:23] to [47:24]
                        norm_mantissa <= {product[46:24], 1'b0}; // Shifted left 1 bit; we take bits 47:24 for mantissa
                        norm_exponent <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= counter + 1'b1;
                end
                3'd3: begin
                    // Cycle 3: Perform rounding, check overflow/underflow, assemble final result

                    // Round to nearest even
                    round_increment <= guard_bit && (round_bit || sticky_bit || norm_mantissa[0]);
                    rounded_mantissa_pre <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

                    mantissa_carry <= rounded_mantissa_pre[24];
                    final_mantissa <= mantissa_carry ? rounded_mantissa_pre[24:2] : rounded_mantissa_pre[22:0];
                    final_exponent_pre <= mantissa_carry ? norm_exponent + 10'd1 : norm_exponent;

                    exponent_overflow <= (final_exponent_pre >= 10'd255);
                    exponent_underflow <= (final_exponent_pre <= 10'd0);
                    final_exponent <= exponent_overflow ? 8'hFF :
                                     (exponent_underflow ? 8'd0 : final_exponent_pre[7:0]);

                    // Handle special cases with priority
                    // Default no special case
                    is_special_case <= 1'b0;
                    if (a_nan || b_nan) begin
                        // NaN
                        res_special <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        is_special_case <= 1'b1;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        res_special <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        is_special_case <= 1'b1;
                    end else if (a_inf || b_inf) begin
                        // Inf * non-zero = Inf with sign
                        res_special <= {z_sign, 8'hFF, 23'd0};
                        is_special_case <= 1'b1;
                    end else if (a_zero || b_zero) begin
                        // Zero * anything = zero with sign
                        res_special <= {z_sign, 31'd0};
                        is_special_case <= 1'b1;
                    end else if (exponent_overflow) begin
                        // Overflow => Inf
                        res_special <= {z_sign, 8'hFF, 23'd0};
                        is_special_case <= 1'b1;
                    end else if (exponent_underflow) begin
                        // Underflow => zero (flush to zero)
                        res_special <= {z_sign, 31'd0};
                        is_special_case <= 1'b1;
                    end

                    // Output result
                    if (is_special_case) begin
                        z <= res_special;
                    end else begin
                        z <= {z_sign, final_exponent, final_mantissa};
                    end

                    // After finishing operation, return to cycle 0 for next inputs
                    counter <= 3'd0;
                end
                default: begin
                    // Should not happen; reset counter
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule
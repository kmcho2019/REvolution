module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // IEEE 754 parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;

    // Internal registers
    reg [2:0] counter;

    // Stage 0 signals
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [22:0] a_fraction, b_fraction;

    reg a_zero, a_denormal, a_inf, a_nan;
    reg b_zero, b_denormal, b_inf, b_nan;

    reg [23:0] a_mantissa, b_mantissa;
    reg [9:0] a_exponent_adj, b_exponent_adj;

    reg res_sign;

    // Stage 1 signals
    reg [47:0] product;         // 24x24 mantissa product
    reg [9:0] exp_sum;

    // Normalization signals
    reg product_msb;
    reg [47:0] shifted_product;

    // Stage 2 signals
    reg guard_bit, round_bit, sticky;
    reg round_increment;
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;

    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;
    reg exponent_overflow;
    reg exponent_underflow;
    reg [7:0] final_exponent;

    reg [31:0] result;

    // Counter for multi-cycle operation
    always @(posedge clk) begin
        if (rst)
            counter <= 3'd0;
        else
            counter <= (counter == 3'd3) ? 3'd0 : counter + 3'd1;
    end

    // Stage 0: Extract fields, detect special cases, prepare mantissas, sign, adjusted exponents
    always @(posedge clk) begin
        if (rst) begin
            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_fraction <= 0;
            b_fraction <= 0;

            a_zero <= 0;
            a_denormal <= 0;
            a_inf <= 0;
            a_nan <= 0;

            b_zero <= 0;
            b_denormal <= 0;
            b_inf <= 0;
            b_nan <= 0;

            a_mantissa <= 0;
            b_mantissa <= 0;
            a_exponent_adj <= 0;
            b_exponent_adj <= 0;
            res_sign <= 0;
        end else if (counter == 3'd0) begin
            // Extract sign, exponent, fraction
            a_sign <= a[31];
            b_sign <= b[31];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_fraction <= a[22:0];
            b_fraction <= b[22:0];

            // Detect special cases for a
            a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
            a_denormal <= (a[30:23] == 8'd0) && (a[22:0] != 0);
            a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
            a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);

            // Detect special cases for b
            b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);
            b_denormal <= (b[30:23] == 8'd0) && (b[22:0] != 0);
            b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
            b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

            // Prepare mantissas with implicit leading 1 for normal numbers
            a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            // Adjust exponent for denormals, exponent=1 for denormals, else actual exponent
            a_exponent_adj <= (a[30:23] == 8'd0) ? 10'd1 : {2'd0, a[30:23]};
            b_exponent_adj <= (b[30:23] == 8'd0) ? 10'd1 : {2'd0, b[30:23]};

            // Compute output sign
            res_sign <= a[31] ^ b[31];
        end
    end

    // Stage 1: Multiply mantissas, add exponents, normalization shift decision
    always @(posedge clk) begin
        if (rst) begin
            product <= 0;
            exp_sum <= 0;
            product_msb <= 0;
            shifted_product <= 0;
        end else if (counter == 3'd1) begin
            product <= a_mantissa * b_mantissa;          // 24x24 => 48 bits
            exp_sum <= a_exponent_adj + b_exponent_adj - EXP_BIAS;

            product_msb <= (a_mantissa * b_mantissa)[47];

            // Wait to compute shifted_product after product_msb is valid
            // We'll calculate shifted_product on next clk in stage 2 to use registered product_msb
            // But since product_msb is from product calculation in same cycle, we can also compute here

            if ( (a_mantissa * b_mantissa)[47] )
                shifted_product <= a_mantissa * b_mantissa;
            else
                shifted_product <= (a_mantissa * b_mantissa) << 1;
        end
    end

    // Stage 2: Rounding, exponent adjustment, special case & overflow/underflow handling, generate output
    always @(posedge clk) begin
        if (rst) begin
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
            round_increment <= 0;
            rounded_mantissa_pre <= 0;
            mantissa_carry <= 0;
            final_mantissa <= 0;
            final_exponent_pre <= 0;
            exponent_overflow <= 0;
            exponent_underflow <= 0;
            final_exponent <= 0;
            result <= 0;
            z <= 0;
        end else if (counter == 3'd2) begin
            // Extract rounding bits from shifted product
            guard_bit <= shifted_product[23];
            round_bit <= shifted_product[22];
            sticky <= |shifted_product[21:0];

            round_increment <= guard_bit && (round_bit | sticky | shifted_product[24]);

            // Extract normalized mantissa (top 24 bits: bit 47 down to 24)
            // shifted_product is either product or product<<1
            // Use [47:24] bits as normalized mantissa
            rounded_mantissa_pre <= {1'b0, shifted_product[47:24]} + (round_increment ? 25'd1 : 25'd0);

            mantissa_carry <= (rounded_mantissa_pre[24] == 1'b1);

            if (mantissa_carry) begin
                // shift right by 1 (drop LSB), exponent +1
                final_mantissa <= rounded_mantissa_pre[24:2];
                final_exponent_pre <= exp_sum + 10'd1;
            end else begin
                final_mantissa <= rounded_mantissa_pre[22:0];
                final_exponent_pre <= exp_sum;
            end

            // Check overflow and underflow after rounding
            exponent_overflow <= (mantissa_carry) ? (exp_sum + 10'd1 >= 10'd255) : (exp_sum >= 10'd255);
            exponent_underflow <= (mantissa_carry) ? (exp_sum + 10'd1 <= 0) : (exp_sum <= 0);

            // Clamp exponent for output
            final_exponent <= exponent_overflow ? 8'hFF :
                              exponent_underflow ? 8'd0 :
                              final_exponent_pre[7:0];

            // Special case handling priority:
            // 1) NaN if either input is NaN
            // 2) NaN if inf*0 or 0*inf
            // 3) Inf * nonzero = Inf with sign
            // 4) zero * anything = zero with sign
            // 5) normal result

            if (a_nan || b_nan) begin
                // Quiet NaN, sign=0, exp=0xFF, mantissa MSB=1
                result <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                // Inf*0 = NaN
                result <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_inf || b_inf) begin
                // Inf * non-zero = Inf with correct sign
                result <= {res_sign, 8'hFF, 23'd0};
            end else if (a_zero || b_zero) begin
                // zero * anything = zero with sign
                result <= {res_sign, 31'd0};
            end else begin
                // Normal case: check overflow/underflow
                if (exponent_overflow) begin
                    result <= {res_sign, 8'hFF, 23'd0}; // Inf
                end else if (exponent_underflow) begin
                    result <= {res_sign, 31'd0};        // Zero (flush)
                end else begin
                    result <= {res_sign, final_exponent, final_mantissa};
                end
            end

            z <= result; // Register output at stage 2
        end
    end

endmodule
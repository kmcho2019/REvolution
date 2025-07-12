module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Parameters
    localparam EXP_BIAS = 127;
    localparam EXP_BITS = 8;
    localparam MANT_BITS = 23;

    // Internal registers
    reg [2:0] counter;

    reg        a_sign, b_sign, z_sign;
    reg [9:0]  a_exp, b_exp, z_exp;          // wider for intermediate calculations
    reg [23:0] a_mantissa, b_mantissa;       // mantissas with implicit leading 1 for normal
    reg [49:0] product;

    reg guard_bit, round_bit, sticky_bit;

    // Special case flags
    reg a_exp_all_ones, b_exp_all_ones;
    reg a_exp_zero, b_exp_zero;
    reg a_frac_zero, b_frac_zero;
    reg a_is_nan, b_is_nan, a_is_inf, b_is_inf, a_is_zero, b_is_zero;
    reg inf_zero_case;
    reg is_nan, is_inf, is_zero;

    reg [24:0] normalized_mantissa;
    reg [47:0] product_shifted;
    reg [9:0]  exponent_sum;

    reg [24:0] rounded_mantissa_pre;
    reg        mantissa_overflow;
    reg [24:0] rounded_mantissa;
    reg [9:0]  rounded_exp;

    reg [7:0] final_exp;
    reg [22:0] final_mantissa;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
        end else begin
            counter <= counter + 1;

            // Extract fields at first cycle
            if (counter == 3'b000) begin
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp  <= {2'b00, a[30:23]};
                b_exp  <= {2'b00, b[30:23]};
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Special cases
                a_exp_all_ones <= (a[30:23] == 8'hFF);
                b_exp_all_ones <= (b[30:23] == 8'hFF);
                a_exp_zero <= (a[30:23] == 8'd0);
                b_exp_zero <= (b[30:23] == 8'd0);
                a_frac_zero <= (a[22:0] == 0);
                b_frac_zero <= (b[22:0] == 0);

                a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);
                a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                a_is_zero <= (a[30:23] == 0) && (a[22:0] == 0);
                b_is_zero <= (b[30:23] == 0) && (b[22:0] == 0);

                inf_zero_case <= (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
                is_nan <= a_is_nan || b_is_nan || inf_zero_case;
                is_inf <= (!inf_zero_case) && (a_is_inf || b_is_inf);
                is_zero <= (!is_nan && !is_inf) && (a_is_zero || b_is_zero);

                z_sign <= a[31] ^ b[31];
            end else if (counter == 3'b001) begin
                // Multiply mantissas
                product <= a_mantissa * b_mantissa;

                // Exponent sum minus bias
                exponent_sum <= a_exp + b_exp - EXP_BIAS;
            end else if (counter == 3'b010) begin
                // Normalize product
                // If MSB of product is 1 at bit 47, no shift; else shift left by 1 and decrement exponent
                if (product[49]) begin
                    normalized_mantissa <= product[49:25];  // bits 49 down to 25 (25 bits)
                    product_shifted <= product;
                    z_exp <= exponent_sum + 1;
                end else begin
                    normalized_mantissa <= product[48:24];
                    product_shifted <= product << 1;
                    z_exp <= exponent_sum;
                end

                // Extract rounding bits
                guard_bit <= product_shifted[24];
                round_bit <= product_shifted[23];
                sticky_bit <= |product_shifted[22:0];
            end else if (counter == 3'b011) begin
                // Round to nearest even
                rounded_mantissa_pre <= normalized_mantissa + (guard_bit & (round_bit | sticky_bit | normalized_mantissa[0]));
                mantissa_overflow <= (normalized_mantissa + (guard_bit & (round_bit | sticky_bit | normalized_mantissa[0])))[24];
                if (mantissa_overflow) begin
                    rounded_mantissa <= rounded_mantissa_pre >> 1;
                    rounded_exp <= z_exp + 1;
                end else begin
                    rounded_mantissa <= rounded_mantissa_pre;
                    rounded_exp <= z_exp;
                end
            end else if (counter == 3'b100) begin
                // Handle special cases and final output formatting
                if (is_nan) begin
                    final_exp <= 8'hFF;
                    final_mantissa <= 23'h400000; // Quiet NaN
                end else if (is_inf) begin
                    final_exp <= 8'hFF;
                    final_mantissa <= 0;
                end else if (is_zero) begin
                    final_exp <= 0;
                    final_mantissa <= 0;
                end else begin
                    // Overflow check
                    if (rounded_exp[9:8] != 2'b00 || rounded_exp[7:0] >= 8'hFF) begin
                        final_exp <= 8'hFF;
                        final_mantissa <= 0;
                    end else if (rounded_exp[7:0] <= 0) begin
                        // Underflow - output zero (no gradual underflow)
                        final_exp <= 0;
                        final_mantissa <= 0;
                    end else begin
                        final_exp <= rounded_exp[7:0];
                        final_mantissa <= rounded_mantissa[22:0];
                    end
                end

                z <= {z_sign, final_exp, final_mantissa};
            end else begin
                // Hold output steady
                z <= z;
            end
        end
    end

endmodule
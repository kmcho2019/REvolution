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
    localparam EXP_MIN  = 8'h00;

    // Internal counter for pipeline stages (0 to 3)
    reg [2:0] counter;

    // Stage 0: registers for inputs extraction
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special cases flags for inputs, latched at stage 0
    reg a_zero, a_denormal, a_inf, a_nan;
    reg b_zero, b_denormal, b_inf, b_nan;

    // Stage 1: mantissa registers and exponent adjusted registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [9:0] a_exp_adj, b_exp_adj;
    reg res_sign;

    // Stage 1: mantissa product
    reg [47:0] mantissa_product;

    // Stage 2: normalization and exponent calculation
    reg product_msb;
    reg [47:0] shifted_product;
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounding results
    reg round_increment;
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;

    // Final mantissa and exponent before special case checks
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;

    // Flags for overflow and underflow
    reg exponent_overflow, exponent_underflow;

    // Final exponent 8-bit
    reg [7:0] final_exponent;

    // Special case result register
    reg [31:0] special_res;
    reg special_case_active;

    // Final output register for result
    reg [31:0] res;

    // Pipeline counter logic
    always @(posedge clk) begin
        if (rst)
            counter <= 3'd0;
        else if (counter == 3'd3)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // Stage 0: extract inputs and detect special cases
    always @(posedge clk) begin
        if (rst) begin
            a_sign <= 1'b0;
            a_exp <= 8'd0;
            a_frac <= 23'd0;
            b_sign <= 1'b0;
            b_exp <= 8'd0;
            b_frac <= 23'd0;

            a_zero <= 1'b0;
            a_denormal <= 1'b0;
            a_inf <= 1'b0;
            a_nan <= 1'b0;

            b_zero <= 1'b0;
            b_denormal <= 1'b0;
            b_inf <= 1'b0;
            b_nan <= 1'b0;
        end else if (counter == 3'd0) begin
            a_sign <= a[31];
            a_exp <= a[30:23];
            a_frac <= a[22:0];
            b_sign <= b[31];
            b_exp <= b[30:23];
            b_frac <= b[22:0];

            a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            a_denormal <= (a[30:23] == 8'd0) && (a[22:0] != 23'd0);
            a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

            b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
            b_denormal <= (b[30:23] == 8'd0) && (b[22:0] != 23'd0);
            b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
            b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);
        end
    end

    // Stage 1: prepare mantissas, signs, adjusted exponents, multiply mantissas
    always @(posedge clk) begin
        if (rst) begin
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            a_exp_adj <= 10'd0;
            b_exp_adj <= 10'd0;
            res_sign <= 1'b0;
            mantissa_product <= 48'd0;
        end else if (counter == 3'd1) begin
            // Mantissa with implicit 1 if normal, else no leading 1 for denormal and zero
            a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
            b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

            // Adjust exponents: use 1 for denormals per IEEE rule
            a_exp_adj <= (a_exp == 8'd0) ? 10'd1 : {2'b00, a_exp};
            b_exp_adj <= (b_exp == 8'd0) ? 10'd1 : {2'b00, b_exp};

            // Result sign
            res_sign <= a_sign ^ b_sign;

            // Multiply mantissas 24x24 = 48 bits
            mantissa_product <= ( (a_exp == 8'd0 && a_frac == 23'd0) || (b_exp == 8'd0 && b_frac == 23'd0) ) ? 48'd0 : a_mantissa * b_mantissa;
        end
    end

    // Stage 2: normalization, exponent addition, rounding bits extraction
    always @(posedge clk) begin
        if (rst) begin
            product_msb <= 1'b0;
            shifted_product <= 48'd0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
        end else if (counter == 3'd2) begin
            // Add exponents and subtract bias
            norm_exponent <= a_exp_adj + b_exp_adj - EXP_BIAS;

            // product MSB detection
            product_msb <= mantissa_product[47];

            // Shift product according to MSB
            if (mantissa_product[47]) begin
                shifted_product <= mantissa_product;
                norm_exponent <= norm_exponent + 10'd1;
            end else begin
                shifted_product <= mantissa_product << 1;
            end

            // Assign normalized mantissa (leading 1 + 23 bits)
            norm_mantissa <= product_msb ? mantissa_product[47:24] : (mantissa_product << 1)[47:24];

            // Extract rounding bits
            guard_bit <= (product_msb ? mantissa_product[23] : (mantissa_product << 1)[23]);
            round_bit <= (product_msb ? mantissa_product[22] : (mantissa_product << 1)[22]);
            sticky_bit <= (product_msb ? |mantissa_product[21:0] : |( (mantissa_product << 1)[21:0] ));
        end
    end

    // Stage 3: rounding, final exponent and mantissa calculation, special cases and output packing
    always @(posedge clk) begin
        if (rst) begin
            round_increment <= 1'b0;
            rounded_mantissa_pre <= 25'd0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 10'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            final_exponent <= 8'd0;
            special_res <= 32'd0;
            special_case_active <= 1'b0;
            res <= 32'd0;
            z <= 32'd0;
        end else if (counter == 3'd3) begin
            // Round increment calculation
            round_increment <= guard_bit & (round_bit | sticky_bit | norm_mantissa[0]);

            rounded_mantissa_pre <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

            mantissa_carry <= (rounded_mantissa_pre[24]);

            if (mantissa_carry) begin
                final_mantissa <= rounded_mantissa_pre[24:2]; // shifted right by 1 after carry out
                final_exponent_pre <= norm_exponent + 10'd1;
            end else begin
                final_mantissa <= rounded_mantissa_pre[22:0];
                final_exponent_pre <= norm_exponent;
            end

            // Overflow and underflow detection
            exponent_overflow <= ( (mantissa_carry ? (norm_exponent + 10'd1) : norm_exponent) >= 10'd255 );
            exponent_underflow <= ( (mantissa_carry ? (norm_exponent + 10'd1) : norm_exponent) <= 10'd0 );

            // Final exponent 8-bit clamp
            final_exponent <= exponent_overflow ? 8'hFF :
                              exponent_underflow ? 8'd0 :
                              (mantissa_carry ? (norm_exponent + 10'd1)[7:0] : norm_exponent[7:0]);

            // Special cases determination and output packing
            special_case_active <= 1'b0;
            special_res <= 32'd0;

            // Priority special cases
            if (a_nan || b_nan) begin
                // quiet NaN: sign=0, exp=0xFF, mantissa MSB=1
                special_res <= {1'b0, 8'hFF, 1'b1, 22'd0};
                special_case_active <= 1'b1;
            end else if ( (a_inf && b_zero) || (b_inf && a_zero) ) begin
                // Inf * zero = NaN
                special_res <= {1'b0, 8'hFF, 1'b1, 22'd0};
                special_case_active <= 1'b1;
            end else if (a_inf || b_inf) begin
                // Inf * non-zero = Inf with sign
                special_res <= {res_sign, 8'hFF, 23'd0};
                special_case_active <= 1'b1;
            end else if (a_zero || b_zero) begin
                // Zero * anything = zero with sign
                special_res <= {res_sign, 31'd0};
                special_case_active <= 1'b1;
            end else if (exponent_overflow) begin
                // Overflow => Inf
                special_res <= {res_sign, 8'hFF, 23'd0};
                special_case_active <= 1'b1;
            end else if (exponent_underflow) begin
                // Underflow => zero
                special_res <= {res_sign, 31'd0};
                special_case_active <= 1'b1;
            end

            // Final result selection
            if (special_case_active)
                res <= special_res;
            else
                res <= {res_sign, final_exponent, final_mantissa};

            // Output register updated here
            z <= res;
        end
    end

endmodule
module float_multi (
    input              clk,
    input              rst,
    input       [31:0] a,
    input       [31:0] b,
    output reg  [31:0] z
);
    localparam EXP_BIAS = 127;

    // Registered input fields
    reg          a_sign, b_sign;
    reg  [7:0]   a_exp, b_exp;
    reg  [22:0]  a_frac, b_frac;

    // Decomposed mantissas with hidden bit (24 bits)
    reg  [23:0]  a_mantissa, b_mantissa;

    // Intermediate product (48 bits)
    wire [47:0] product;

    // Sum of exponents after bias subtraction (9 bits to capture overflow)
    wire [8:0] exp_sum;

    // Output sign
    wire z_sign;

    // Special cases detection
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    wire special_nan = a_nan || b_nan;
    wire special_inf = (a_inf && !b_zero && !b_nan) || (b_inf && !a_zero && !a_nan);
    wire special_zero = (a_zero && !b_inf && !b_nan) || (b_zero && !a_inf && !a_nan);
    wire special_inf_zero = (a_inf && b_zero) || (b_inf && a_zero);

    // Prepare mantissas with implicit leading one for normals, zero for denormals
    wire [23:0] a_mantissa_w = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa_w = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Assign registered inputs on clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exp <= 8'd0;
            b_exp <= 8'd0;
            a_frac <= 23'd0;
            b_frac <= 23'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            z <= 32'd0;
        end else begin
            // Capture inputs
            a_sign <= a[31];
            a_exp <= a[30:23];
            a_frac <= a[22:0];
            b_sign <= b[31];
            b_exp <= b[30:23];
            b_frac <= b[22:0];
            a_mantissa <= a_mantissa_w;
            b_mantissa <= b_mantissa_w;

            // Compute sign
            z_sign <= a[31] ^ b[31];

            // Output computation: combinational block (see below)
            z <= float_multi_compute(
                a[31], a_exp, a_frac,
                b[31], b_exp, b_frac,
                a_zero, b_zero,
                a_inf, b_inf,
                a_nan, b_nan,
                a_mantissa_w, b_mantissa_w
            );
        end
    end

    // Combinational function to compute multiplication result
    function [31:0] float_multi_compute;
        input        a_sign_f;
        input  [7:0] a_exp_f;
        input [22:0] a_frac_f;
        input        b_sign_f;
        input  [7:0] b_exp_f;
        input [22:0] b_frac_f;
        input        a_zero_f;
        input        b_zero_f;
        input        a_inf_f;
        input        b_inf_f;
        input        a_nan_f;
        input        b_nan_f;
        input [23:0] a_mantissa_f;
        input [23:0] b_mantissa_f;

        reg    sign_r;
        reg [8:0] exp_sum_r;
        reg [47:0] product_r;
        reg [23:0] mantissa_r;
        reg [8:0] exponent_r;

        reg guard_bit, round_bit, sticky_bit;
        reg round_increment;

        reg [24:0] mantissa_rounded;

        reg mantissa_overflow;

        reg [31:0] result;

        reg is_nan, is_inf, is_zero, is_inf_zero;

        reg [47:0] product_norm;
        reg [8:0]  exp_norm;

        integer i;

        begin
            // Determine special cases
            is_nan = a_nan_f || b_nan_f;
            is_inf_zero = (a_inf_f && b_zero_f) || (b_inf_f && a_zero_f);
            is_inf = (a_inf_f || b_inf_f) && !is_nan && !is_inf_zero;
            is_zero = (a_zero_f || b_zero_f) && !is_inf && !is_nan && !is_inf_zero;

            sign_r = a_sign_f ^ b_sign_f;

            if (is_nan) begin
                // Quiet NaN: sign=0, exp=all ones, MSB mantissa=1
                result = {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (is_inf_zero) begin
                // Invalid: inf * zero = NaN
                result = {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (is_inf) begin
                // Infinity with sign
                result = {sign_r, 8'hFF, 23'd0};
            end else if (is_zero) begin
                // Zero with sign
                result = {sign_r, 31'd0};
            end else begin
                // Normal multiply process

                // Exponent sum with bias adjustment
                exp_sum_r = a_exp_f + b_exp_f - EXP_BIAS;

                // Mantissa multiply
                product_r = a_mantissa_f * b_mantissa_f; // 24*24=48 bits

                // Normalize: if MSB of product is 1, shift right and add 1 to exponent
                if (product_r[47]) begin
                    product_norm = product_r;
                    exp_norm = exp_sum_r + 1;
                end else begin
                    product_norm = product_r << 1;
                    exp_norm = exp_sum_r;
                end

                // Extract mantissa (23 bits) and rounding bits
                mantissa_r = product_norm[46:23]; // 24 bits (including implicit one)

                guard_bit = product_norm[22];
                round_bit = product_norm[21];
                sticky_bit = |product_norm[20:0];

                // Round to nearest even
                round_increment = guard_bit && (round_bit || sticky_bit || mantissa_r[0]);

                mantissa_rounded = {1'b0, mantissa_r} + round_increment;

                mantissa_overflow = mantissa_rounded[24];

                if (mantissa_overflow) begin
                    // Mantissa overflowed, shift right and increase exponent
                    mantissa_r = mantissa_rounded[24:1];
                    exponent_r = exp_norm + 1;
                end else begin
                    mantissa_r = mantissa_rounded[23:0];
                    exponent_r = exp_norm;
                end

                // Handle overflow and underflow exponent
                if (exponent_r >= 9'd255) begin
                    // Overflow -> infinity
                    result = {sign_r, 8'hFF, 23'd0};
                end else if (exponent_r <= 0) begin
                    // Underflow: result zero (flush to zero)
                    result = {sign_r, 31'd0};
                end else begin
                    // Normal result
                    result = {sign_r, exponent_r[7:0], mantissa_r[22:0]};
                end
            end

            float_multi_compute = result;
        end
    endfunction

endmodule
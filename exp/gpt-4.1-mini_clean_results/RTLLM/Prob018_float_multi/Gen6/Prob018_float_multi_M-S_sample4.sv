module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    // Extract fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire z_sign = a_sign ^ b_sign;

    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Detect special cases
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 0);
    wire a_is_inf  = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_is_inf  = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_is_nan  = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_is_nan  = (b_exp == 8'hFF) && (b_frac != 0);

    // Prepare mantissas with implicit leading 1 for normalized inputs
    reg [23:0] a_mant, b_mant;

    // Normalize subnormal mantissas by shifting left until MSB=1 or all zero
    function [23:0] norm_subnormal;
        input [23:0] mant_in;
        integer i;
        reg [23:0] mant_tmp;
        begin
            mant_tmp = mant_in;
            for (i = 0; i < 23; i = i + 1) begin
                if (mant_tmp[23] == 1'b1)
                    i = 23; // break loop
                else
                    mant_tmp = mant_tmp << 1;
            end
            norm_subnormal = mant_tmp;
        end
    endfunction

    // Calculate exponent sum and bias subtraction, signed 10-bit for safety
    reg signed [9:0] exp_sum;

    // Product of mantissas: 24 x 24 -> 48 bits
    reg [47:0] product;

    // Normalized product mantissa and adjusted exponent
    reg [23:0] mantissa_out;
    reg signed [9:0] exp_out;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounding increment
    reg rounding_inc;

    // Final mantissa after rounding
    reg [23:0] mantissa_rounded;

    // Special output flags
    reg special_nan, special_inf, special_zero;

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // 1. Prepare mantissas
            if (a_exp == 8'd0) begin
                // subnormal or zero
                a_mant = {1'b0, a_frac};
                a_mant = norm_subnormal(a_mant);
            end else begin
                // normalized: implicit leading 1
                a_mant = {1'b1, a_frac};
            end

            if (b_exp == 8'd0) begin
                b_mant = {1'b0, b_frac};
                b_mant = norm_subnormal(b_mant);
            end else begin
                b_mant = {1'b1, b_frac};
            end

            // 2. Special cases
            special_nan  = a_is_nan || b_is_nan || ( (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero) );
            special_inf  = (!special_nan) && (a_is_inf || b_is_inf);
            special_zero = (!special_nan && !special_inf) && (a_is_zero || b_is_zero);

            if (special_nan) begin
                // Quiet NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf) begin
                z <= {z_sign, 8'hFF, 23'd0};
            end else if (special_zero) begin
                z <= {z_sign, 31'd0};
            end else begin
                // 3. Exponent calculation
                exp_sum = $signed({2'b00,a_exp}) + $signed({2'b00,b_exp}) - 10'sd127;

                // 4. Multiply mantissas
                product = a_mant * b_mant; // 48 bits

                // 5. Normalize product: check MSB
                if (product[47] == 1'b1) begin
                    // MSB is 1, exponent incremented by 1
                    mantissa_out = product[46:23]; // top 24 bits after leading 1
                    exp_out = exp_sum + 10'sd1;
                    guard_bit = product[22];
                    round_bit = product[21];
                    sticky_bit = |product[20:0];
                end else begin
                    // MSB not set, shift left by 1, exponent unchanged
                    mantissa_out = product[45:22];
                    exp_out = exp_sum;
                    guard_bit = product[21];
                    round_bit = product[20];
                    sticky_bit = |product[19:0];
                end

                // 6. Rounding: round to nearest even
                rounding_inc = guard_bit && (round_bit || sticky_bit || mantissa_out[0]);

                {mantissa_rounded} = mantissa_out + rounding_inc;

                // If rounding causes overflow (carry out)
                if (mantissa_rounded == 24'h1000000) begin
                    mantissa_rounded = mantissa_rounded >> 1;
                    exp_out = exp_out + 1;
                end

                // 7. Handle overflow and underflow
                if (exp_out >= 10'sd255) begin
                    // Overflow: return infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (exp_out <= 0) begin
                    // Underflow: produce subnormal or zero
                    integer shift;
                    reg [23:0] mant_shifted;
                    reg sticky_sub;

                    shift = 1 - exp_out;

                    if (shift > 24) begin
                        // Too small, zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Shift mantissa right by shift amount
                        // Calculate sticky bit as OR of all shifted out bits
                        sticky_sub = |mantissa_rounded[shift-1:0];
                        mant_shifted = mantissa_rounded >> shift;

                        // Round again for subnormal
                        if (sticky_sub && mant_shifted[0])
                            mant_shifted = mant_shifted + 1;

                        z <= {z_sign, 8'd0, mant_shifted[22:0]};
                    end
                end else begin
                    // Normal number
                    z <= {z_sign, exp_out[7:0], mantissa_rounded[22:0]};
                end
            end
        end
    end

endmodule
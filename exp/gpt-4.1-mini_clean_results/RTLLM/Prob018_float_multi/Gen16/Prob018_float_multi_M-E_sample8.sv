module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    // IEEE-754 single precision constants
    localparam EXP_BIAS = 127;

    // Internal signals for decomposition
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    reg [23:0] a_mantissa, b_mantissa; // 1 implicit bit for normalized, 0 for denormals
    reg [9:0]  exp_sum; // extended width to detect overflow/underflow

    reg [47:0] product; // 24x24 multiplication product

    reg [22:0] final_mantissa;
    reg [7:0]  final_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Special flags
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Internal normalized mantissa and exponent after product normalization
    reg [23:0] norm_mantissa;
    reg [9:0]  norm_exponent;

    // Intermediate variables for rounding
    reg round_increment;
    reg [24:0] rounded_mantissa;

    // Detect special cases function
    function is_zero;
        input [7:0] exp;
        input [22:0] frac;
        begin
            is_zero = (exp == 8'd0) && (frac == 23'd0);
        end
    endfunction

    function is_inf;
        input [7:0] exp;
        input [22:0] frac;
        begin
            is_inf = (exp == 8'hFF) && (frac == 23'd0);
        end
    endfunction

    function is_nan;
        input [7:0] exp;
        input [22:0] frac;
        begin
            is_nan = (exp == 8'hFF) && (frac != 23'd0);
        end
    endfunction

    // Sticky bit calculation function for OR reduction of bits below round bit
    function calc_sticky;
        input [21:0] bits;
        integer i;
        begin
            calc_sticky = 1'b0;
            for (i=0; i<22; i=i+1) begin
                if (bits[i]) calc_sticky = 1'b1;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            z <= 32'b0;
        end else begin
            // Extract fields
            a_sign   = a[31];
            a_exp    = a[30:23];
            a_frac   = a[22:0];
            b_sign   = b[31];
            b_exp    = b[30:23];
            b_frac   = b[22:0];

            // Special cases
            a_zero = is_zero(a_exp, a_frac);
            b_zero = is_zero(b_exp, b_frac);
            a_inf  = is_inf(a_exp, a_frac);
            b_inf  = is_inf(b_exp, b_frac);
            a_nan  = is_nan(a_exp, a_frac);
            b_nan  = is_nan(b_exp, b_frac);

            // Compute sign
            z_sign = a_sign ^ b_sign;

            // Handle NaNs first: if either input is NaN, result is canonical NaN
            if (a_nan || b_nan) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                disable compute_mul; // Skip further computation
            end else begin : compute_mul
                // Handle infinities and zeros with their special rules:
                // Inf * 0 = NaN
                if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN
                end else if (a_inf || b_inf) begin
                    // Inf * non-zero = Inf
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (a_zero || b_zero) begin
                    // Zero * anything (except NaN or Inf handled above) = zero
                    z <= {z_sign, 31'd0};
                end else begin
                    // Prepare mantissas with implicit leading bit if normalized
                    if (a_exp == 8'd0)
                        a_mantissa = {1'b0, a_frac}; // Denormal, no implicit leading 1
                    else
                        a_mantissa = {1'b1, a_frac};

                    if (b_exp == 8'd0)
                        b_mantissa = {1'b0, b_frac};
                    else
                        b_mantissa = {1'b1, b_frac};

                    // Exponent sum - bias
                    exp_sum = a_exp + b_exp - EXP_BIAS;

                    // Multiply mantissas: 24x24 = 48 bits
                    product = a_mantissa * b_mantissa;

                    // Normalize product:
                    // If highest bit (bit 47) is set, the product is already normalized (shift right 1)
                    if (product[47] == 1'b1) begin
                        norm_mantissa = product[46:23];
                        norm_exponent = exp_sum + 1;
                        // Extract rounding bits: guard = bit 23, round = bit 22, sticky = OR of bits 0..21
                        guard_bit = product[23];
                        round_bit = product[22];
                        sticky_bit = (|product[21:0]) ? 1'b1 : 1'b0;
                    end else begin
                        // Leading one is in bit 46, no shift needed
                        norm_mantissa = product[45:22];
                        norm_exponent = exp_sum;
                        guard_bit = product[22];
                        round_bit = product[21];
                        sticky_bit = (|product[20:0]) ? 1'b1 : 1'b0;
                    end

                    // Round to nearest even:
                    // increment if guard bit is 1 AND (round bit or sticky bit or LSB of mantissa is 1)
                    round_increment = guard_bit && (round_bit || sticky_bit || norm_mantissa[0]);

                    rounded_mantissa = {1'b0, norm_mantissa} + round_increment;

                    // Check mantissa overflow after rounding (bit 24)
                    if (rounded_mantissa[24]) begin
                        // Mantissa overflowed, shift right 1 and increment exponent
                        final_mantissa = rounded_mantissa[24:2];
                        final_exponent = norm_exponent + 1;
                    end else begin
                        final_mantissa = rounded_mantissa[23:1];
                        final_exponent = norm_exponent;
                    end

                    // Handle overflow and underflow
                    if (final_exponent >= 8'hFF) begin
                        // Overflow, set to infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (final_exponent <= 0) begin
                        // Underflow, flush to zero (no gradual underflow implemented)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number
                        z <= {z_sign, final_exponent[7:0], final_mantissa};
                    end
                end
            end
        end
    end

endmodule
module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;
    localparam EXP_INF_NAN = 8'hFF;

    reg [2:0] counter;

    // Stage 0: input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mantissa, b_mantissa;

    // Special flags stage 0
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    // Stage 1: multiply mantissas, add exponents, compute sign
    reg [47:0] product;
    reg [9:0] exponent_sum; // to cover range with bias adjustment
    reg z_sign;

    // Stage 2: normalization
    reg [47:0] norm_product;
    reg [9:0] norm_exponent;

    // Stage 3: rounding
    reg guard_bit, round_bit, sticky_bit;
    reg [23:0] round_mantissa; // 24 bits with leading bit
    reg [9:0] round_exponent;

    // Stage 4: final output and special cases
    reg special_nan_out, special_inf_out, special_zero_out;

    // Rounding signals
    reg round_increment;
    reg [24:0] mantissa_rounded; // one extra bit for overflow

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;

            a_is_zero <= 1'b0; b_is_zero <= 1'b0;
            a_is_inf <= 1'b0; b_is_inf <= 1'b0;
            a_is_nan <= 1'b0; b_is_nan <= 1'b0;

            product <= 48'd0;
            exponent_sum <= 10'd0;
            z_sign <= 1'b0;

            norm_product <= 48'd0;
            norm_exponent <= 10'd0;

            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            round_mantissa <= 24'd0;
            round_exponent <= 10'd0;

            special_nan_out <= 1'b0;
            special_inf_out <= 1'b0;
            special_zero_out <= 1'b0;

            round_increment <= 1'b0;
            mantissa_rounded <= 25'd0;
        end else begin
            case (counter)
            3'd0: begin
                // Extract sign bits
                a_sign <= a[31];
                b_sign <= b[31];

                // Extract exponents
                a_exp <= a[30:23];
                b_exp <= b[30:23];

                // Extract mantissas with implicit leading 1 for normals, 0 for denormals
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Detect zero inputs
                a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                // Detect infinity inputs
                a_is_inf <= (a[30:23] == EXP_INF_NAN) && (a[22:0] == 23'd0);
                b_is_inf <= (b[30:23] == EXP_INF_NAN) && (b[22:0] == 23'd0);

                // Detect NaNs
                a_is_nan <= (a[30:23] == EXP_INF_NAN) && (a[22:0] != 23'd0);
                b_is_nan <= (b[30:23] == EXP_INF_NAN) && (b[22:0] != 23'd0);

                counter <= 3'd1;
            end

            3'd1: begin
                // Compute output sign as XOR of inputs
                z_sign <= a_sign ^ b_sign;

                // Sum exponents and subtract bias
                exponent_sum <= a_exp + b_exp - EXP_BIAS;

                // Multiply mantissas (24x24 = 48 bits)
                product <= a_mantissa * b_mantissa;

                counter <= 3'd2;
            end

            3'd2: begin
                // Normalize product:
                // If MSB (bit 47) is 1, shift right by 1 and increment exponent
                // else keep as is
                if (product[47]) begin
                    norm_product <= product >> 1;
                    norm_exponent <= exponent_sum + 1;
                end else begin
                    norm_product <= product;
                    norm_exponent <= exponent_sum;
                end

                counter <= 3'd3;
            end

            3'd3: begin
                // Extract rounding bits from normalized product
                // Mantissa bits: bits [46:23] (24 bits)
                round_mantissa <= norm_product[46:23];
                round_exponent <= norm_exponent;

                guard_bit <= norm_product[22];
                round_bit <= norm_product[21];
                sticky_bit <= |norm_product[20:0];

                // Calculate round increment (round to nearest even):
                // round_increment = guard_bit && (round_bit || sticky_bit || LSB of mantissa)
                round_increment <= guard_bit && (round_bit || sticky_bit || round_mantissa[0]);

                counter <= 3'd4;
            end

            3'd4: begin
                // Add round increment
                mantissa_rounded <= {1'b0, round_mantissa} + {24'd0, round_increment};

                // Adjust exponent if mantissa overflowed after rounding
                if (mantissa_rounded[24]) begin
                    // Shift mantissa right by 1 and increase exponent
                    round_mantissa <= mantissa_rounded[24:1];
                    round_exponent <= round_exponent + 1;
                end else begin
                    round_mantissa <= mantissa_rounded[23:0];
                    // exponent unchanged
                end

                // Handle special cases
                special_nan_out <= a_is_nan || b_is_nan;
                // Inf * 0 or 0 * Inf = NaN
                special_nan_out <= special_nan_out || ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero));

                special_inf_out <= (a_is_inf || b_is_inf) && !special_nan_out;
                special_zero_out <= (a_is_zero || b_is_zero) && !special_nan_out && !special_inf_out;

                // Compose final output
                if (special_nan_out) begin
                    // Quiet NaN (sign=0, exp=all ones, mantissa MSB=1)
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf_out) begin
                    // Infinity with proper sign
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero_out) begin
                    // Zero with proper sign
                    z <= {z_sign, 31'd0};
                end else if (round_exponent >= EXP_INF_NAN) begin
                    // Overflow to infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (round_exponent <= 0) begin
                    // Underflow to zero (no subnormals handled here)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normalized number, remove implicit leading 1 from mantissa
                    z <= {z_sign, round_exponent[7:0], round_mantissa[22:0]};
                end

                counter <= 3'd0;
            end

            default: counter <= 3'd0;
            endcase
        end
    end
endmodule
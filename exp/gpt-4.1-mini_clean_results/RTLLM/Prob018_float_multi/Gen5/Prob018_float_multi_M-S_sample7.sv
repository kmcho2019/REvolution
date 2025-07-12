module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Stage 0 registers - extracted input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mantissa, b_mantissa; // 1 implicit + 23 bits fraction

    // Stage 1 registers - multiplication result and exponent sum
    reg [47:0] product;     // 24x24 bits = 48 bits
    reg [9:0] exponent_sum; // extended to handle bias adjustments and overflow
    reg z_sign;

    // Stage 2 registers - normalization and rounding bits
    reg [47:0] norm_product;
    reg [9:0] norm_exponent;

    reg guard_bit, round_bit, sticky_bit;
    reg [23:0] z_mantissa;

    // Special case flags (registered for stable pipeline)
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg special_nan, special_inf, special_zero, special_nan_out;

    // Temporary signals for rounding
    reg round_increment;
    reg [24:0] mant_rounded;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Reset registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;

            product <= 48'd0;
            exponent_sum <= 10'd0;
            z_sign <= 1'b0;

            norm_product <= 48'd0;
            norm_exponent <= 10'd0;

            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            z_mantissa <= 24'd0;

            a_zero <= 1'b0; b_zero <= 1'b0; a_inf <= 1'b0; b_inf <= 1'b0; a_nan <= 1'b0; b_nan <= 1'b0;
            special_nan <= 1'b0; special_inf <= 1'b0; special_zero <= 1'b0; special_nan_out <= 1'b0;

            round_increment <= 1'b0;
            mant_rounded <= 25'd0;
        end else begin
            case (counter)
            3'd0: begin
                // Extract sign
                a_sign <= a[31];
                b_sign <= b[31];

                // Extract exponent
                a_exp <= a[30:23];
                b_exp <= b[30:23];

                // Extract mantissa with implicit leading 1 if normalized, else 0 for denormals
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Detect special cases
                a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                counter <= 3'd1;
            end

            3'd1: begin
                // Multiply mantissas: 24x24 bits = 48 bits product
                product <= a_mantissa * b_mantissa;

                // Exponent sum with bias subtraction (127)
                exponent_sum <= a_exp + b_exp - EXP_BIAS;

                // Compute output sign as XOR
                z_sign <= a_sign ^ b_sign;

                // Prepare special case flags for output
                special_nan <= a_nan || b_nan;
                // Inf * 0 = NaN case
                special_nan_out <= ( (a_inf && b_zero) || (b_inf && a_zero) );
                special_inf <= (a_inf || b_inf) && !special_nan_out;
                special_zero <= (a_zero || b_zero) && !special_nan_out && !special_inf;

                counter <= 3'd2;
            end

            3'd2: begin
                // Normalize product if top bit 47 is 1, shift right by 1 and increment exponent
                if (product[47]) begin
                    norm_product <= product >> 1;
                    norm_exponent <= exponent_sum + 1;
                end else begin
                    norm_product <= product;
                    norm_exponent <= exponent_sum;
                end

                // Extract rounding bits
                guard_bit <= norm_product[23];
                round_bit <= norm_product[22];
                sticky_bit <= |norm_product[21:0];

                // Extract mantissa bits (24 bits: bit 46 down to 23 in product; here bit 46 maps to 23 of shifted 48-bit)
                // Because product width is 48, after shifting max by 1, mantissa bits start from bit 46 down to 23
                z_mantissa <= norm_product[46:23];

                counter <= 3'd3;
            end

            3'd3: begin
                // Compute round increment: round to nearest even
                round_increment <= guard_bit && (round_bit || sticky_bit || z_mantissa[0]);

                // Add rounding increment
                mant_rounded <= {1'b0, z_mantissa} + {24'd0, round_increment};

                // Check if rounding caused mantissa overflow (bit 24)
                if (mant_rounded[24]) begin
                    // Mantissa overflow: shift right by 1 and increment exponent
                    z_mantissa <= mant_rounded[24:1];
                    norm_exponent <= norm_exponent + 1;
                end else begin
                    z_mantissa <= mant_rounded[23:0];
                    // norm_exponent stays the same
                end

                // Final output assignment with special cases handling

                if (special_nan || special_nan_out) begin
                    // Output quiet NaN: sign=0, exp=all ones, mantissa with MSB 1
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf) begin
                    // Output infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Output zero
                    z <= {z_sign, 31'd0};
                end else if (norm_exponent >= 8'hFF) begin
                    // Overflow to infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (norm_exponent <= 0) begin
                    // Underflow to zero (no subnormals)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normalized number
                    z <= {z_sign, norm_exponent[7:0], z_mantissa[22:0]};
                end

                counter <= 3'd0;
            end

            default: counter <= 3'd0;

            endcase
        end
    end
endmodule
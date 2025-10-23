module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // IEEE754 fields extraction
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Constants
    localparam EXP_BIAS = 127;

    // Special conditions
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_is_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Mantissas with implicit leading 1 for normals, else zero for zero or denormals
    wire [23:0] a_mant = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mant = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Intermediate signals for multiplication
    reg [47:0] product;       // 24x24 mantissa multiplication result
    reg [9:0] exp_sum;        // 10 bits to allow overflow (8+8 max + adjustments)
    reg sign_res;

    // Normalized mantissa and exponent after shifting
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Final mantissa and exponent after rounding
    reg [23:0] mantissa_rounded;
    reg [9:0] exponent_rounded;

    // Flags for special cases output
    reg output_nan, output_inf, output_zero;

    integer shift_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // Default output flags
            output_nan = 1'b0;
            output_inf = 1'b0;
            output_zero = 1'b0;

            // Sign of result
            sign_res = a_sign ^ b_sign;

            // Handle special cases first
            if (a_is_nan || b_is_nan) begin
                // If any input is NaN -> output quiet NaN (exponent=255 mantissa!=0)
                output_nan = 1'b1;
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN pattern
            end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                // Inf * 0 => NaN
                output_nan = 1'b1;
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_is_inf || b_is_inf) begin
                // Inf * normal => Inf
                output_inf = 1'b1;
                z <= {sign_res, 8'hFF, 23'd0};
            end else if (a_is_zero || b_is_zero) begin
                // Zero * anything => zero
                output_zero = 1'b1;
                z <= {sign_res, 31'd0};
            end else begin
                // Normal multiplication process

                // Multiply mantissas: 24 bits * 24 bits = 48 bits product
                product = a_mant * b_mant;

                // Add exponents and subtract bias
                exp_sum = a_exp + b_exp - EXP_BIAS;

                // Normalize product:
                // If MSB product[47] = 1, product is in [2,4), leading '1' at bit 47, shift right by 1 and increment exponent
                // else product in [1,2), leading '1' at bit 46, no shift

                if (product[47] == 1'b1) begin
                    // Shift right by 1
                    product = product >> 1;
                    exp_sum = exp_sum + 1;
                end
                // Now leading 1 at bit 46

                // Extract mantissa bits [46:24] for 23 mantissa bits + 1 implicit leading (bit 46)
                // We explicitly keep leading 1 in mantissa_rounded bit 23

                norm_mantissa = product[46:23]; // 24 bits, leading 1 included at bit 23

                // Extract rounding bits:
                guard_bit = product[22];
                round_bit = product[21];
                sticky_bit = |product[20:0];

                norm_exponent = exp_sum;

                // Rounding: round to nearest even

                // Check if rounding increment needed
                if (guard_bit && (round_bit | sticky_bit | norm_mantissa[0])) begin
                    // Round up
                    mantissa_rounded = norm_mantissa + 1'b1;
                    exponent_rounded = norm_exponent;

                    // Check mantissa overflow after rounding (if mantissa_rounded is 25 bits)
                    if (mantissa_rounded == 24'h1000000) begin
                        // Overflow, shift mantissa right and increase exponent
                        mantissa_rounded = mantissa_rounded >> 1; // becomes 24'h800000
                        exponent_rounded = exponent_rounded + 1;
                    end
                end else begin
                    // No rounding increment
                    mantissa_rounded = norm_mantissa;
                    exponent_rounded = norm_exponent;
                end

                // Handle overflow and underflow of exponent
                if (exponent_rounded >= 10'd255) begin
                    // Overflow => Inf
                    output_inf = 1'b1;
                    z <= {sign_res, 8'hFF, 23'd0};
                end else if (exponent_rounded <= 0) begin
                    // Underflow => zero (flush to zero)
                    output_zero = 1'b1;
                    z <= {sign_res, 31'd0};
                end else begin
                    // Assemble normal result:
                    // sign, exponent, mantissa excluding implicit leading 1
                    z <= {sign_res, exponent_rounded[7:0], mantissa_rounded[22:0]};
                end
            end
        end
    end

endmodule
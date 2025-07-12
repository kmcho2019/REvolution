module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    reg        a_sign, b_sign, z_sign;
    reg [7:0]  a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    reg [23:0] a_mant, b_mant;
    reg [47:0] product;
    reg [8:0]  exp_sum;

    reg        a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg [23:0] mantissa_norm;
    reg [7:0]  exp_norm;
    reg        guard_bit, round_bit, sticky_bit;
    reg [24:0] mantissa_rounded;
    reg [8:0]  exp_rounded;

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'b0;
        end else begin
            // Extract signs, exponent, fraction
            a_sign = a[31];
            b_sign = b[31];
            a_exp  = a[30:23];
            b_exp  = b[30:23];
            a_frac = a[22:0];
            b_frac = b[22:0];

            // Detect special cases
            a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
            b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
            a_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
            b_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
            a_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
            b_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

            // Result sign is XOR of input signs
            z_sign = a_sign ^ b_sign;

            // Handle special cases
            if (a_nan || b_nan) begin
                // NaN output: quiet NaN with MSB of fraction = 1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_inf || b_inf) begin
                // Infinity times non-zero = infinity
                z <= {z_sign, 8'hFF, 23'd0};
            end else if (a_zero || b_zero) begin
                // Zero times anything = zero
                z <= {z_sign, 31'd0};
            end else begin
                // Normalize mantissas with implicit leading 1 for normals
                a_mant = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                b_mant = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                // Multiply mantissas: 24 x 24 = 48 bits
                product = a_mant * b_mant;

                // Add exponents and subtract bias
                exp_sum = a_exp + b_exp - EXP_BIAS;

                // Normalize product:
                // If MSB of product (bit 47) == 1, shift right by 1 and increment exponent
                if (product[47]) begin
                    mantissa_norm = product[47:24]; // top 24 bits
                    guard_bit = product[23];
                    round_bit = product[22];
                    sticky_bit = |product[21:0];
                    exp_norm = exp_sum + 1;
                end else begin
                    mantissa_norm = product[46:23]; // shifted one left
                    guard_bit = product[22];
                    round_bit = product[21];
                    sticky_bit = |product[20:0];
                    exp_norm = exp_sum;
                end

                // Rounding to nearest even
                // Round increment if guard & (round | sticky | LSB)
                if (guard_bit && (round_bit || sticky_bit || mantissa_norm[0]))
                    mantissa_rounded = mantissa_norm + 25'd1;
                else
                    mantissa_rounded = {1'b0, mantissa_norm};

                // Handle mantissa overflow after rounding
                if (mantissa_rounded[24]) begin
                    exp_rounded = exp_norm + 1;
                    mantissa_rounded = mantissa_rounded >> 1;
                end else begin
                    exp_rounded = exp_norm;
                end

                // Handle exponent overflow and underflow
                if (exp_rounded >= 9'd255) begin
                    // Overflow: return infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (exp_rounded <= 0) begin
                    // Underflow: flush to zero
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal case
                    z <= {z_sign, exp_rounded[7:0], mantissa_rounded[22:0]};
                end
            end
        end
    end
endmodule
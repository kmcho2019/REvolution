module float_multi(
    input              clk,
    input              rst,
    input      [31:0]  a,
    input      [31:0]  b,
    output reg [31:0]  z
);
    localparam EXP_BIAS = 127;

    reg         a_sign, b_sign, z_sign;
    reg  [7:0]  a_exp, b_exp;
    reg  [22:0] a_frac, b_frac;
    reg  [23:0] a_mantissa, b_mantissa;
    reg [47:0]  product;
    reg  [9:0]  exp_sum;
    reg  [23:0] z_mantissa;
    reg  [9:0]  z_exponent;
    reg         guard_bit, round_bit, sticky_bit;
    reg         product_msb;

    // Flags for special cases
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // Extract inputs
            a_sign <= a[31];
            b_sign <= b[31];
            a_exp  <= a[30:23];
            b_exp  <= b[30:23];
            a_frac <= a[22:0];
            b_frac <= b[22:0];

            // Determine sign of result
            z_sign <= a[31] ^ b[31];

            // Prepare mantissas: add implicit leading 1 for normalized, 0 for denormals
            a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
            b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

            // Check special cases first and set output accordingly
            if (a_nan || b_nan) begin
                // Quiet NaN: sign=0, exp=255, mantissa MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_inf || b_inf) begin
                // Inf * non-zero = Inf
                z <= {z_sign, 8'hFF, 23'd0};
            end else if (a_zero || b_zero) begin
                // Zero * anything = zero
                z <= {z_sign, 31'd0};
            end else begin
                // Normal multiplication path

                // Add exponents, subtract bias
                exp_sum = a_exp + b_exp - EXP_BIAS;

                // Multiply mantissas (24x24)
                product = a_mantissa * b_mantissa; // 48 bits

                product_msb = product[47];

                if (product_msb) begin
                    // MSB is 1, no shift needed but exponent increase by 1
                    z_exponent = exp_sum + 10'd1;
                    // Take top 24 bits for mantissa including leading 1
                    z_mantissa = product[47:24];
                    // Extract rounding bits
                    guard_bit = product[23];
                    round_bit = product[22];
                    sticky_bit = |product[21:0];
                end else begin
                    // MSB is 0, shift mantissa left by 1 (take bits [46:23])
                    z_exponent = exp_sum;
                    z_mantissa = product[46:23];
                    guard_bit = product[22];
                    round_bit = product[21];
                    sticky_bit = |product[20:0];
                end

                // Rounding: round to nearest even
                if (guard_bit && (round_bit || sticky_bit || z_mantissa[0])) begin
                    {z_exponent, z_mantissa} = {z_exponent, z_mantissa} + 25'd1;
                end

                // Check mantissa overflow after rounding
                if (z_mantissa[24]) begin
                    // Shift mantissa right and increment exponent
                    z_mantissa = z_mantissa >> 1;
                    z_exponent = z_exponent + 10'd1;
                end

                // Handle overflow and underflow
                if (z_exponent >= 10'd255) begin
                    // Overflow -> infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (z_exponent <= 0) begin
                    // Underflow -> zero (no gradual underflow)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal result
                    z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                end
            end
        end
    end
endmodule
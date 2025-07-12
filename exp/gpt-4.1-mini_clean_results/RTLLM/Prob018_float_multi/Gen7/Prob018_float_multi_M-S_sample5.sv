module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Bias for exponent in IEEE-754 single precision
    localparam EXP_BIAS = 127;

    // Stage 1 registers: decode inputs
    reg         sign_a, sign_b;
    reg  [7:0]  exp_a, exp_b;
    reg  [23:0] mant_a, mant_b; // implicit leading 1 added if normalized
    reg         zero_a, zero_b;
    reg         inf_a, inf_b;
    reg         nan_a, nan_b;

    // Stage 2 registers: multiply mantissas, add exponents, normalize, round, output
    reg         sign_out;
    reg  [8:0]  exp_sum;       // sum of exponents minus bias, 9 bits to cover overflow
    reg  [47:0] mant_product;  // product of mantissas (24x24)
    reg         zero_prod;
    reg         inf_prod;
    reg         nan_prod;

    // Normalization & rounding signals
    reg  [23:0] mant_norm;
    reg  [7:0]  exp_norm;
    reg         guard_bit, round_bit, sticky_bit;
    reg  [24:0] mant_rounded; // 24 bits mantissa + 1 bit carry after rounding

    // Decode inputs at posedge clk
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_a <= 1'b0; sign_b <= 1'b0;
            exp_a <= 8'd0; exp_b <= 8'd0;
            mant_a <= 24'd0; mant_b <= 24'd0;
            zero_a <= 1'b0; zero_b <= 1'b0;
            inf_a <= 1'b0; inf_b <= 1'b0;
            nan_a <= 1'b0; nan_b <= 1'b0;
        end else begin
            sign_a <= a[31];
            sign_b <= b[31];
            exp_a <= a[30:23];
            exp_b <= b[30:23];

            // Identify special cases
            zero_a <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            zero_b <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
            inf_a  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            inf_b  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
            nan_a  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            nan_b  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Add implicit leading one for normalized numbers else zero for denormals
            mant_a <= (exp_a == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            mant_b <= (exp_b == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // Multiply, normalize, round, and assemble output at posedge clk
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
            sign_out <= 1'b0;
            exp_sum <= 9'd0;
            mant_product <= 48'd0;
            zero_prod <= 1'b0;
            inf_prod <= 1'b0;
            nan_prod <= 1'b0;
            mant_norm <= 24'd0;
            exp_norm <= 8'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            mant_rounded <= 25'd0;
        end else begin
            // Combine sign
            sign_out <= sign_a ^ sign_b;

            // Check special cases first (NaN dominates)
            nan_prod <= nan_a | nan_b;
            inf_prod <= (inf_a & ~zero_b & ~nan_b) | (inf_b & ~zero_a & ~nan_a);
            zero_prod <= (zero_a | zero_b) & ~nan_prod & ~inf_prod;

            // If no special cases, proceed with multiplication
            if (!nan_prod && !inf_prod && !zero_prod) begin
                // Exponent sum with bias adjustment
                exp_sum <= (exp_a + exp_b) - EXP_BIAS;

                // Mantissa multiplication
                mant_product <= mant_a * mant_b; // 24x24=48 bits

                // Normalize product:
                // If MSB of product is 1 (bit 47), shift mantissa right 1 and increment exponent
                if (mant_product[47] == 1'b1) begin
                    // Normalized mantissa is bits [47:24]
                    mant_norm <= mant_product[47:24];
                    exp_norm <= exp_sum + 1;
                    guard_bit <= mant_product[23];
                    round_bit <= mant_product[22];
                    sticky_bit <= |mant_product[21:0];
                end else begin
                    // Normalized mantissa is bits [46:23]
                    mant_norm <= mant_product[46:23];
                    exp_norm <= exp_sum;
                    guard_bit <= mant_product[22];
                    round_bit <= mant_product[21];
                    sticky_bit <= |mant_product[20:0];
                end

                // Round to nearest even
                if (guard_bit && (round_bit | sticky_bit | mant_norm[0]))
                    mant_rounded <= {1'b0, mant_norm} + 25'd1;
                else
                    mant_rounded <= {1'b0, mant_norm};

                // Adjust exponent if mantissa overflowed after rounding
                if (mant_rounded[24]) begin
                    exp_norm <= exp_norm + 1;
                    mant_norm <= mant_rounded[24:1]; // shifted right by 1 (drop LSB)
                end else begin
                    mant_norm <= mant_rounded[23:0];
                end

                // Handle overflow and underflow of exponent
                if (exp_norm >= 8'hFF) begin
                    // Overflow: set to infinity
                    z <= {sign_out, 8'hFF, 23'd0};
                end else if (exp_norm <= 0) begin
                    // Underflow: flush to zero (no gradual underflow implemented)
                    z <= {sign_out, 31'd0};
                end else begin
                    // Normal case
                    z <= {sign_out, exp_norm[7:0], mant_norm[22:0]};
                end
            end else begin
                // Handle special cases output:
                if (nan_prod) begin
                    // Quiet NaN output (exponent all ones, mantissa MSB=1)
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (inf_prod) begin
                    // Infinity with proper sign
                    z <= {sign_out, 8'hFF, 23'd0};
                end else if (zero_prod) begin
                    // Zero with proper sign
                    z <= {sign_out, 31'd0};
                end else begin
                    // Should not occur, but default to zero
                    z <= 32'd0;
                end
            end
        end
    end

endmodule
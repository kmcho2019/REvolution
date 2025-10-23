module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Input fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special cases detection (combinational)
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Registered copies of inputs for processing
    reg r_a_sign, r_b_sign;
    reg [7:0] r_a_exp, r_b_exp;
    reg [22:0] r_a_frac, r_b_frac;
    reg r_a_zero, r_b_zero, r_a_inf, r_b_inf, r_a_nan, r_b_nan;

    // Mantissas extended to 24 bits (with implicit leading 1 for normalized)
    reg [23:0] a_mantissa, b_mantissa;

    // Product and exponent sum
    reg [47:0] product;
    reg [9:0] exp_sum;
    reg sign_result;

    // Normalized mantissa and exponent signals (combinational)
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [24:0] mantissa_rounded;
    reg [9:0] exponent_rounded;

    // Flags for special cases and final output selection
    reg is_nan_out;
    reg is_inf_out;
    reg is_zero_out;

    // Stage 0: latch inputs and special cases
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_a_sign <= 1'b0;
            r_b_sign <= 1'b0;
            r_a_exp <= 8'd0;
            r_b_exp <= 8'd0;
            r_a_frac <= 23'd0;
            r_b_frac <= 23'd0;
            r_a_zero <= 1'b0;
            r_b_zero <= 1'b0;
            r_a_inf <= 1'b0;
            r_b_inf <= 1'b0;
            r_a_nan <= 1'b0;
            r_b_nan <= 1'b0;
        end else if (counter == 3'd0) begin
            r_a_sign <= a_sign;
            r_b_sign <= b_sign;
            r_a_exp <= a_exp;
            r_b_exp <= b_exp;
            r_a_frac <= a_frac;
            r_b_frac <= b_frac;
            r_a_zero <= a_zero;
            r_b_zero <= b_zero;
            r_a_inf <= a_inf;
            r_b_inf <= b_inf;
            r_a_nan <= a_nan;
            r_b_nan <= b_nan;
        end
    end

    // Stage 0: Prepare mantissas and result sign (combinational)
    always @(*) begin
        a_mantissa = (r_a_exp == 8'd0) ? {1'b0, r_a_frac} : {1'b1, r_a_frac};
        b_mantissa = (r_b_exp == 8'd0) ? {1'b0, r_b_frac} : {1'b1, r_b_frac};
        sign_result = r_a_sign ^ r_b_sign;
    end

    // Stage 1: Multiply mantissas and add exponents
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product <= 48'd0;
            exp_sum <= 10'd0;
        end else if (counter == 3'd1) begin
            product <= a_mantissa * b_mantissa;
            // Exponent sum: add exponents and subtract bias
            exp_sum <= r_a_exp + r_b_exp - EXP_BIAS;
        end
    end

    // Stage 2: Normalize product and extract rounding bits (combinational)
    always @(*) begin
        // Default assignments
        norm_mantissa = 24'd0;
        norm_exponent = 10'd0;
        guard_bit = 1'b0;
        round_bit = 1'b0;
        sticky_bit = 1'b0;

        if (product[47]) begin
            // MSB set, shift right by 1, increment exponent
            norm_mantissa = product[47:24];
            norm_exponent = exp_sum + 10'd1;
            guard_bit = product[23];
            round_bit = product[22];
            sticky_bit = |product[21:0];
        end else begin
            // MSB zero, no shift
            norm_mantissa = product[46:23];
            norm_exponent = exp_sum;
            guard_bit = product[22];
            round_bit = product[21];
            sticky_bit = |product[20:0];
        end
    end

    // Stage 3: Rounding, special cases, output register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mantissa_rounded <= 25'd0;
            exponent_rounded <= 10'd0;
            is_nan_out <= 1'b0;
            is_inf_out <= 1'b0;
            is_zero_out <= 1'b0;
            z <= 32'd0;
        end else if (counter == 3'd3) begin
            // Detect special output cases
            is_nan_out <= r_a_nan | r_b_nan |
                          ((r_a_inf & r_b_zero) | (r_b_inf & r_a_zero));
            is_inf_out <= (r_a_inf & ~r_b_zero & ~r_b_nan) | (r_b_inf & ~r_a_zero & ~r_a_nan);
            is_zero_out <= (r_a_zero & ~r_b_inf & ~r_b_nan) | (r_b_zero & ~r_a_inf & ~r_a_nan);

            if (is_nan_out) begin
                // Quiet NaN: sign=0, exp=all 1s, MSB mantissa=1, rest zero
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (is_inf_out) begin
                // Infinity with sign
                z <= {sign_result, 8'hFF, 23'd0};
            end else if (is_zero_out) begin
                // Zero with sign
                z <= {sign_result, 31'd0};
            end else begin
                // Normal rounding to nearest even
                if (guard_bit && (round_bit | sticky_bit | norm_mantissa[0]))
                    mantissa_rounded <= {1'b0, norm_mantissa} + 25'd1;
                else
                    mantissa_rounded <= {1'b0, norm_mantissa};

                if (mantissa_rounded[24]) begin
                    // Mantissa overflow after rounding, shift right one and increment exponent
                    exponent_rounded <= norm_exponent + 10'd1;
                end else begin
                    exponent_rounded <= norm_exponent;
                end

                // Final output generation with overflow/underflow check
                if (mantissa_rounded[24]) begin
                    // Mantissa after overflow shift right by 1: bits [24:1]
                    if (exponent_rounded[7:0] >= 8'hFF) begin
                        // Overflow to infinity
                        z <= {sign_result, 8'hFF, 23'd0};
                    end else if (exponent_rounded <= 0) begin
                        // Underflow to zero
                        z <= {sign_result, 31'd0};
                    end else begin
                        z <= {sign_result, exponent_rounded[7:0], mantissa_rounded[23:1]};
                    end
                end else begin
                    // Mantissa normal case: bits [23:1]
                    if (exponent_rounded[7:0] >= 8'hFF) begin
                        // Overflow to infinity
                        z <= {sign_result, 8'hFF, 23'd0};
                    end else if (exponent_rounded <= 0) begin
                        // Underflow to zero
                        z <= {sign_result, 31'd0};
                    end else begin
                        z <= {sign_result, exponent_rounded[7:0], mantissa_rounded[22:0]};
                    end
                end
            end
        end
    end

    // Counter to sequence operation steps: 0 to 3
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
        end else begin
            if (counter == 3'd3)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;
        end
    end

endmodule
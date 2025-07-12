module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    // Constants
    localparam EXP_BIAS = 127;

    // Operation cycle counter for sequencing pipeline steps
    reg [2:0] counter;

    // Registers for input operands fields
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    // Special case flags for inputs
    reg a_is_zero, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_inf, b_is_nan;

    // Mantissas with hidden bit
    reg [23:0] a_mantissa, b_mantissa;

    // Intermediate multiplication and exponent sum
    reg [47:0] product;
    reg [9:0]  exp_sum;

    // Normalized mantissa and exponent
    reg [23:0] mant_norm;
    reg [9:0]  exp_norm;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [24:0] mant_rounded; // 25 bits to hold rounding carry
    reg [9:0]  exp_rounded;

    // Sign and final special flags passed through stages
    reg sign;

    reg a_is_zero_reg, b_is_zero_reg, a_is_inf_reg, b_is_inf_reg, a_is_nan_reg, b_is_nan_reg;

    // Sticky bit calculation helper
    function automatic bit sticky_or;
        input [21:0] bits;
        integer i;
        begin
            sticky_or = 1'b0;
            for (i = 0; i < 22; i = i + 1) begin
                if (bits[i]) sticky_or = 1'b1;
            end
        end
    endfunction

    // Cycle counter control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
        end else begin
            if (counter == 3'd4)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;
        end
    end

    // Sequential pipeline control process
    always @(posedge clk) begin
        if (rst) begin
            // Reset all registers and outputs
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_is_zero <= 1'b0; a_is_inf <= 1'b0; a_is_nan <= 1'b0;
            b_is_zero <= 1'b0; b_is_inf <= 1'b0; b_is_nan <= 1'b0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            product <= 48'd0;
            exp_sum <= 10'd0;
            mant_norm <= 24'd0;
            exp_norm <= 10'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            mant_rounded <= 25'd0;
            exp_rounded <= 10'd0;
            sign <= 1'b0;
            a_is_zero_reg <= 1'b0; b_is_zero_reg <= 1'b0; a_is_inf_reg <= 1'b0; b_is_inf_reg <= 1'b0; a_is_nan_reg <= 1'b0; b_is_nan_reg <= 1'b0;
            z <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Input decode and special case detection
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Special cases
                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas with implicit bit for normalized numbers
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Sign calculation (XOR)
                    sign <= a[31] ^ b[31];

                    // Save special flags for next stages
                    a_is_zero_reg <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero_reg <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    a_is_inf_reg <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf_reg <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    a_is_nan_reg <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_is_nan_reg <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);
                end

                3'd1: begin
                    // Mantissa multiplication and exponent addition
                    product <= a_mantissa * b_mantissa; // 24x24 -> 48 bits

                    // Exponent sum (10-bit) with bias subtraction
                    // Note: handle zero exponents as denormals (exponent 0 means bias is 0 for them)
                    exp_sum <= (a_exp == 8'd0 ? 10'd1 : a_exp) + (b_exp == 8'd0 ? 10'd1 : b_exp) - EXP_BIAS;

                    // Sign and special flags passed through remain constant
                end

                3'd2: begin
                    // Normalization and rounding bits extraction
                    if (product[47]) begin
                        // MSB set: shift right one and increment exponent
                        mant_norm <= product[47:24];
                        exp_norm <= exp_sum + 10'd1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB not set: mantissa normal as is
                        mant_norm <= product[46:23];
                        exp_norm <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end

                3'd3: begin
                    // Rounding (round to nearest even)
                    // Round increment if guard=1 and (round=1 or sticky=1 or LSB=1)
                    if (guard_bit && (round_bit || sticky_bit || mant_norm[0])) begin
                        mant_rounded <= mant_norm + 25'd1;
                    end else begin
                        mant_rounded <= mant_norm;
                    end

                    exp_rounded <= exp_norm;
                end

                3'd4: begin
                    // Final normalization after rounding and output assembly
                    // Check for mantissa overflow after rounding
                    reg [7:0] final_exp;
                    reg [22:0] final_frac;
                    reg final_sign;
                    final_sign = sign;

                    if (mant_rounded[24]) begin
                        // Mantissa overflow - shift right, increment exponent
                        final_exp = exp_rounded[7:0] + 8'd1;
                        final_frac = mant_rounded[24:2]; // drop 2 bits (round bit + sticky)
                    end else begin
                        final_exp = exp_rounded[7:0];
                        final_frac = mant_rounded[22:0];
                    end

                    // Handle special cases with priority
                    if (a_is_nan_reg || b_is_nan_reg) begin
                        // Quiet NaN: exponent all ones and mantissa with MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_is_inf_reg && b_is_zero_reg) || (b_is_inf_reg && a_is_zero_reg)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf_reg || b_is_inf_reg) begin
                        // Inf times non-zero = Inf
                        z <= {final_sign, 8'hFF, 23'd0};
                    end else if (a_is_zero_reg || b_is_zero_reg) begin
                        // Zero times anything = zero
                        z <= {final_sign, 31'd0};
                    end else begin
                        // Normal numbers exponent overflow/underflow check
                        if (final_exp >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {final_sign, 8'hFF, 23'd0};
                        end else if (final_exp <= 0) begin
                            // Underflow flush to zero
                            z <= {final_sign, 31'd0};
                        end else begin
                            // Normal result
                            z <= {final_sign, final_exp, final_frac};
                        end
                    end
                end

                default: begin
                    // Hold outputs stable
                    z <= z;
                end
            endcase
        end
    end
endmodule
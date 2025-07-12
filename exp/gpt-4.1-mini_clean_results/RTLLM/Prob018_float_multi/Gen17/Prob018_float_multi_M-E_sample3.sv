module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    // Parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam EXP_MIN  = 8'h00;

    // Internal registers for input fields
    reg         a_sign_r, b_sign_r;
    reg [7:0]   a_exp_r,  b_exp_r;
    reg [22:0]  a_frac_r, b_frac_r;

    // Registers for processed mantissas and exponents
    reg [23:0]  a_mantissa_r, b_mantissa_r;
    reg [9:0]   a_exp_adj_r, b_exp_adj_r; // extended to 10 bits for intermediate sums

    // Result sign, exponent and mantissa registers
    reg         res_sign_r;
    reg [9:0]   exp_sum_r;        // exponent sum before bias adjustment
    reg [47:0]  mantissa_product_r; // product of mantissas (48 bits)

    // Normalized mantissa and exponent registers
    reg [23:0]  norm_mantissa_r;
    reg [9:0]   norm_exponent_r;

    // Rounding bits registers
    reg         guard_bit_r, round_bit_r, sticky_bit_r;

    // Final mantissa and exponent after rounding
    reg [22:0]  final_mantissa_r;
    reg [9:0]   final_exponent_r;

    // Special cases flags latched
    reg         a_zero_r, a_denorm_r, a_inf_r, a_nan_r;
    reg         b_zero_r, b_denorm_r, b_inf_r, b_nan_r;

    // Operation cycle counter (0 to 4)
    reg [2:0] counter;

    // Sticky bit calculation during normalization step
    reg sticky_temp;

    // Combinational wires for next state and calculations
    wire [47:0] product_shifted;
    wire product_msb;
    wire round_increment;
    wire mantissa_carry;

    // Extract fields from inputs at cycle 0 (idle)
    wire a_sign = a[31];
    wire [7:0] a_exp = a[30:23];
    wire [22:0] a_frac = a[22:0];

    wire b_sign = b[31];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] b_frac = b[22:0];

    // Detect special cases combinationally on inputs
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire a_denorm = (a_exp == 8'd0) && (a_frac != 23'd0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);

    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire b_denorm = (b_exp == 8'd0) && (b_frac != 23'd0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // FSM implementation using counter
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear internal regs
            a_sign_r <= 1'b0;
            b_sign_r <= 1'b0;
            a_exp_r <= 8'd0;
            b_exp_r <= 8'd0;
            a_frac_r <= 23'd0;
            b_frac_r <= 23'd0;

            a_mantissa_r <= 24'd0;
            b_mantissa_r <= 24'd0;

            a_exp_adj_r <= 10'd0;
            b_exp_adj_r <= 10'd0;

            res_sign_r <= 1'b0;

            exp_sum_r <= 10'd0;

            mantissa_product_r <= 48'd0;

            norm_mantissa_r <= 24'd0;
            norm_exponent_r <= 10'd0;

            guard_bit_r <= 1'b0;
            round_bit_r <= 1'b0;
            sticky_bit_r <= 1'b0;

            final_mantissa_r <= 23'd0;
            final_exponent_r <= 10'd0;

            a_zero_r <= 1'b0;
            a_denorm_r <= 1'b0;
            a_inf_r <= 1'b0;
            a_nan_r <= 1'b0;

            b_zero_r <= 1'b0;
            b_denorm_r <= 1'b0;
            b_inf_r <= 1'b0;
            b_nan_r <= 1'b0;

        end else begin
            case (counter)
                3'd0: begin
                    // Idle: wait for inputs, start operation by capturing inputs and special cases
                    // Capture inputs and prepare mantissas
                    a_sign_r <= a_sign;
                    b_sign_r <= b_sign;
                    a_exp_r <= a_exp;
                    b_exp_r <= b_exp;
                    a_frac_r <= a_frac;
                    b_frac_r <= b_frac;

                    a_zero_r <= a_zero;
                    a_denorm_r <= a_denorm;
                    a_inf_r <= a_inf;
                    a_nan_r <= a_nan;

                    b_zero_r <= b_zero;
                    b_denorm_r <= b_denorm;
                    b_inf_r <= b_inf;
                    b_nan_r <= b_nan;

                    // Prepare mantissas with implicit leading 1 for normal numbers
                    a_mantissa_r <= (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa_r <= (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Adjust exponents for denormals to 1 for calculation
                    a_exp_adj_r <= (a_exp == 0) ? 10'd1 : {2'd0, a_exp};
                    b_exp_adj_r <= (b_exp == 0) ? 10'd1 : {2'd0, b_exp};

                    // Calculate result sign
                    res_sign_r <= a_sign ^ b_sign;

                    // Reset outputs (will update later)
                    z <= 32'd0;

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Multiply mantissas (24x24 bits)
                    mantissa_product_r <= a_mantissa_r * b_mantissa_r;

                    // Sum exponents and subtract bias (performed with extended widths)
                    exp_sum_r <= a_exp_adj_r + b_exp_adj_r - EXP_BIAS;

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Normalize mantissa product
                    // If MSB=1 (bit 47), product >= 2.0 => shift right 1 and increment exponent
                    if (mantissa_product_r[47]) begin
                        norm_mantissa_r <= mantissa_product_r[47:24];
                        norm_exponent_r <= exp_sum_r + 10'd1;
                        guard_bit_r <= mantissa_product_r[23];
                        round_bit_r <= mantissa_product_r[22];
                        sticky_bit_r <= |mantissa_product_r[21:0];
                    end else begin
                        // product < 2.0, shift left 1 (equivalent to multiplying mantissa by 2) and decrement exponent accordingly
                        norm_mantissa_r <= mantissa_product_r[46:23];
                        norm_exponent_r <= exp_sum_r;
                        guard_bit_r <= mantissa_product_r[22];
                        round_bit_r <= mantissa_product_r[21];
                        sticky_bit_r <= |mantissa_product_r[20:0];
                    end

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Rounding: round to nearest even

                    // Round increment logic:
                    // Increment if guard bit = 1 and (round bit = 1 or sticky bit =1 or LSB of mantissa =1)
                    sticky_temp = sticky_bit_r;
                    // Determine if rounding increment needed
                    if (guard_bit_r && (round_bit_r || sticky_temp || norm_mantissa_r[0])) begin
                        // Add 1 to mantissa
                        {mantissa_carry, final_mantissa_r} <= {1'b0, norm_mantissa_r[22:0]} + 23'd1;
                    end else begin
                        mantissa_carry <= 1'b0;
                        final_mantissa_r <= norm_mantissa_r[22:0];
                    end

                    // Adjust exponent based on carry
                    if (mantissa_carry) begin
                        final_exponent_r <= norm_exponent_r + 10'd1;
                    end else begin
                        final_exponent_r <= norm_exponent_r;
                    end

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Output generation including special cases

                    // Determine if overflow or underflow on exponent
                    // Use adjusted exponent to check IEEE-754 limits
                    reg exponent_overflow, exponent_underflow;
                    exponent_overflow = (final_exponent_r >= 10'd255);
                    exponent_underflow = (final_exponent_r <= 10'd0);

                    // Output register to hold result
                    if (a_nan_r || b_nan_r) begin
                        // NaN: quiet NaN: sign=0, exp=0xFF, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf_r && b_zero_r) || (b_inf_r && a_zero_r)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf_r || b_inf_r) begin
                        // Inf * non-zero = Inf with sign
                        z <= {res_sign_r, 8'hFF, 23'd0};
                    end else if (a_zero_r || b_zero_r) begin
                        // zero * anything = zero with sign
                        z <= {res_sign_r, 31'd0};
                    end else if (exponent_overflow) begin
                        // Overflow => Inf
                        z <= {res_sign_r, 8'hFF, 23'd0};
                    end else if (exponent_underflow) begin
                        // Underflow => flush to zero
                        z <= {res_sign_r, 31'd0};
                    end else begin
                        // Normal result
                        z <= {res_sign_r, final_exponent_r[7:0], final_mantissa_r};
                    end

                    // After producing output, reset counter to wait for new inputs
                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule
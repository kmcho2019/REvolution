module float_multi(
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    // Internal pipeline stage counter (0 to 4)
    reg [2:0] counter;

    // Input sign, exponent, mantissa
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [23:0] a_mantissa, b_mantissa;

    // Exponent sum adjusted for bias subtraction, 10 bits to accommodate overflow
    reg [9:0] exponent_sum;

    // Output sign
    reg z_sign;

    // Product registers for sequential multiplication (48-bit product)
    reg [47:0] product;
    reg [11:0] mult_step;         // For sequential multiplication steps (two 12-bit chunks)
    reg [23:0] multiplicand;      // Multiplier multiplicand (a_mantissa)
    reg [23:0] multiplier;        // Multiplier multiplier (b_mantissa)

    reg mult_busy;                // Indicates if multiplication is in progress

    // Normalized product and rounding bits
    reg [47:0] norm_product;
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;

    // Mantissa before rounding (24 bits including implicit leading 1)
    reg [23:0] mantissa_pre_round;

    // Flags for special numbers
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Constants
    localparam EXP_BIAS = 127;

    // Extract fields (combinational)
    wire [7:0] a_exp_wire = a[30:23];
    wire [7:0] b_exp_wire = b[30:23];
    wire [22:0] a_frac_wire = a[22:0];
    wire [22:0] b_frac_wire = b[22:0];
    wire a_sign_wire = a[31];
    wire b_sign_wire = b[31];

    // Detect special cases (combinational)
    wire a_is_zero = (a_exp_wire == 8'd0) && (a_frac_wire == 23'd0);
    wire b_is_zero = (b_exp_wire == 8'd0) && (b_frac_wire == 23'd0);
    wire a_is_inf = (a_exp_wire == 8'hFF) && (a_frac_wire == 23'd0);
    wire b_is_inf = (b_exp_wire == 8'hFF) && (b_frac_wire == 23'd0);
    wire a_is_nan = (a_exp_wire == 8'hFF) && (a_frac_wire != 23'd0);
    wire b_is_nan = (b_exp_wire == 8'hFF) && (b_frac_wire != 23'd0);

    // Sticky bit calculation helper (for sequential multiplication, accumulate sticky)
    reg sticky_accum;

    // Sequential multiplier: multiply a_mantissa * b_mantissa over 2 cycles
    // Split multiplier into two 12-bit chunks to multiply per cycle and accumulate partial sums

    // Internal signals for partial multiplication
    reg [35:0] partial_sum_stage0; // 24b * 12b max 36 bits
    reg [35:0] partial_sum_stage1; // second 12b chunk multiplication

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exponent <= 8'd0;
            b_exponent <= 8'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;

            exponent_sum <= 10'd0;
            z_sign <= 1'b0;

            product <= 48'd0;
            mult_step <= 12'd0;
            multiplicand <= 24'd0;
            multiplier <= 24'd0;

            mult_busy <= 1'b0;

            norm_product <= 48'd0;
            norm_exponent <= 10'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            mantissa_pre_round <= 24'd0;

            a_zero <= 1'b0;
            b_zero <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;

            sticky_accum <= 1'b0;

            partial_sum_stage0 <= 36'd0;
            partial_sum_stage1 <= 36'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Cycle 0: Capture inputs and flags
                    a_sign <= a_sign_wire;
                    b_sign <= b_sign_wire;

                    a_exponent <= a_exp_wire;
                    b_exponent <= b_exp_wire;

                    // Handle mantissas with implicit leading 1 if normalized, else denormals
                    a_mantissa <= (a_exp_wire == 8'd0) ? {1'b0, a_frac_wire} : {1'b1, a_frac_wire};
                    b_mantissa <= (b_exp_wire == 8'd0) ? {1'b0, b_frac_wire} : {1'b1, b_frac_wire};

                    // Special case flags
                    a_zero <= a_is_zero;
                    b_zero <= b_is_zero;
                    a_inf <= a_is_inf;
                    b_inf <= b_is_inf;
                    a_nan <= a_is_nan;
                    b_nan <= b_is_nan;

                    // Calculate sign of the result
                    z_sign <= a_sign_wire ^ b_sign_wire;

                    // Initialize exponent sum (10 bits)
                    exponent_sum <= a_exp_wire + b_exp_wire - EXP_BIAS;

                    // Prepare for sequential multiplication
                    multiplicand <= (a_exp_wire == 8'd0) ? {1'b0, a_frac_wire} : {1'b1, a_frac_wire}; 
                    multiplier <= (b_exp_wire == 8'd0) ? {1'b0, b_frac_wire} : {1'b1, b_frac_wire};

                    product <= 48'd0;
                    mult_step <= 12'd0;
                    mult_busy <= 1'b1;

                    sticky_accum <= 1'b0;

                    // Clear partial sums
                    partial_sum_stage0 <= 36'd0;
                    partial_sum_stage1 <= 36'd0;

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Cycle 1: Multiply lower 12 bits of multiplier * multiplicand
                    // multiplier[11:0] * multiplicand -> 36 bits partial sum
                    partial_sum_stage0 <= multiplicand * multiplier[11:0];
                    mult_step <= 12'd12; // offset for shifting partial sum when adding next

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Cycle 2: Multiply upper 12 bits of multiplier * multiplicand and accumulate
                    partial_sum_stage1 <= multiplicand * multiplier[23:12];

                    // Combine partial products:
                    // partial_sum_stage1 shifted by 12 bits + partial_sum_stage0
                    product <= {12'd0, partial_sum_stage0} + (partial_sum_stage1 << 12);

                    mult_busy <= 1'b0;
                    counter <= 3'd3;
                end

                3'd3: begin
                    // Cycle 3: Normalize product and determine rounding bits

                    // Check if MSB (bit 47) is 1; if yes, shift right by 1 and increment exponent
                    if (product[47] == 1'b1) begin
                        norm_product <= product >> 1;
                        norm_exponent <= exponent_sum + 10'd1;
                    end else begin
                        norm_product <= product;
                        norm_exponent <= exponent_sum;
                    end

                    // Extract mantissa 24 bits (leading 1 explicit) bits [46:23]
                    mantissa_pre_round <= norm_product[46:23];

                    // Extract rounding bits
                    guard_bit <= norm_product[22];
                    round_bit <= norm_product[21];
                    sticky_bit <= |norm_product[20:0];

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Cycle 4: Rounding and final assembly

                    // Round to nearest even
                    // Round up if guard=1 and (round=1 or sticky=1 or LSB=1)
                    reg round_increment;
                    round_increment = 1'b0;

                    if (guard_bit) begin
                        if (round_bit || sticky_bit || (mantissa_pre_round[0] == 1'b1)) begin
                            round_increment = 1'b1;
                        end
                    end

                    reg [24:0] mantissa_rounded;
                    mantissa_rounded = {1'b0, mantissa_pre_round} + round_increment;

                    reg [7:0] final_exponent;
                    reg final_sign;
                    reg [22:0] final_fraction;

                    final_sign = z_sign;

                    // Check if rounding overflowed mantissa (carry out)
                    if (mantissa_rounded[24]) begin
                        // Mantissa overflow: shift right by 1, increment exponent
                        final_exponent = norm_exponent[7:0] + 1;
                        final_fraction = mantissa_rounded[23:1];
                    end else begin
                        final_exponent = norm_exponent[7:0];
                        final_fraction = mantissa_rounded[22:0];
                    end

                    // Handle special cases
                    if (a_nan || b_nan) begin
                        // Output quiet NaN (exponent all ones, mantissa non-zero MSB=1)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 => NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Inf * non-zero => Inf with sign
                        z <= {final_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero * anything = zero with sign
                        z <= {final_sign, 31'd0};
                    end else begin
                        // Normal/Denormal result

                        if (final_exponent >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {final_sign, 8'hFF, 23'd0};
                        end else if (final_exponent <= 0) begin
                            // Underflow to zero (no gradual underflow implemented)
                            z <= {final_sign, 31'd0};
                        end else begin
                            z <= {final_sign, final_exponent, final_fraction};
                        end
                    end

                    // Prepare for next operation
                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule
module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Inputs decomposition registers
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    // Extended exponent for internal computation
    reg [9:0] a_exp_ext, b_exp_ext;

    // Mantissa registers with implicit leading 1 or 0 if denormal
    reg [23:0] a_mantissa, b_mantissa;

    // Sign of the result
    reg z_sign;

    // Flags for special cases
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Intermediate product registers for iterative multiply
    reg [47:0] product;         // 48-bit product: accumulator
    reg [23:0] multiplicand;    // Holds one multiplicand
    reg [23:0] multiplier;      // Holds the other multiplicand (bits processed one by one)
    reg [4:0]  mul_bit_index;   // Index of current multiplier bit (0..23)

    // Intermediate exponent
    reg [9:0] exp_sum;

    // Normalization and rounding registers
    reg product_msb;
    reg [23:0] mantissa_norm;
    reg [9:0] exponent_norm;
    reg guard_bit, round_bit, sticky_bit;

    // Rounding addition and final mantissa / exponent
    reg round_increment;
    reg [24:0] mantissa_rounded_pre; // 25 bits to hold rounding overflow
    reg mantissa_overflow;

    reg [7:0] final_exp;
    reg [22:0] final_frac;

    // Special case result register
    reg special_result_valid;
    reg [31:0] special_result;

    // Output next value register
    reg [31:0] z_next;

    // Sticky bit accumulation for rounding
    reg sticky_accum;

    // FSM and computation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear internal states
            product <= 48'd0;
            multiplicand <= 24'd0;
            multiplier <= 24'd0;
            mul_bit_index <= 5'd0;
            sticky_accum <= 1'b0;
            special_result_valid <= 1'b0;
            special_result <= 32'd0;
        end else begin
            case(counter)
                3'd0: begin
                    // Input capture and special cases detection
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Calculate sign output
                    z_sign <= a[31] ^ b[31];

                    // Prepare extended exponents with denormal handling:
                    // For denormals (exponent==0), exponent is 1 and mantissa no leading 1
                    if ((a[30:23] == 8'd0))
                        a_exp_ext <= 10'd1;
                    else
                        a_exp_ext <= {2'b00, a[30:23]};
                    if ((b[30:23] == 8'd0))
                        b_exp_ext <= 10'd1;
                    else
                        b_exp_ext <= {2'b00, b[30:23]};

                    // Prepare mantissas with implicit leading 1 if normalized
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Initialize mantissa multiplication registers:
                    // We'll iterate over multiplier bits (b_mantissa), add multiplicand shifted accordingly to product
                    multiplicand <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    multiplier <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    product <= 48'd0;
                    mul_bit_index <= 5'd0;
                    sticky_accum <= 1'b0;

                    // Pre-calculate exponent sum without bias subtracted yet
                    exp_sum <= a_exp_ext + b_exp_ext - EXP_BIAS;

                    // Clear special_result flag
                    special_result_valid <= 1'b0;

                    // Check special cases now:
                    // NaN has top priority
                    if (a_nan || b_nan) begin
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
                        special_result_valid <= 1'b1;
                    end else if (((a_inf && b_zero) || (b_inf && a_zero))) begin
                        // inf * zero = NaN
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        special_result_valid <= 1'b1;
                    end else if (a_inf || b_inf) begin
                        // inf * non-zero = inf
                        special_result <= {z_sign, 8'hFF, 23'd0};
                        special_result_valid <= 1'b1;
                    end else if (a_zero || b_zero) begin
                        // zero * anything = zero
                        special_result <= {z_sign, 31'd0};
                        special_result_valid <= 1'b1;
                    end

                    // If special case detected, we skip multiplication
                    if (special_result_valid) begin
                        z_next <= special_result;
                        counter <= 3'd3; // move to output stage directly
                    end else begin
                        counter <= 3'd1; // proceed to iterative multiplication
                    end
                end

                3'd1: begin
                    // Iterative multiplication using shift-and-add (one bit per cycle)
                    // Check current multiplier bit:
                    if (multiplier[0]) begin
                        // Add multiplicand shifted by bit index to product:
                        // product is 48 bits: low 24 bits zero initially
                        // product += multiplicand << mul_bit_index
                        // Since we add one bit per cycle, add shifted multiplicand to product
                        // Use a temporary addition

                        // Shift multiplicand by mul_bit_index
                        // We perform addition here combinationally within the always block
                        product <= product + ({{24'd0}, multiplicand} << mul_bit_index);
                    end

                    // Update sticky_accum for bits beyond current bit index (for rounding)
                    // Sticky bit includes any 1s in remaining bits (for later use)
                    if (mul_bit_index == 23) begin
                        // Last bit processed, sticky accumulates no more bits
                        sticky_accum <= 1'b0;
                    end else begin
                        // sticky accumulates OR of all remaining multiplier bits excluding current and lower
                        sticky_accum <= sticky_accum | (| (multiplier >> (mul_bit_index + 1)));
                    end

                    // Shift multiplier right for next bit processing (for the sake of clarity)
                    // We'll keep original multiplier intact, we rely on bit index to select bits, so no shift here
                    mul_bit_index <= mul_bit_index + 1'b1;

                    if (mul_bit_index == 23) begin
                        // Multiplication complete
                        counter <= 3'd2;
                    end else begin
                        counter <= 3'd1; // continue multiplication
                    end
                end

                3'd2: begin
                    // Normalization and rounding stage

                    // Check product MSB (bit 47)
                    product_msb <= product[47];

                    // Determine normalization shift
                    if (product[47]) begin
                        mantissa_norm <= product[47:24];
                        exponent_norm <= exp_sum + 10'd1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // Shift left by 1
                        mantissa_norm <= product[46:23];
                        exponent_norm <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    // Round to nearest even
                    round_increment <= guard_bit & (round_bit | sticky_bit | mantissa_norm[0]);

                    // Add rounding increment
                    mantissa_rounded_pre <= {1'b0, mantissa_norm} + round_increment;

                    // Check overflow from rounding
                    mantissa_overflow <= mantissa_rounded_pre[24];

                    // Adjust exponent and fraction accordingly
                    final_exp <= mantissa_overflow ? (exponent_norm[7:0] + 8'd1) : exponent_norm[7:0];
                    final_frac <= mantissa_overflow ? mantissa_rounded_pre[24:2] : mantissa_rounded_pre[22:0];

                    counter <= 3'd3; // move to output packaging
                end

                3'd3: begin
                    // Output packaging stage
                    // Handle overflow, underflow, and normal number

                    // For special cases, output directly
                    if (special_result_valid) begin
                        z_next <= special_result;
                    end else begin
                        // Check overflow and underflow
                        if (final_exp >= 8'hFF) begin
                            // Overflow to infinity
                            z_next <= {z_sign, 8'hFF, 23'd0};
                        end else if (final_exp <= 0) begin
                            // Underflow to zero (no subnormals supported)
                            z_next <= {z_sign, 31'd0};
                        end else begin
                            // Normal output
                            z_next <= {z_sign, final_exp, final_frac};
                        end
                    end

                    z <= z_next;
                    counter <= 3'd0; // Ready for next inputs
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule
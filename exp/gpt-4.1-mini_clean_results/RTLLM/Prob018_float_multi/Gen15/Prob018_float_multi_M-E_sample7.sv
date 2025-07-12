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

    // Internal cycle counter (3 states: 0,1,2)
    reg [2:0] counter;

    // Internal registers for operands decomposition
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [22:0] a_fraction, b_fraction;

    // Special flags for inputs
    reg a_is_zero, a_is_denorm, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_denorm, b_is_inf, b_is_nan;

    // Internal registers for computation
    reg [23:0] a_mantissa; // 1 + 23 bits
    reg [23:0] b_mantissa;

    reg [47:0] product;      // 24x24 multiplication product
    reg [9:0] exponent_sum;  // extended exponent sum (to avoid overflow)

    // Normalized mantissa and exponent after shift if needed
    reg [47:0] norm_product;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and final exponent
    reg [24:0] rounded_mantissa;
    reg mantissa_carry;

    // Final sign
    reg result_sign;

    // Internal signal for special cases result
    reg [31:0] special_result;
    reg special_case_active;

    // Helper function: count sticky bits from lower product bits
    function sticky_from;
        input [21:0] bits;
        integer i;
        begin
            sticky_from = 1'b0;
            for (i=0; i<22; i=i+1) begin
                if (bits[i]) sticky_from = 1'b1;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            // Reset all registers and outputs
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exponent <= 8'd0; b_exponent <= 8'd0;
            a_fraction <= 23'd0; b_fraction <= 23'd0;

            a_is_zero <= 1'b0; a_is_denorm <= 1'b0; a_is_inf <= 1'b0; a_is_nan <= 1'b0;
            b_is_zero <= 1'b0; b_is_denorm <= 1'b0; b_is_inf <= 1'b0; b_is_nan <= 1'b0;

            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            product <= 48'd0;
            exponent_sum <= 10'd0;
            norm_product <= 48'd0;
            norm_exponent <= 10'd0;

            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            rounded_mantissa <= 25'd0;
            mantissa_carry <= 1'b0;
            result_sign <= 1'b0;

            special_result <= 32'd0;
            special_case_active <= 1'b0;

        end else begin
            case(counter)
                3'd0: begin
                    // Stage 0: Decompose inputs, detect special cases, prepare mantissas
                    a_sign <= a[31];
                    b_sign <= b[31];

                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];

                    a_fraction <= a[22:0];
                    b_fraction <= b[22:0];

                    // Detect special cases for a
                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    a_is_denorm <= (a[30:23] == 8'd0) && (a[22:0] != 23'd0);
                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

                    // Detect special cases for b
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    b_is_denorm <= (b[30:23] == 8'd0) && (b[22:0] != 23'd0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas
                    // For normal numbers: implicit leading 1
                    // For denormals and zeros: implicit leading 0, mantissa is fraction
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Reset special case flag
                    special_case_active <= 1'b0;
                    special_result <= 32'd0;

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Stage 1: Multiply mantissas, sum exponents, normalize
                    // Compute sign
                    result_sign <= a_sign ^ b_sign;

                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa;

                    // Calculate exponent sum:
                    // For denormals exponent treated as 1 (instead of 0)
                    // Use 10 bits to avoid overflow
                    exponent_sum <= 
                        ((a_exponent == 8'd0) ? 10'd1 : {2'd0,a_exponent}) + 
                        ((b_exponent == 8'd0) ? 10'd1 : {2'd0,b_exponent}) - 
                        EXP_BIAS;

                    // Normalize product:
                    // If MSB (bit 47) == 1 => product >= 2, shift right 1 and add 1 to exponent
                    if (product[47] == 1'b1) begin
                        norm_product <= product;
                        norm_exponent <= exponent_sum + 10'd1;
                    end else begin
                        norm_product <= product << 1;
                        norm_exponent <= exponent_sum;
                    end

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Stage 2: Rounding and special case handling

                    // Extract rounding bits from norm_product:
                    guard_bit <= norm_product[23];
                    round_bit <= norm_product[22];
                    sticky_bit <= (|norm_product[21:0]) ? 1'b1 : 1'b0;

                    // Prepare mantissa for rounding (24 bits: leading + fraction)
                    rounded_mantissa <= {1'b0, norm_product[47:24]};

                    // Round-to-nearest-even:
                    // Round increment if guard=1 and (round=1 or sticky=1 or LSB=1)
                    if (guard_bit && (round_bit || sticky_bit || norm_product[24])) begin
                        rounded_mantissa <= rounded_mantissa + 25'd1;
                    end

                    mantissa_carry <= (rounded_mantissa[24] == 1'b1);

                    // Adjust exponent if carry from rounding
                    if (mantissa_carry) begin
                        norm_exponent <= norm_exponent + 10'd1;
                    end

                    // Special case checks
                    special_case_active <= 1'b0;

                    if (a_is_nan || b_is_nan) begin
                        // Return quiet NaN
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        special_case_active <= 1'b1;
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * zero = NaN
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        special_case_active <= 1'b1;
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * non-zero => Inf with correct sign
                        special_result <= {result_sign, 8'hFF, 23'd0};
                        special_case_active <= 1'b1;
                    end else if (a_is_zero || b_is_zero) begin
                        // zero * anything = zero with sign
                        special_result <= {result_sign, 31'd0};
                        special_case_active <= 1'b1;
                    end

                    // Now finalize the result if no special case
                    if (!special_case_active) begin
                        // Check exponent overflow or underflow
                        if (norm_exponent >= 10'd255) begin
                            // Overflow: return Inf with sign
                            special_result <= {result_sign, 8'hFF, 23'd0};
                            special_case_active <= 1'b1;
                        end else if (norm_exponent <= 10'd0) begin
                            // Underflow: flush to zero
                            special_result <= {result_sign, 31'd0};
                            special_case_active <= 1'b1;
                        end else begin
                            // Normal case: assemble result
                            // Mantissa is 23 bits, rounded_mantissa bits [23:1] after carry check
                            special_result <= {result_sign, norm_exponent[7:0], rounded_mantissa[23:1]};
                        end
                    end

                    // Update output register
                    z <= special_result;

                    // Move counter back to 0 for next multiplication
                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end
endmodule
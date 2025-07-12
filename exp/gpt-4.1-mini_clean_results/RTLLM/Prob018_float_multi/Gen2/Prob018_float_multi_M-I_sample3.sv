module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    // Parameters
    localparam EXP_BITS = 8;
    localparam MANT_BITS = 23;
    localparam BIAS = 127;

    // Internal registers and wires
    reg [2:0] counter;

    // Registers to hold extracted fields
    reg a_sign, b_sign;
    reg [EXP_BITS-1:0] a_exponent, b_exponent;
    reg [MANT_BITS-1:0] a_fraction, b_fraction;

    // Extended exponent width for internal calculation (10-bit for overflow detection)
    reg [9:0] z_exponent;

    // Mantissas with implicit leading 1 or zero if subnormal
    reg [23:0] a_mantissa, b_mantissa;

    // Mantissa product (24x24)
    reg [47:0] product;

    // Sign of result
    reg z_sign;

    // Flags for special cases detected
    reg a_exp_all_ones, b_exp_all_ones;
    reg a_exp_zero, b_exp_zero;
    reg a_frac_zero, b_frac_zero;

    reg a_is_nan, b_is_nan, a_is_inf, b_is_inf, a_is_zero, b_is_zero;
    reg inf_zero_case;
    reg is_nan, is_inf, is_zero;

    // Normalized mantissa after product shift and exponent adjustment
    reg product_msb;
    reg [24:0] normalized_mantissa;
    reg [47:0] mantissa_for_rounding;
    reg [9:0] normalized_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg round_increment;
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_overflow;
    reg [24:0] rounded_mantissa;
    reg [9:0] rounded_exp;

    // Final output mantissa and exponent registers (before output)
    reg [7:0] final_exp;
    reg [22:0] final_mantissa;
    reg final_sign;

    // Sticky bit calculation helper
    function sticky_calc;
        input [20:0] bits;
        integer i;
        begin
            sticky_calc = 1'b0;
            for (i=0; i<21; i=i+1)
                sticky_calc = sticky_calc | bits[i];
        end
    endfunction

    // Counter and main sequential process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
            // Clear internal registers
            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_fraction <= 0;
            b_fraction <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            product <= 0;
            z_sign <= 0;
            z_exponent <= 0;
            normalized_mantissa <= 0;
            mantissa_for_rounding <= 0;
            normalized_exp <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;
            round_increment <= 0;
            rounded_mantissa_pre <= 0;
            mantissa_overflow <= 0;
            rounded_mantissa <= 0;
            rounded_exp <= 0;
            final_exp <= 0;
            final_mantissa <= 0;
            final_sign <= 0;
            a_exp_all_ones <= 0;
            b_exp_all_ones <= 0;
            a_exp_zero <= 0;
            b_exp_zero <= 0;
            a_frac_zero <= 0;
            b_frac_zero <= 0;
            a_is_nan <= 0;
            b_is_nan <= 0;
            a_is_inf <= 0;
            b_is_inf <= 0;
            a_is_zero <= 0;
            b_is_zero <= 0;
            inf_zero_case <= 0;
            is_nan <= 0;
            is_inf <= 0;
            is_zero <= 0;
        end else begin
            counter <= counter + 1;

            case (counter)
                3'd0: begin
                    // Load inputs and extract fields
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_fraction <= a[22:0];
                    b_fraction <= b[22:0];
                    // Reset output register (could hold previous result or clear)
                    // z <= 32'b0; // hold old until final
                end

                3'd1: begin
                    // Special cases detection
                    a_exp_all_ones <= (a_exponent == 8'hFF);
                    b_exp_all_ones <= (b_exponent == 8'hFF);
                    a_exp_zero <= (a_exponent == 8'h00);
                    b_exp_zero <= (b_exponent == 8'h00);
                    a_frac_zero <= (a_fraction == 0);
                    b_frac_zero <= (b_fraction == 0);

                    a_is_nan <= (a_exp_all_ones && (a_fraction != 0));
                    b_is_nan <= (b_exp_all_ones && (b_fraction != 0));
                    a_is_inf <= (a_exp_all_ones && (a_fraction == 0));
                    b_is_inf <= (b_exp_all_ones && (b_fraction == 0));
                    a_is_zero <= (a_exp_zero && a_frac_zero);
                    b_is_zero <= (b_exp_zero && b_frac_zero);

                    inf_zero_case <= ( (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero) );
                    is_nan <= (a_is_nan || b_is_nan || inf_zero_case);
                    is_inf <= ((!inf_zero_case) && (a_is_inf || b_is_inf));
                    is_zero <= ((!is_nan && !is_inf) && (a_is_zero || b_is_zero));

                    // Prepare mantissas: implicit leading 1 for normals, 0 for subnormals
                    a_mantissa <= a_exp_zero ? {1'b0, a_fraction} : {1'b1, a_fraction};
                    b_mantissa <= b_exp_zero ? {1'b0, b_fraction} : {1'b1, b_fraction};

                    // Result sign
                    z_sign <= a_sign ^ b_sign;
                end

                3'd2: begin
                    // Multiply mantissas (24x24)
                    product <= a_mantissa * b_mantissa;

                    // Exponent sum (with bias subtraction)
                    // Use signed arithmetic to handle underflow easily
                    // Exponent sum = a_exp + b_exp - bias
                    z_exponent <= ( {2'b00, a_exponent} + {2'b00, b_exponent} ) - BIAS;
                end

                3'd3: begin
                    // Normalize product and adjust exponent
                    product_msb <= product[47];
                    if (product[47]) begin
                        normalized_mantissa <= product[47:23]; // top 25 bits
                        mantissa_for_rounding <= product;
                        normalized_exp <= z_exponent + 1; // because MSB at 47 means shift right 0 => exponent +1
                    end else begin
                        normalized_mantissa <= product[46:22]; // shifted left by 1 normalization
                        mantissa_for_rounding <= product << 1;
                        normalized_exp <= z_exponent;
                    end
                end

                3'd4: begin
                    // Extract rounding bits
                    guard_bit <= mantissa_for_rounding[22];
                    round_bit <= mantissa_for_rounding[21];
                    sticky_bit <= sticky_calc(mantissa_for_rounding[20:0]);

                    // Round to nearest even
                    round_increment <= (guard_bit && (round_bit | sticky_bit | normalized_mantissa[0]));
                    rounded_mantissa_pre <= normalized_mantissa + round_increment;
                end

                3'd5: begin
                    mantissa_overflow <= rounded_mantissa_pre[24];
                    if (rounded_mantissa_pre[24]) begin
                        rounded_mantissa <= rounded_mantissa_pre >> 1;
                        rounded_exp <= normalized_exp + 1;
                    end else begin
                        rounded_mantissa <= rounded_mantissa_pre;
                        rounded_exp <= normalized_exp;
                    end

                    // Final exponent and mantissa with overflow/underflow and special cases
                    // Handle special cases first
                    if (is_nan) begin
                        final_exp <= 8'hFF;
                        final_mantissa <= 23'h400000; // Quiet NaN (MSB mantissa=1)
                        final_sign <= 1'b0; // IEEE NaN sign usually zero
                    end else if (is_inf) begin
                        final_exp <= 8'hFF;
                        final_mantissa <= 23'b0;
                        final_sign <= z_sign;
                    end else if (is_zero) begin
                        final_exp <= 8'b0;
                        final_mantissa <= 23'b0;
                        final_sign <= z_sign;
                    end else begin
                        // Normal or subnormal case:
                        // Check overflow
                        if (rounded_exp[9] == 1'b1 || rounded_exp >= 10'd255) begin
                            // Overflow => Infinity
                            final_exp <= 8'hFF;
                            final_mantissa <= 23'b0;
                            final_sign <= z_sign;
                        end else if (rounded_exp <= 0) begin
                            // Underflow => produce subnormal or zero with gradual underflow
                            // Shift mantissa right by 1 - rounded_exp to denormalize
                            // Only if rounded_exp >= -23 (mantissa bits)
                            if (rounded_exp >= -23) begin
                                // Calculate shift amount
                                // Use arithmetic shift right with zero fill by manual shift
                                integer shift_amt;
                                reg [24:0] shifted_mantissa;
                                shift_amt = 1 - rounded_exp; // >=1
                                shifted_mantissa = rounded_mantissa >> shift_amt;
                                // If bits shifted out are non-zero, sticky bit = 1
                                // To keep logic simple, set mantissa directly
                                final_exp <= 8'b0;
                                final_mantissa <= shifted_mantissa[22:0];
                                final_sign <= z_sign;
                            end else begin
                                // Too small, flush to zero
                                final_exp <= 8'b0;
                                final_mantissa <= 23'b0;
                                final_sign <= z_sign;
                            end
                        end else begin
                            // Normal range
                            final_exp <= rounded_exp[7:0];
                            final_mantissa <= rounded_mantissa[22:0];
                            final_sign <= z_sign;
                        end
                    end
                end

                3'd6: begin
                    // Output result
                    z <= {final_sign, final_exp, final_mantissa};
                end

                default: begin
                    // Hold output steady
                    z <= z;
                end
            endcase
        end
    end
endmodule
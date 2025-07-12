module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters for IEEE-754 single precision
    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;
    localparam EXP_MIN = 8'h00;

    // Internal state machine counter for sequencing
    reg [2:0] counter;

    // Stored input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special case flags for inputs
    reg a_zero, a_denorm, a_inf, a_nan;
    reg b_zero, b_denorm, b_inf, b_nan;

    // Computation registers
    reg res_sign;
    reg [9:0] a_exp_adj, b_exp_adj; // extended exponent for calculation (allow overflow)
    reg [9:0] exp_sum;
    reg [23:0] a_mantissa, b_mantissa;
    reg [47:0] product;              // 24x24 mantissa multiplication result

    // Normalization and rounding signals
    reg product_msb;
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;
    reg round_increment;
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [9:0] final_exponent_pre;
    reg exponent_overflow;
    reg exponent_underflow;
    reg [7:0] final_exponent;

    // Special case result register
    reg [31:0] special_result;
    reg special_case_flag;

    // Sticky bit calculation helper
    function sticky_calc;
        input [21:0] bits;
        integer i;
        begin
            sticky_calc = 1'b0;
            for (i=0; i<22; i=i+1)
                sticky_calc = sticky_calc | bits[i];
        end
    endfunction

    // Cycle-by-cycle operation
    always @(posedge clk) begin
        if (rst) begin
            // Reset all registers and output
            counter <= 3'd0;
            z <= 32'd0;
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_zero <= 1'b0; a_denorm <= 1'b0; a_inf <= 1'b0; a_nan <= 1'b0;
            b_zero <= 1'b0; b_denorm <= 1'b0; b_inf <= 1'b0; b_nan <= 1'b0;
            res_sign <= 1'b0;
            a_exp_adj <= 10'd0; b_exp_adj <= 10'd0;
            exp_sum <= 10'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            product <= 48'd0;
            product_msb <= 1'b0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            round_increment <= 1'b0;
            rounded_mantissa_pre <= 25'd0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 10'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            final_exponent <= 8'd0;
            special_result <= 32'd0;
            special_case_flag <= 1'b0;
        end else begin
            case(counter)
            3'd0: begin
                // Cycle 0: Extract and store inputs fields
                a_sign <= a[31];
                a_exp <= a[30:23];
                a_frac <= a[22:0];

                b_sign <= b[31];
                b_exp <= b[30:23];
                b_frac <= b[22:0];

                // Reset special flags for next computation
                special_case_flag <= 1'b0;

                counter <= counter + 1;
            end

            3'd1: begin
                // Cycle 1: Detect special cases for inputs
                a_zero <= (a_exp == 8'd0) && (a_frac == 23'd0);
                a_denorm <= (a_exp == 8'd0) && (a_frac != 23'd0);
                a_inf <= (a_exp == 8'hFF) && (a_frac == 23'd0);
                a_nan <= (a_exp == 8'hFF) && (a_frac != 23'd0);

                b_zero <= (b_exp == 8'd0) && (b_frac == 23'd0);
                b_denorm <= (b_exp == 8'd0) && (b_frac != 23'd0);
                b_inf <= (b_exp == 8'hFF) && (b_frac == 23'd0);
                b_nan <= (b_exp == 8'hFF) && (b_frac != 23'd0);

                // Compute result sign
                res_sign <= a[31] ^ b[31];

                // Prepare mantissas with implicit leading 1 for normal, 0 for denorm and zero
                a_mantissa <= (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
                b_mantissa <= (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

                // Adjust exponents for denormals: use exponent=1 for denormals
                a_exp_adj <= (a_exp == 0) ? 10'd1 : {2'b00, a_exp};
                b_exp_adj <= (b_exp == 0) ? 10'd1 : {2'b00, b_exp};

                counter <= counter + 1;
            end

            3'd2: begin
                // Cycle 2: Mantissa multiplication and exponent add/subtract bias
                product <= a_mantissa * b_mantissa; // 24x24=48 bits

                exp_sum <= a_exp_adj + b_exp_adj - EXP_BIAS;

                counter <= counter + 1;
            end

            3'd3: begin
                // Cycle 3: Normalize product and prepare rounding bits
                product_msb <= product[47];

                if (product[47]) begin
                    norm_mantissa <= product[47:24];  // keep upper 24 bits
                    norm_exponent <= exp_sum + 10'd1;
                end else begin
                    norm_mantissa <= product[46:23];  // shift left 1 is implicit by selecting bits
                    norm_exponent <= exp_sum;
                end

                // Rounding bits
                if (product[47]) begin
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_bit <= sticky_calc(product[21:0]);
                end else begin
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky_bit <= sticky_calc(product[20:0]);
                end

                counter <= counter + 1;
            end

            3'd4: begin
                // Cycle 4: Rounding and final exponent adjustment

                round_increment <= guard_bit && (round_bit || sticky_bit || norm_mantissa[0]);
                rounded_mantissa_pre <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);
                mantissa_carry <= rounded_mantissa_pre[24];

                if (mantissa_carry) begin
                    final_mantissa <= rounded_mantissa_pre[24:2];
                    final_exponent_pre <= norm_exponent + 10'd1;
                end else begin
                    final_mantissa <= rounded_mantissa_pre[22:0];
                    final_exponent_pre <= norm_exponent;
                end

                // Check exponent overflow and underflow
                exponent_overflow <= (final_exponent_pre >= 10'd255);
                exponent_underflow <= (final_exponent_pre <= 10'd0);

                final_exponent <= exponent_overflow ? 8'hFF :
                                  (exponent_underflow ? 8'd0 : final_exponent_pre[7:0]);

                counter <= counter + 1;
            end

            3'd5: begin
                // Cycle 5: Handle special cases and output assembly
                special_case_flag <= 1'b0;

                if (a_nan || b_nan) begin
                    // Output quiet NaN
                    special_result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    special_case_flag <= 1'b1;
                end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                    // Inf * 0 => NaN
                    special_result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    special_case_flag <= 1'b1;
                end else if (a_inf || b_inf) begin
                    // Inf * non-zero => Inf with sign
                    special_result <= {res_sign, 8'hFF, 23'd0};
                    special_case_flag <= 1'b1;
                end else if (a_zero || b_zero) begin
                    // Zero * anything => zero with sign
                    special_result <= {res_sign, 31'd0};
                    special_case_flag <= 1'b1;
                end

                // Output register update
                if (special_case_flag) begin
                    z <= special_result;
                end else if (exponent_overflow) begin
                    // Overflow => Inf
                    z <= {res_sign, 8'hFF, 23'd0};
                end else if (exponent_underflow) begin
                    // Underflow => zero
                    z <= {res_sign, 31'd0};
                end else begin
                    // Normal output
                    z <= {res_sign, final_exponent, final_mantissa};
                end

                // Cycle done: reset counter for next operation
                counter <= 3'd0;
            end

            default: begin
                // Safety reset
                counter <= 3'd0;
            end
            endcase
        end
    end

endmodule
module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // Counter to manage multi-cycle steps: 0,1,2 then wrap
    reg [2:0] counter;

    // Registers to hold extracted inputs and intermediate results
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    reg [23:0] a_mant, b_mant;  // with implicit bit

    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    reg sign; // output sign
    reg [9:0] exp_sum; // 10-bit for exponent sum and overflow
    reg [47:0] product; // product of mantissas

    // Normalized and rounded results
    reg [23:0] mantissa_rounded;
    reg [9:0] exponent_rounded;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;
    reg round_increment;

    // Special flags for output control
    reg special_nan;
    reg special_inf;
    reg special_zero;
    reg special_nan_out; // Inf*0 = NaN

    // Helper function: zero detection
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    // Helper function: infinity detection
    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    // Helper function: NaN detection
    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear internal registers
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_mant <= 0; b_mant <= 0;
            a_zero <= 0; b_zero <= 0;
            a_inf <= 0; b_inf <= 0;
            a_nan <= 0; b_nan <= 0;

            sign <= 0;
            exp_sum <= 0;
            product <= 0;

            mantissa_rounded <= 0;
            exponent_rounded <= 0;

            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;
            round_increment <= 0;

            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;
            special_nan_out <= 0;
        end else begin
            counter <= (counter == 3'd2) ? 3'd0 : counter + 3'd1;

            case (counter)
                3'd0: begin
                    // Extract input fields
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_zero <= is_zero(a[30:23], a[22:0]);
                    b_zero <= is_zero(b[30:23], b[22:0]);
                    a_inf  <= is_inf(a[30:23], a[22:0]);
                    b_inf  <= is_inf(b[30:23], b[22:0]);
                    a_nan  <= is_nan(a[30:23], a[22:0]);
                    b_nan  <= is_nan(b[30:23], b[22:0]);

                    // Prepare mantissas with implicit leading 1 if normalized
                    a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                end

                3'd1: begin
                    // Multiply mantissas (24x24)
                    product <= a_mant * b_mant;

                    // Compute sign (XOR)
                    sign <= a_sign ^ b_sign;

                    // Exponent sum with bias adjustment
                    exp_sum <= a_exp + b_exp - EXP_BIAS;

                    // Determine special outputs for next stage
                    special_nan <= a_nan || b_nan;
                    special_nan_out <= (a_inf && b_zero) || (b_inf && a_zero);
                    special_inf <= (a_inf || b_inf) && !special_nan_out && !special_nan;
                    special_zero <= (a_zero || b_zero) && !special_nan_out && !special_nan && !special_inf;
                end

                3'd2: begin
                    // Normalize product:
                    // If MSB is set (bit 47), shift right and increment exponent
                    if (product[47]) begin
                        // Shift mantissa right 1 and increment exponent
                        mantissa_rounded <= product[46:23];
                        exponent_rounded <= exp_sum + 1;
                        // Rounding bits: bit 23 is guard, 22 round, lower sticky
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB is 0, no shift
                        mantissa_rounded <= product[45:22];
                        exponent_rounded <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    // Round to nearest even
                    round_increment <= guard_bit && (round_bit || sticky_bit || mantissa_rounded[0]);

                    // Apply rounding
                    if (round_increment) begin
                        {exponent_rounded, mantissa_rounded} <= 
                            {exponent_rounded, mantissa_rounded} + 25'd1;
                    end

                    // Handle rounding overflow (mantissa overflow after adding 1)
                    if (mantissa_rounded[23]) begin
                        // Mantissa overflow, shift right and increment exponent
                        mantissa_rounded <= mantissa_rounded >> 1;
                        exponent_rounded <= exponent_rounded + 1;
                    end

                    // Final output generation
                    if (special_nan || special_nan_out) begin
                        // Output canonical quiet NaN: sign=0, exp=255, mantissa MSB=1, rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Output infinity with sign
                        z <= {sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Output zero with sign
                        z <= {sign, 31'd0};
                    end else if (exponent_rounded >= 255) begin
                        // Overflow, output infinity
                        z <= {sign, 8'hFF, 23'd0};
                    end else if (exponent_rounded <= 0) begin
                        // Underflow: output zero (no subnormals handled)
                        z <= {sign, 31'd0};
                    end else begin
                        // Normal number
                        z <= {sign, exponent_rounded[7:0], mantissa_rounded[22:0]};
                    end
                end

                default: begin
                    // Should never happen, but safe defaults
                    z <= 32'd0;
                end
            endcase
        end
    end

endmodule
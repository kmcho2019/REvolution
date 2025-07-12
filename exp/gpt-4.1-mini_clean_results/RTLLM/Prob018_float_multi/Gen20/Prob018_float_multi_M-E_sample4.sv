module float_multi(
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // FSM states (cycle counter)
    reg [2:0] counter;

    // Input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special flags per operand
    reg a_zero, b_zero;
    reg a_inf,  b_inf;
    reg a_nan,  b_nan;

    // Extended mantissas with implicit leading 1 or zero if subnormal
    reg [23:0] a_mantissa, b_mantissa;

    // Intermediate signals
    reg sign_res;
    reg [9:0] exp_res; // 10 bits for intermediate sum and bias adjust

    reg [47:0] product; // 24x24 mantissa product

    // Normalized mantissa after shift
    reg [47:0] norm_product;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa (24 bits + carry)
    reg [24:0] mant_rounded;

    // Flags for special cases
    reg special_nan;
    reg special_inf;
    reg special_zero;
    reg special_nan_out; // Inf * Zero -> NaN

    // Sticky bit accumulator for OR reduction during normalization rounding step
    wire sticky_or;

    // Functions to detect special cases
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Sticky OR: OR of all bits (for sticky bit calc)
    assign sticky_or = |norm_product[21:0];

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf  <= 1'b0; b_inf  <= 1'b0;
            a_nan  <= 1'b0; b_nan  <= 1'b0;

            a_mantissa <= 24'd0; b_mantissa <= 24'd0;

            sign_res <= 1'b0;
            exp_res <= 10'd0;
            product <= 48'd0;

            norm_product <= 48'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            mant_rounded <= 25'd0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;
            special_nan_out <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Capture inputs and special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp  <= a[30:23];
                    b_exp  <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_zero <= is_zero(a[30:23], a[22:0]);
                    b_zero <= is_zero(b[30:23], b[22:0]);
                    a_inf  <= is_inf(a[30:23], a[22:0]);
                    b_inf  <= is_inf(b[30:23], b[22:0]);
                    a_nan  <= is_nan(a[30:23], a[22:0]);
                    b_nan  <= is_nan(b[30:23], b[22:0]);

                    // Prepare mantissas: implicit leading 1 if normal, 0 if subnormal
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Determine sign of result
                    sign_res <= a[31] ^ b[31];

                    // Reset output to zero while processing
                    z <= 32'd0;

                    // Reset flags
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;
                    special_nan_out <= 1'b0;

                    counter <= 3'd1;
                end
                3'd1: begin
                    // Handle special cases first
                    special_nan <= a_nan || b_nan;
                    special_nan_out <= (a_inf && b_zero) || (b_inf && a_zero);
                    special_inf <= ((a_inf || b_inf) && !special_nan_out);
                    special_zero <= ((a_zero || b_zero) && !special_nan_out && !special_inf);

                    if (special_nan || special_nan_out) begin
                        // Nothing else to do in this cycle for product and exp
                        product <= 48'd0;
                        exp_res <= 10'd0;
                    end else begin
                        // Calculate exponent sum - bias
                        exp_res <= a_exp + b_exp - EXP_BIAS;

                        // Multiply mantissas (24x24 bits)
                        product <= a_mantissa * b_mantissa;
                    end
                    counter <= 3'd2;
                end
                3'd2: begin
                    // Normalize product and adjust exponent
                    // If product MSB (bit 47) is 1, shift right and increment exponent
                    if (product[47]) begin
                        norm_product <= product >> 1;
                        exp_res <= exp_res + 10'd1;
                    end else begin
                        norm_product <= product;
                    end

                    // Extract rounding bits
                    guard_bit <= norm_product[23];
                    round_bit <= norm_product[22];
                    sticky_bit <= sticky_or;

                    counter <= 3'd3;
                end
                3'd3: begin
                    // Rounding: round to nearest even
                    mant_rounded <= {1'b0, norm_product[46:23]} + (guard_bit && (round_bit || sticky_bit || norm_product[23]));

                    // Check mantissa overflow after rounding (carry out)
                    if (mant_rounded[24]) begin
                        exp_res <= exp_res + 10'd1;
                        mant_rounded <= mant_rounded >> 1; // Shift mantissa to fit 24 bits
                    end

                    counter <= 3'd4;
                end
                3'd4: begin
                    // Final output generation and special cases handling

                    if (special_nan) begin
                        // Quiet NaN canonical: sign=0, exp=255, mantissa MSB=1, rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_nan_out) begin
                        // Inf * Zero = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Infinity output with correct sign
                        z <= {sign_res, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero output with correct sign
                        z <= {sign_res, 31'd0};
                    end else if (exp_res >= 10'd255) begin
                        // Overflow: infinity output
                        z <= {sign_res, 8'hFF, 23'd0};
                    end else if (exp_res <= 10'd0) begin
                        // Underflow: output zero (flush to zero, no gradual underflow)
                        z <= {sign_res, 31'd0};
                    end else begin
                        // Normal output: sign, exponent, mantissa (drop leading bit)
                        z <= {sign_res, exp_res[7:0], mant_rounded[22:0]};
                    end

                    counter <= 3'd0; // Ready for next operation
                end
                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule
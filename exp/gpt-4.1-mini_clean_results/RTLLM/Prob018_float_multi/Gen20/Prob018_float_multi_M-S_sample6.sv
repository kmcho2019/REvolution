module float_multi(
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Stage 1: Extract and hold input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;
    reg [23:0] a_mantissa, b_mantissa; // implicit 1 for normalized, else 0

    // Stage 2: Multiply mantissas, add exponents, determine sign and special flags
    reg [47:0] product;
    reg [9:0] exp_sum; // wider to handle overflow
    reg sign_out;
    reg special_nan;
    reg special_inf;
    reg special_zero;
    reg special_inf_by_zero; // Inf*0 => NaN

    // Stage 3: Normalize, round and form output
    reg [47:0] norm_product;
    reg [9:0] norm_exp;
    reg [23:0] mantissa_rounded;
    reg [9:0] final_exp;
    reg final_sign;
    reg guard_bit, round_bit, sticky_bit;
    reg round_increment;
    reg [24:0] mantissa_with_round;

    // Functions to detect special cases
    function is_zero(input [7:0] exp, input [22:0] frac);
        is_zero = (exp == 8'd0) && (frac == 23'd0);
    endfunction

    function is_inf(input [7:0] exp, input [22:0] frac);
        is_inf = (exp == 8'hFF) && (frac == 23'd0);
    endfunction

    function is_nan(input [7:0] exp, input [22:0] frac);
        is_nan = (exp == 8'hFF) && (frac != 23'd0);
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear stage registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_is_zero <= 1'b0; b_is_zero <= 1'b0;
            a_is_inf <= 1'b0; b_is_inf <= 1'b0;
            a_is_nan <= 1'b0; b_is_nan <= 1'b0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            product <= 48'd0;
            exp_sum <= 10'd0;
            sign_out <= 1'b0;
            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;
            special_inf_by_zero <= 1'b0;
            norm_product <= 48'd0;
            norm_exp <= 10'd0;
            mantissa_rounded <= 24'd0;
            final_exp <= 10'd0;
            final_sign <= 1'b0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            round_increment <= 1'b0;
            mantissa_with_round <= 25'd0;
        end else begin
            counter <= counter == 3'd2 ? 3'd0 : counter + 3'd1;
            case(counter)
                3'd0: begin
                    // Stage 1: Extract input fields and detect special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];
                    a_is_zero <= is_zero(a[30:23], a[22:0]);
                    b_is_zero <= is_zero(b[30:23], b[22:0]);
                    a_is_inf <= is_inf(a[30:23], a[22:0]);
                    b_is_inf <= is_inf(b[30:23], b[22:0]);
                    a_is_nan <= is_nan(a[30:23], a[22:0]);
                    b_is_nan <= is_nan(b[30:23], b[22:0]);

                    // Form mantissas with implicit leading 1 if normalized
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                end

                3'd1: begin
                    // Stage 2: Mantissa multiply, exponent add, sign XOR, special cases
                    product <= a_mantissa * b_mantissa; // 24x24 => 48 bits
                    exp_sum <= a_exp + b_exp - EXP_BIAS; 
                    sign_out <= a_sign ^ b_sign;

                    special_nan <= a_is_nan || b_is_nan;
                    // Inf*0 is invalid, yields NaN
                    special_inf_by_zero <= (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
                    special_inf <= (a_is_inf || b_is_inf) && !special_inf_by_zero;
                    special_zero <= (a_is_zero || b_is_zero) && !special_inf_by_zero && !special_inf;
                end

                3'd2: begin
                    // Stage 3: Normalize, round, assemble output

                    // Normalize product:
                    if (product[47]) begin
                        norm_product <= product >> 1;
                        norm_exp <= exp_sum + 10'd1;
                    end else begin
                        norm_product <= product;
                        norm_exp <= exp_sum;
                    end

                    // Extract rounding bits from norm_product
                    // Mantissa bits to keep: bits [46:23]
                    // Guard bit: bit 23, Round bit: bit 22, Sticky bit: OR of bits [21:0]
                    guard_bit <= norm_product[23];
                    round_bit <= norm_product[22];
                    sticky_bit <= |norm_product[21:0];

                    mantissa_rounded <= norm_product[46:23]; // 24 bits

                    // Round-to-nearest even
                    round_increment <= guard_bit && (round_bit || sticky_bit || mantissa_rounded[0]);

                    mantissa_with_round <= {1'b0, mantissa_rounded} + round_increment;

                    // Check for mantissa overflow after rounding
                    if (mantissa_with_round[24]) begin
                        mantissa_rounded <= mantissa_with_round[24:1];
                        final_exp <= norm_exp + 10'd1;
                    end else begin
                        mantissa_rounded <= mantissa_with_round[23:0];
                        final_exp <= norm_exp;
                    end

                    final_sign <= sign_out;

                    // Form output considering special cases
                    if (special_nan || special_inf_by_zero) begin
                        // Quiet NaN: sign=0, exp=0xFF, mantissa MSB=1, others=0
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        z <= {final_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        z <= {final_sign, 31'd0};
                    end else if (final_exp[9:8] != 2'b00) begin
                        // Overflow -> Infinity
                        z <= {final_sign, 8'hFF, 23'd0};
                    end else if (final_exp == 10'd0) begin
                        // Underflow or zero (no gradual underflow implemented)
                        z <= {final_sign, 31'd0};
                    end else begin
                        // Normal number
                        z <= {final_sign, final_exp[7:0], mantissa_rounded[22:0]};
                    end
                end
            endcase
        end
    end

endmodule
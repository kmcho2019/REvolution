module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

// FSM States
localparam S_IDLE       = 3'd0;
localparam S_EXTRACT    = 3'd1;
localparam S_NORM_INPUT = 3'd2;
localparam S_CHECK_SPC  = 3'd3;
localparam S_MULTIPLY   = 3'd4;
localparam S_NORMALIZE  = 3'd5;
localparam S_ROUND      = 3'd6;
localparam S_OUTPUT     = 3'd7;

reg [2:0] state, next_state;

// Internal registers for operands decomposition
reg        a_sign, b_sign, z_sign;
reg signed [9:0]  a_exponent, b_exponent, z_exponent; // signed for underflow handling
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [47:0] product; // 24x24 multiplication yields up to 48 bits

// Rounding bits
reg guard_bit, round_bit, sticky_bit;

// Special cases flags
reg a_is_zero, b_is_zero;
reg a_is_inf,  b_is_inf;
reg a_is_nan,  b_is_nan;

reg special_nan, special_inf, special_zero;

// Flags for rounding and mantissa overflow
reg rounding_increment;
reg mantissa_overflow;

// Temporary registers for calculations in certain stages
reg [47:0] product_norm;
reg signed [9:0] exp_adj;
reg [23:0] mantissa_norm;
reg g, r, s;

reg signed [9:0] exp_out;
reg [23:0] mant_out;

// Variables for output formatting stage
reg [31:0] result_out;
reg [4:0] leading_zeros_a, leading_zeros_b;

// Sticky calculation with variable bits via loop (for subnormal rounding)
function sticky_bits_or;
    input [23:0] mant;
    input [4:0]  bits_to_check; // number of bits from LSB
    integer i;
    begin
        sticky_bits_or = 1'b0;
        for (i = 0; i < bits_to_check; i = i + 1) begin
            sticky_bits_or = sticky_bits_or | mant[i];
        end
    end
endfunction

// Leading zero count for 24-bit vector
function [4:0] leading_zero_count_24;
    input [23:0] value;
    integer i;
    begin
        leading_zero_count_24 = 0;
        for (i = 23; i >= 0; i = i - 1) begin
            if (value[i] == 1'b0)
                leading_zero_count_24 = leading_zero_count_24 + 1;
            else
                i = -1; // break early
        end
    end
endfunction

// FSM state register
always @(posedge clk or posedge rst) begin
    if (rst)
        state <= S_IDLE;
    else
        state <= next_state;
end

// FSM combinational next state logic
always @(*) begin
    case (state)
        S_IDLE:       next_state = S_EXTRACT;
        S_EXTRACT:    next_state = S_NORM_INPUT;
        S_NORM_INPUT: next_state = S_CHECK_SPC;
        S_CHECK_SPC:  next_state = S_MULTIPLY;
        S_MULTIPLY:   next_state = S_NORMALIZE;
        S_NORMALIZE:  next_state = S_ROUND;
        S_ROUND:      next_state = S_OUTPUT;
        S_OUTPUT:     next_state = S_IDLE;
        default:      next_state = S_IDLE;
    endcase
end

// Sequential operations per state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        z <= 32'd0;
        a_sign <= 1'b0; b_sign <= 1'b0; z_sign <= 1'b0;
        a_exponent <= 10'd0; b_exponent <= 10'd0; z_exponent <= 10'd0;
        a_mantissa <= 24'd0; b_mantissa <= 24'd0; z_mantissa <= 24'd0;
        product <= 48'd0;
        guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
        a_is_zero <= 1'b0; b_is_zero <= 1'b0;
        a_is_inf <= 1'b0;  b_is_inf <= 1'b0;
        a_is_nan <= 1'b0;  b_is_nan <= 1'b0;
        special_nan <= 1'b0; special_inf <= 1'b0; special_zero <= 1'b0;
        rounding_increment <= 1'b0;
        mantissa_overflow <= 1'b0;

        product_norm <= 48'd0;
        exp_adj <= 10'd0;
        mantissa_norm <= 24'd0;
        g <= 1'b0; r <= 1'b0; s <= 1'b0;

        exp_out <= 10'd0;
        mant_out <= 24'd0;

        result_out <= 32'd0;
    end else begin
        case (state)
            S_IDLE: begin
                // Clear output and flags to safe defaults
                z <= 32'd0;
                special_nan <= 1'b0;
                special_inf <= 1'b0;
                special_zero <= 1'b0;
                rounding_increment <= 1'b0;
                mantissa_overflow <= 1'b0;
            end

            S_EXTRACT: begin
                // Extract sign bits and combine for output
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a[31] ^ b[31];

                // Extract exponents and mantissas; sign-extend exponent for easier math
                a_exponent <= {2'b00, a[30:23]};
                b_exponent <= {2'b00, b[30:23]};

                // Add implicit leading 1 for normalized, else zero for subnormal
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Identify special inputs
                a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);
                b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);
                a_is_inf  <= (a[30:23] == 8'hFF) && (~|a[22:0]);
                b_is_inf  <= (b[30:23] == 8'hFF) && (~|b[22:0]);
                a_is_zero <= (a[30:23] == 8'd0) && (~|a[22:0]);
                b_is_zero <= (b[30:23] == 8'd0) && (~|b[22:0]);

                // Clear product and rounding bits
                product <= 48'd0;
                guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            end

            S_NORM_INPUT: begin
                // Normalize subnormal inputs by shifting mantissa left & adjusting exponent
                leading_zeros_a = leading_zero_count_24(a_mantissa);
                leading_zeros_b = leading_zero_count_24(b_mantissa);

                // Normalize a if subnormal and non-zero, not special
                if (a[30:23] == 8'd0 && !a_is_zero && !a_is_nan && !a_is_inf) begin
                    a_mantissa <= a_mantissa << leading_zeros_a;
                    a_exponent <= 10'd1 - leading_zeros_a;
                end

                // Normalize b if subnormal and non-zero, not special
                if (b[30:23] == 8'd0 && !b_is_zero && !b_is_nan && !b_is_inf) begin
                    b_mantissa <= b_mantissa << leading_zeros_b;
                    b_exponent <= 10'd1 - leading_zeros_b;
                end
            end

            S_CHECK_SPC: begin
                // Identify special cases on operands
                special_nan  <= a_is_nan || b_is_nan || ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero));
                special_inf  <= (!special_nan) && (a_is_inf || b_is_inf);
                special_zero <= (!special_nan && !special_inf) && (a_is_zero || b_is_zero);

                if (special_nan || special_inf || special_zero) begin
                    product <= 48'd0;
                    z_exponent <= 10'd0;
                    z_mantissa <= 24'd0;
                end else begin
                    // Compute exponent sum and subtract bias
                    z_exponent <= a_exponent + b_exponent - 10'd127;

                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa;
                end
            end

            S_MULTIPLY: begin
                if (special_nan || special_inf || special_zero) begin
                    // No product processing needed for special cases
                    guard_bit <= 1'b0;
                    round_bit <= 1'b0;
                    sticky_bit <= 1'b0;
                    z_mantissa <= 24'd0;
                end else begin
                    exp_adj = z_exponent;
                    // If MSB of product is 1, no shift, exponent increments by 1
                    // Else shift product left by 1 and exponent stays
                    if (product[47] == 1'b1) begin
                        product_norm <= product;
                        exp_adj = exp_adj + 1;
                    end else begin
                        product_norm <= product << 1;
                        // exponent unchanged
                    end

                    // Extract mantissa and rounding bits
                    // Mantissa bits: bits 46:23 (24 bits, leading 1 implicit)
                    mantissa_norm <= product_norm[46:23];
                    // Guard, round, sticky bits for rounding decision
                    g <= product_norm[22];
                    r <= product_norm[21];

                    // sticky bits = OR of bits 20 down to 0 - use function with fixed width 21 bits
                    s <= 1'b0;
                    {
                        sticky_bit
                    } <= sticky_bits_or(product_norm[20:0], 21);

                    guard_bit <= g;
                    round_bit <= r;
                    sticky_bit <= s;
                    z_mantissa <= mantissa_norm;
                    z_exponent <= exp_adj;
                end
            end

            S_NORMALIZE: begin
                if (special_nan || special_inf || special_zero) begin
                    rounding_increment <= 1'b0;
                    mantissa_overflow <= 1'b0;
                end else begin
                    // IEEE-754 round to nearest even
                    // Round if guard bit set and (round or sticky or lsb is 1)
                    rounding_increment <= guard_bit && (round_bit || sticky_bit || z_mantissa[0]);

                    // Add rounding increment and check for mantissa overflow
                    {mantissa_overflow, z_mantissa} <= z_mantissa + rounding_increment;
                end
            end

            S_ROUND: begin
                if (special_nan || special_inf || special_zero) begin
                    // Nothing to do here for special cases
                end else begin
                    mant_out <= z_mantissa;
                    exp_out <= z_exponent;

                    // Adjust for mantissa overflow after rounding
                    if (mantissa_overflow) begin
                        mant_out <= z_mantissa >> 1;
                        exp_out <= z_exponent + 1;
                    end
                end
            end

            S_OUTPUT: begin
                if (special_nan) begin
                    // Quiet NaN: sign=0, exp=0xFF, mantissa MSB=1, others zero
                    result_out <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf) begin
                    // Infinity: sign, exp=0xFF, mantissa=0
                    result_out <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero: sign, exponent=0, mantissa=0
                    result_out <= {z_sign, 31'd0};
                end else begin
                    // Handle normal, subnormal, overflow and underflow
                    if (exp_out >= 10'sd255) begin
                        // Overflow to Infinity
                        result_out <= {z_sign, 8'hFF, 23'd0};
                    end else if (exp_out <= 0) begin
                        // Subnormal or zero
                        integer shift_amt;
                        reg sticky_shift;
                        reg [23:0] shifted_mant;
                        reg rounding_subnormal;

                        shift_amt = 1 - exp_out; // positive number

                        // Calculate sticky bit for subnormal rounding by OR-ing bits shifted out
                        sticky_shift = sticky_bits_or(mant_out, shift_amt);

                        // Shift mantissa right by shift_amt to create subnormal fraction
                        shifted_mant = mant_out >> shift_amt;

                        // Round to nearest even for subnormal rounding
                        // round if sticky bit set and lsb is 1
                        rounding_subnormal = sticky_shift && shifted_mant[0];

                        if (rounding_subnormal) begin
                            shifted_mant = shifted_mant + 1;
                        end

                        if (shifted_mant == 0) begin
                            // Underflow to zero
                            result_out <= {z_sign, 31'd0};
                        end else begin
                            result_out <= {z_sign, 8'd0, shifted_mant[22:0]};
                        end
                    end else begin
                        // Normal number
                        result_out <= {z_sign, exp_out[7:0], mant_out[22:0]};
                    end
                end

                z <= result_out;
            end

            default: begin
                z <= 32'd0;
            end
        endcase
    end
end

endmodule
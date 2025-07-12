module float_multi(
    input              clk,
    input              rst,
    input      [31:0]  a,
    input      [31:0]  b,
    output reg [31:0]  z
);

    // IEEE-754 single precision parameters
    localparam EXP_BIAS = 127;

    // FSM states
    localparam IDLE       = 3'd0;
    localparam DECODE     = 3'd1;
    localparam MUL        = 3'd2;
    localparam NORMALIZE  = 3'd3;
    localparam ROUND      = 3'd4;
    localparam SPECIAL    = 3'd5;
    localparam DONE       = 3'd6;

    reg [2:0] state, next_state;

    // Input extraction registers
    reg        a_sign, b_sign;
    reg [7:0]  a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Extended mantissas with implicit leading bit
    reg [23:0] a_mantissa, b_mantissa;

    // Flags for special cases
    reg a_is_zero, b_is_zero;
    reg a_is_inf,  b_is_inf;
    reg a_is_nan,  b_is_nan;

    // Output sign, exponent, mantissa
    reg z_sign;
    reg [9:0] z_exp;        // Use 10 bits for intermediate exponent calculation
    reg [23:0] z_mantissa;  // 24 bits mantissa including leading 1

    // Product of mantissas (24x24 = 48 bits)
    reg [47:0] product;

    // Normalization signals
    reg        normalized;
    reg [47:0] norm_product;
    reg [9:0]  norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounding result
    reg [24:0] mant_rounded; // 25 bits for rounding carry

    // Temporary vars for special case handling
    reg [31:0] special_result;

    // Internal combinational signals for extracting rounding bits and mantissa shift
    wire msb_product = product[47];

    // Extract inputs combinationally
    wire a_zero = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_zero = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
    wire a_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
    wire a_nan  = (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
    wire b_nan  = (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

    // Sticky bit calculation helper
    function sticky_or;
        input [21:0] bits;
        integer i;
        begin
            sticky_or = 0;
            for(i=0; i<22; i=i+1) begin
                if (bits[i]) sticky_or = 1'b1;
            end
        end
    endfunction

    // FSM Sequential - State update
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM Combinational - Next state logic
    always @(*) begin
        case(state)
            IDLE:      next_state = DECODE;
            DECODE:    next_state = MUL;
            MUL:       next_state = NORMALIZE;
            NORMALIZE: next_state = ROUND;
            ROUND:     next_state = SPECIAL;
            SPECIAL:   next_state = DONE;
            DONE:      next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

    // FSM outputs and datapath registers update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            a_sign      <= 0; b_sign      <= 0;
            a_exp       <= 0; b_exp       <= 0;
            a_frac      <= 0; b_frac      <= 0;
            a_mantissa  <= 0; b_mantissa  <= 0;

            a_is_zero   <= 0; b_is_zero   <= 0;
            a_is_inf    <= 0; b_is_inf    <= 0;
            a_is_nan    <= 0; b_is_nan    <= 0;

            product     <= 0;

            z_sign      <= 0;
            z_exp       <= 0;
            z_mantissa  <= 0;

            norm_product <= 0;
            norm_exp     <= 0;

            guard_bit   <= 0;
            round_bit   <= 0;
            sticky_bit  <= 0;

            mant_rounded <= 0;

            special_result <= 0;

            normalized <= 0;

            z <= 32'd0;
        end else begin
            case(state)
                // Extract fields, signs and special flags from inputs
                DECODE: begin
                    a_sign     <= a[31];
                    b_sign     <= b[31];
                    a_exp      <= a[30:23];
                    b_exp      <= b[30:23];
                    a_frac     <= a[22:0];
                    b_frac     <= b[22:0];

                    a_is_zero  <= a_zero;
                    b_is_zero  <= b_zero;
                    a_is_inf   <= a_inf;
                    b_is_inf   <= b_inf;
                    a_is_nan   <= a_nan;
                    b_is_nan   <= b_nan;

                    // Assemble mantissas, adding implicit leading 1 if normalized
                    a_mantissa <= (a_zero || a_inf || a_nan) ? 24'd0 : ((a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac});
                    b_mantissa <= (b_zero || b_inf || b_nan) ? 24'd0 : ((b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac});

                    // Calculate sign of output as XOR of input signs
                    z_sign <= a[31] ^ b[31];
                end

                // Multiply mantissas and add exponents (subtract bias)
                MUL: begin
                    product <= a_mantissa * b_mantissa;

                    // Exponent calculation: sum minus bias
                    // If either operand is zero or special, exp sum will be set accordingly later
                    z_exp <= a_exp + b_exp - EXP_BIAS;
                end

                // Normalize product and set rounding bits
                NORMALIZE: begin
                    // Normalize: if MSB is 1, product is >= 2, shift right 1 and increment exponent
                    if (product[47] == 1'b1) begin
                        norm_product <= product;
                        z_exp <= z_exp + 1'b1;
                        // Mantissa 24 bits: bits [47:24]
                        z_mantissa <= product[47:24];
                        // Rounding bits
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB is 0, shift left mantissa accordingly (take bits [46:23])
                        norm_product <= product << 1;
                        z_exp <= z_exp;
                        z_mantissa <= product[46:23];
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                    normalized <= 1'b1;
                end

                // Round mantissa according to round to nearest even
                ROUND: begin
                    // Round increment if guard bit is 1 and (round bit or sticky bit or LSB of mantissa is 1)
                    if (guard_bit && (round_bit || sticky_bit || z_mantissa[0]))
                        mant_rounded <= {1'b0, z_mantissa} + 25'd1;
                    else
                        mant_rounded <= {1'b0, z_mantissa};

                    // Check for mantissa overflow after rounding (carry out)
                    if (mant_rounded[24]) begin
                        z_exp <= z_exp + 1'b1;
                        z_mantissa <= mant_rounded[24:2]; // shifted right 1 bit effectively
                    end else begin
                        z_mantissa <= mant_rounded[23:1]; // keep 23 bits after rounding, LSB dropped
                    end
                end

                // Handle special cases and underflow/overflow
                SPECIAL: begin
                    // Default no special case
                    special_result <= 32'd0;

                    // NaN if any input NaN
                    if (a_is_nan || b_is_nan) begin
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * non-zero = Inf
                        special_result <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_is_zero || b_is_zero) begin
                        // Zero * anything = zero
                        special_result <= {z_sign, 31'd0};
                    end else begin
                        // Normal number special handling:
                        // Check overflow and underflow
                        if (z_exp >= 10'd255) begin
                            // Overflow -> Infinity
                            special_result <= {z_sign, 8'hFF, 23'd0};
                        end else if (z_exp <= 0) begin
                            // Underflow -> zero (flush to zero)
                            special_result <= {z_sign, 31'd0};
                        end else begin
                            // Normal case: assemble float
                            special_result <= {z_sign, z_exp[7:0], z_mantissa[22:0]};
                        end
                    end
                end

                // Output assignment
                DONE: begin
                    z <= special_result;
                end

                default: begin
                    // Do nothing or hold previous values
                end
            endcase
        end
    end

endmodule
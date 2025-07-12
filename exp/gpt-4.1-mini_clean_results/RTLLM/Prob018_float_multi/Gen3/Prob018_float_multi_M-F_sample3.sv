module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    // IEEE 754 single precision parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;

    // FSM states
    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        CAPTURE    = 3'd1,
        SPECIAL    = 3'd2,
        MUL_NORM   = 3'd3,
        ROUND      = 3'd4,
        PACK       = 3'd5
    } state_t;

    reg [2:0] state, next_state;

    // Input decoded fields (combinational)
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special input flags
    wire a_is_nan  = (a_exp == EXP_MAX) && (a_frac != 0);
    wire b_is_nan  = (b_exp == EXP_MAX) && (b_frac != 0);
    wire a_is_inf  = (a_exp == EXP_MAX) && (a_frac == 0);
    wire b_is_inf  = (b_exp == EXP_MAX) && (b_frac == 0);
    wire a_is_zero = (a_exp == 0) && (a_frac == 0);
    wire b_is_zero = (b_exp == 0) && (b_frac == 0);

    // Registered inputs latched at CAPTURE stage
    reg reg_a_sign, reg_b_sign, reg_z_sign;
    reg [7:0] reg_a_exp, reg_b_exp;
    reg [22:0] reg_a_frac, reg_b_frac;
    reg reg_a_is_nan, reg_b_is_nan;
    reg reg_a_is_inf, reg_b_is_inf;
    reg reg_a_is_zero, reg_b_is_zero;

    // Mantissas with implicit leading bits (24 bits)
    reg [23:0] reg_a_mant, reg_b_mant;

    // Mantissa multiplication result 48 bits (24x24)
    reg [47:0] mant_product;

    // Sum of exponents minus bias, extended 10 bits for internal calculation
    reg signed [9:0] exp_sum;

    // Normalization variables
    reg [5:0] leading_zero_count; // to count up to 48 bits
    reg [47:0] norm_mant;
    reg signed [9:0] norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent after rounding
    reg [24:0] round_sum; // 25 bits to detect overflow after rounding
    reg signed [9:0] rounded_exp;

    // Special result signals to propagate to PACK stage
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Helper signals for rounding calculations
    reg [24:0] round_sum_pre; // mantissa bits before rounding add

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:     next_state = CAPTURE;
            CAPTURE:  next_state = SPECIAL;
            SPECIAL:  if (special_nan || special_inf || special_zero) next_state = PACK;
                      else next_state = MUL_NORM;
            MUL_NORM: next_state = ROUND;
            ROUND:    next_state = PACK;
            PACK:     next_state = IDLE;
            default:  next_state = IDLE;
        endcase
    end

    // Leading zero count function for 48 bits
    // Returns number of leading zeros (0..48)
    function [5:0] clz48(input [47:0] val);
        integer i;
        begin
            clz48 = 0;
            for(i=47; i>=0; i=i-1) begin
                if(val[i] == 1'b1)
                    disable clz_loop;
                else
                    clz48 = clz48 + 1;
            end
            clz_loop: ;
        end
    endfunction

    // Main sequential block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'b0;

            reg_a_sign <= 1'b0; reg_b_sign <= 1'b0; reg_z_sign <= 1'b0;
            reg_a_exp <= 8'd0; reg_b_exp <= 8'd0;
            reg_a_frac <= 23'd0; reg_b_frac <= 23'd0;

            reg_a_is_nan <= 1'b0; reg_b_is_nan <= 1'b0;
            reg_a_is_inf <= 1'b0; reg_b_is_inf <= 1'b0;
            reg_a_is_zero <= 1'b0; reg_b_is_zero <= 1'b0;

            reg_a_mant <= 24'd0;
            reg_b_mant <= 24'd0;

            mant_product <= 48'd0;
            exp_sum <= 10'd0;

            leading_zero_count <= 6'd0;
            norm_mant <= 48'd0;
            norm_exp <= 10'd0;

            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;

            round_sum <= 25'd0;
            round_sum_pre <= 25'd0;
            rounded_exp <= 10'd0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;

        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Nothing
                end
                CAPTURE: begin
                    // Latch inputs
                    reg_a_sign <= a_sign;
                    reg_b_sign <= b_sign;
                    reg_z_sign <= a_sign ^ b_sign;

                    reg_a_exp <= a_exp;
                    reg_b_exp <= b_exp;

                    reg_a_frac <= a_frac;
                    reg_b_frac <= b_frac;

                    reg_a_is_nan <= a_is_nan;
                    reg_b_is_nan <= b_is_nan;
                    reg_a_is_inf <= a_is_inf;
                    reg_b_is_inf <= b_is_inf;
                    reg_a_is_zero <= a_is_zero;
                    reg_b_is_zero <= b_is_zero;

                    // Prepare mantissas with implicit leading bit:
                    // if exponent != 0, leading 1, else 0 (denormals)
                    reg_a_mant <= (a_exp != 0) ? {1'b1, a_frac} : {1'b0, a_frac};
                    reg_b_mant <= (b_exp != 0) ? {1'b1, b_frac} : {1'b0, b_frac};

                    // Clear special flags for next stage
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;
                end
                SPECIAL: begin
                    // Detect special cases and set flags
                    if (reg_a_is_nan || reg_b_is_nan) begin
                        // propagate NaN: create quiet NaN (set MSB fraction)
                        special_nan <= 1'b1;
                    end else if ((reg_a_is_inf && reg_b_is_zero) || (reg_b_is_inf && reg_a_is_zero)) begin
                        // inf * 0 = NaN
                        special_nan <= 1'b1;
                    end else if (reg_a_is_inf || reg_b_is_inf) begin
                        // Infinity * nonzero non-NaN => Inf
                        special_inf <= 1'b1;
                    end else if (reg_a_is_zero || reg_b_is_zero) begin
                        // Zero * non-inf non-NaN => Zero
                        special_zero <= 1'b1;
                    end else begin
                        // No special cases; proceed to multiplication

                        special_nan <= 1'b0;
                        special_inf <= 1'b0;
                        special_zero <= 1'b0;

                        // Multiply mantissas 24x24 -> 48 bits
                        mant_product <= reg_a_mant * reg_b_mant;

                        // Exponent sum with bias removed:
                        // Use signed 10-bit to hold sum and intermediate calculations
                        exp_sum <= $signed({2'b00, reg_a_exp}) + $signed({2'b00, reg_b_exp}) - EXP_BIAS;
                    end
                end
                MUL_NORM: begin
                    // Normalize mantissa product and adjust exponent
                    // Count leading zeros
                    if (mant_product == 48'd0) begin
                        // If product zero, exp and mantissa zero
                        leading_zero_count <= 6'd48;
                        norm_mant <= 48'd0;
                        norm_exp <= 0;
                    end else begin
                        // Count leading zeros
                        leading_zero_count <= clz48(mant_product);

                        // Shift mantissa left by leading zeros to normalize MSB=1 at bit 47
                        norm_mant <= mant_product << leading_zero_count;

                        // Adjust exponent accordingly
                        // New exponent = exp_sum - leading_zero_count
                        norm_exp <= exp_sum - leading_zero_count;
                    end
                end
                ROUND: begin
                    // Extract mantissa bits for rounding:

                    // Mantissa bits needed for output: 24 bits (1 implicit + 23 fraction bits)
                    // The normalized mantissa is aligned with MSB at bit 47:
                    // mantissa: bits 47 downto 24 (24 bits)
                    // Guard bit: bit 23
                    // Round bit: bit 22
                    // Sticky bit: OR of bits 21 downto 0

                    guard_bit <= norm_mant[23];
                    round_bit <= norm_mant[22];
                    sticky_bit <= |norm_mant[21:0];

                    // Capture mantissa bits (bits 47:24) to round_sum_pre
                    round_sum_pre <= norm_mant[47:23]; // 25 bits

                    // Perform round-to-nearest-even
                    // round up if guard=1 and (round=1 or sticky=1 or LSB=1)
                    // LSB is bit 0 of fraction part = round_sum_pre[0]

                    if (guard_bit && (round_bit || sticky_bit || round_sum_pre[0])) begin
                        round_sum <= round_sum_pre + 25'd1;
                    end else begin
                        round_sum <= round_sum_pre;
                    end

                    rounded_exp <= norm_exp; // default assignment, may adjust below

                    // Check mantissa overflow after rounding (bit 24)
                    // If overflow, shift right and increment exponent
                    if ((round_sum_pre + (guard_bit && (round_bit || sticky_bit || round_sum_pre[0]))) & 25'h1000000) begin
                        // overflow bit 24 set (bit index 24 of round_sum)
                        round_sum <= (round_sum >> 1);
                        rounded_exp <= norm_exp + 1;
                    end
                end
                PACK: begin
                    // Pack output based on special flags or normal result

                    if (special_nan) begin
                        // Quiet NaN:
                        // sign=0
                        // exponent=all ones
                        // MSB of fraction=1 (quiet NaN indicator)
                        // Propagate payload bits from input NaN if possible; here just set MSB fraction
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Infinity with correct sign
                        z <= {reg_z_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero with correct sign
                        z <= {reg_z_sign, 31'd0};
                    end else begin
                        // Normal numbers:

                        if (rounded_exp >= EXP_MAX) begin
                            // Overflow exponent => infinity
                            z <= {reg_z_sign, 8'hFF, 23'd0};
                        end else if (rounded_exp <= 0) begin
                            // Underflow: produce subnormal or zero

                            // How many bits to right shift mantissa to produce subnormal:
                            // shift = 1 - rounded_exp
                            // Only output subnormal if within mantissa bits

                            if (rounded_exp < -23) begin
                                // Too small => zero
                                z <= {reg_z_sign, 31'd0};
                            end else begin
                                // Produce subnormal:
                                // Shift mantissa right by (1 - rounded_exp)
                                // mantissa = round_sum[23:0] right shifted by (1 - rounded_exp)
                                // exponent = 0

                                // Calculate shift amount
                                integer shift_amt;
                                reg [24:0] sub_mant;

                                shift_amt = 1 - rounded_exp;

                                sub_mant = round_sum >> shift_amt;

                                z <= {reg_z_sign, 8'd0, sub_mant[22:0]};
                            end
                        end else begin
                            // Normalized output exponent in [1..254]
                            // fraction bits are lower 23 bits of round_sum

                            z <= {reg_z_sign, rounded_exp[7:0], round_sum[22:0]};
                        end
                    end
                end
                default: begin
                    // default no operation
                end
            endcase
        end
    end
endmodule
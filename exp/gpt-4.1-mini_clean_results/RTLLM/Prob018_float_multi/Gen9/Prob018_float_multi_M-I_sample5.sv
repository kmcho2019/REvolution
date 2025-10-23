module float_multi(
    input  wire         clk,
    input  wire         rst,
    input  wire [31:0]  a,
    input  wire [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters
    localparam EXP_BIAS    = 8'd127;
    localparam EXP_MAX     = 8'hFF;
    localparam MANT_WIDTH  = 24;     // Including implicit leading 1
    localparam PROD_WIDTH  = 48;     // 24x24 multiplication result width

    // Cycle counter for pipeline sequencing
    reg [2:0] counter;
    reg        busy; // To gate toggling when idle

    // Stage 0 registers: extract sign, exponent, mantissa, special cases
    reg          a_sign, b_sign;
    reg  [7:0]   a_exp, b_exp;
    reg  [23:0]  a_mant, b_mant; // 24 bits including implicit 1 if normalized

    reg          a_zero, b_zero;
    reg          a_inf,  b_inf;
    reg          a_nan,  b_nan;

    // Stage 1: mantissa multiplication & exponent addition
    reg  [47:0]  mant_prod;    // 24x24 bits product (no extra bits needed here)
    reg  [8:0]   exp_sum;      // Sum of exponents minus bias; 9 bits to handle overflow

    reg          res_sign;

    // Stage 2: normalization and rounding preparation
    reg  [47:0]  norm_prod;
    reg  [8:0]   norm_exp;

    // Rounding bits
    reg          guard_bit, round_bit, sticky_bit;

    // Stage 3: rounded mantissa and exponent
    reg  [23:0]  rounded_mant;
    reg  [8:0]   rounded_exp;
    reg          rounded_sign;

    // Intermediate rounding carry
    reg          round_increment;

    // Special cases flags registered for use at final stage
    reg s_a_nan, s_b_nan, s_a_inf, s_b_inf, s_a_zero, s_b_zero;

    // Extract input fields combinationally
    wire [7:0] a_in_exp = a[30:23];
    wire [7:0] b_in_exp = b[30:23];
    wire [22:0] a_in_frac = a[22:0];
    wire [22:0] b_in_frac = b[22:0];
    wire       a_in_sign = a[31];
    wire       b_in_sign = b[31];

    // Detect special inputs combinationally
    wire a_in_zero = (a_in_exp == 8'd0) && (a_in_frac == 23'd0);
    wire b_in_zero = (b_in_exp == 8'd0) && (b_in_frac == 23'd0);

    wire a_in_inf  = (a_in_exp == EXP_MAX) && (a_in_frac == 23'd0);
    wire b_in_inf  = (b_in_exp == EXP_MAX) && (b_in_frac == 23'd0);

    wire a_in_nan  = (a_in_exp == EXP_MAX) && (a_in_frac != 23'd0);
    wire b_in_nan  = (b_in_exp == EXP_MAX) && (b_in_frac != 23'd0);

    // Combinational sticky bit calculation for rounding (OR of all bits lower than round bit)
    function automatic logic sticky_bit_func(input [21:0] bits);
        sticky_bit_func = |bits;
    endfunction

    // Pipeline operation sequenced by counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter      <= 3'd0;
            busy         <= 1'b0;
            z            <= 32'd0;

            // Clear all stage registers
            a_sign       <= 1'b0;
            b_sign       <= 1'b0;
            a_exp        <= 8'd0;
            b_exp        <= 8'd0;
            a_mant       <= 24'd0;
            b_mant       <= 24'd0;

            a_zero       <= 1'b0;
            b_zero       <= 1'b0;
            a_inf        <= 1'b0;
            b_inf        <= 1'b0;
            a_nan        <= 1'b0;
            b_nan        <= 1'b0;

            mant_prod    <= 48'd0;
            exp_sum      <= 9'd0;
            res_sign     <= 1'b0;

            norm_prod    <= 48'd0;
            norm_exp     <= 9'd0;

            guard_bit    <= 1'b0;
            round_bit    <= 1'b0;
            sticky_bit   <= 1'b0;

            rounded_mant <= 24'd0;
            rounded_exp  <= 9'd0;
            rounded_sign <= 1'b0;

            round_increment <= 1'b0;

            s_a_nan      <= 1'b0;
            s_b_nan      <= 1'b0;
            s_a_inf      <= 1'b0;
            s_b_inf      <= 1'b0;
            s_a_zero     <= 1'b0;
            s_b_zero     <= 1'b0;
        end else begin
            case(counter)
                3'd0: begin
                    // Stage 0: Extract fields, prepare mantissa with implicit 1 if normalized
                    a_sign    <= a_in_sign;
                    b_sign    <= b_in_sign;
                    a_exp     <= a_in_exp;
                    b_exp     <= b_in_exp;
                    a_zero    <= a_in_zero;
                    b_zero    <= b_in_zero;
                    a_inf     <= a_in_inf;
                    b_inf     <= b_in_inf;
                    a_nan     <= a_in_nan;
                    b_nan     <= b_in_nan;

                    s_a_nan   <= a_in_nan;
                    s_b_nan   <= b_in_nan;
                    s_a_inf   <= a_in_inf;
                    s_b_inf   <= b_in_inf;
                    s_a_zero  <= a_in_zero;
                    s_b_zero  <= b_in_zero;

                    // Mantissas with implicit leading 1 for normalized numbers, else denormals no leading 1
                    a_mant <= (a_in_exp == 8'd0) ? {1'b0, a_in_frac} : {1'b1, a_in_frac};
                    b_mant <= (b_in_exp == 8'd0) ? {1'b0, b_in_frac} : {1'b1, b_in_frac};

                    busy <= 1'b1;
                    counter <= 3'd1;
                end

                3'd1: begin
                    // Stage 1: Multiply mantissas and add exponents
                    mant_prod <= a_mant * b_mant; // 24x24 multiplier in hardware

                    // Sign XOR
                    res_sign <= a_sign ^ b_sign;

                    // Exponent addition minus bias: Extend to 9 bits
                    exp_sum <= a_exp + b_exp - EXP_BIAS;

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Stage 2: Normalize product and prepare rounding bits
                    // Check MSB (bit 47) to normalize
                    if (mant_prod[47]) begin
                        // Product >= 2, shift right by 1 and increment exponent
                        norm_prod <= mant_prod >> 1;
                        norm_exp  <= exp_sum + 9'd1;
                    end else begin
                        norm_prod <= mant_prod;
                        norm_exp  <= exp_sum;
                    end

                    // Extract rounding bits (guard, round, sticky)
                    // Mantissa bits for output = bits [46:23] (24 bits total)
                    // guard = bit 23, round = bit 22, sticky = OR bits [21:0]
                    guard_bit  <= norm_prod[23];
                    round_bit  <= norm_prod[22];
                    sticky_bit <= |norm_prod[21:0];

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Stage 3: Perform rounding and finalize output

                    rounded_sign <= res_sign;
                    rounded_exp  <= norm_exp;

                    rounded_mant <= norm_prod[46:23]; // 24-bit mantissa with implicit 1

                    // Round to nearest even: round increment if guard=1 and (round=1 or sticky=1 or LSB=1)
                    round_increment <= (guard_bit && (round_bit || sticky_bit || rounded_mant[0]));

                    // Apply rounding increment non-blocking to avoid combinational delay here
                    if (round_increment) begin
                        // Add one to mantissa, handle mantissa overflow
                        {round_increment, rounded_mant} <= {1'b0, rounded_mant} + 24'd1;

                        // If mantissa overflow (carry out), shift mantissa right and increment exponent
                        if (round_increment) begin
                            rounded_mant <= rounded_mant >> 1;
                            rounded_exp  <= rounded_exp + 9'd1;
                        end
                    end

                    // Handle special cases and assemble final output
                    if (s_a_nan || s_b_nan) begin
                        // Output quiet NaN: sign=0, exp=all 1s, mantissa MSB=1 + zeros
                        z <= {1'b0, EXP_MAX, 1'b1, 22'd0};
                    end else if ((s_a_inf && s_b_zero) || (s_b_inf && s_a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, EXP_MAX, 1'b1, 22'd0};
                    end else if (s_a_inf || s_b_inf) begin
                        // Infinity propagation, sign from result
                        z <= {rounded_sign, EXP_MAX, 23'd0};
                    end else if (s_a_zero || s_b_zero) begin
                        // Zero propagation, sign from result
                        z <= {rounded_sign, 31'd0};
                    end else begin
                        // Normal number or overflow/underflow cases

                        // Handle overflow (exponent >= 255) => infinity
                        if (rounded_exp >= EXP_MAX) begin
                            z <= {rounded_sign, EXP_MAX, 23'd0};
                        end
                        // Handle underflow (exponent <= 0) => zero (no gradual underflow handling)
                        else if (rounded_exp <= 0) begin
                            z <= {rounded_sign, 31'd0};
                        end else begin
                            // Normal assemble: sign, exponent (8 bits), mantissa (23 bits)
                            z <= {rounded_sign, rounded_exp[7:0], rounded_mant[22:0]};
                        end
                    end

                    busy <= 1'b0;
                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule
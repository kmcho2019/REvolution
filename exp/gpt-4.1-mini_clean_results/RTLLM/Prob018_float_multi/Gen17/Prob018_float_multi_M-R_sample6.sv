module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // FSM state encoding
    typedef enum reg [1:0] {
        DECODE      = 2'd0,
        MULTIPLY    = 2'd1,
        NORMALIZE   = 2'd2,
        ROUND_OUTPUT= 2'd3
    } state_t;

    reg [1:0] state, next_state;

    // Input extraction signals (combinational)
    wire a_sign  = a[31];
    wire b_sign  = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_is_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_is_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Registered signals updated in each state
    reg reg_a_sign, reg_b_sign;
    reg [7:0] reg_a_exp, reg_b_exp;
    reg [22:0] reg_a_frac, reg_b_frac;

    reg [23:0] a_mantissa; // with implicit leading 1 if normalized
    reg [23:0] b_mantissa;

    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    reg sign_res;
    reg [9:0] exp_sum;

    reg [47:0] product;  // 24x24 product

    // Normalization registers
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [24:0] mantissa_rounded;
    reg [9:0] exponent_rounded;

    // Sticky bit calculation helper
    function automatic bit calc_sticky(input [21:0] bits);
        integer i;
        begin
            calc_sticky = 1'b0;
            for (i=0; i<22; i=i+1)
                if (bits[i]) calc_sticky = 1'b1;
        end
    endfunction

    // Next state logic combinational
    always @(*) begin
        case(state)
            DECODE: next_state = MULTIPLY;
            MULTIPLY: next_state = NORMALIZE;
            NORMALIZE: next_state = ROUND_OUTPUT;
            ROUND_OUTPUT: next_state = DECODE;
            default: next_state = DECODE;
        endcase
    end

    // State transition and sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= DECODE;
            z <= 32'd0;

            // Clear all registers
            reg_a_sign <= 1'b0; reg_b_sign <= 1'b0;
            reg_a_exp <= 8'd0; reg_b_exp <= 8'd0;
            reg_a_frac <= 23'd0; reg_b_frac <= 23'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;
            sign_res <= 1'b0;
            exp_sum <= 10'd0;
            product <= 48'd0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;
            exponent_rounded <= 10'd0;
        end else begin
            state <= next_state;
            case (state)
                DECODE: begin
                    // Register inputs and flags
                    reg_a_sign <= a_sign;
                    reg_b_sign <= b_sign;
                    reg_a_exp <= a_exp;
                    reg_b_exp <= b_exp;
                    reg_a_frac <= a_frac;
                    reg_b_frac <= b_frac;

                    a_zero <= a_is_zero;
                    b_zero <= b_is_zero;
                    a_inf <= a_is_inf;
                    b_inf <= b_is_inf;
                    a_nan <= a_is_nan;
                    b_nan <= b_is_nan;

                    // Prepare mantissas with implicit leading 1 if normalized (exp != 0)
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Sign of result
                    sign_res <= a_sign ^ b_sign;

                    // Clear other regs for safety (not strictly needed)
                    exp_sum <= 10'd0;
                    product <= 48'd0;
                end

                MULTIPLY: begin
                    // Multiply mantissas 24x24 to get 48 bits
                    product <= a_mantissa * b_mantissa;
                    // Sum exponents and subtract bias
                    exp_sum <= reg_a_exp + reg_b_exp - EXP_BIAS;
                end

                NORMALIZE: begin
                    // Normalize product and extract rounding bits

                    if (product[47]) begin
                        // product >= 2.0, shift right by 1, increment exponent
                        norm_mantissa <= product[47:24]; // top 24 bits after shift
                        norm_exponent <= exp_sum + 10'd1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // product < 2.0, no shift
                        norm_mantissa <= product[46:23]; // top 24 bits directly
                        norm_exponent <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end

                ROUND_OUTPUT: begin
                    // Handle special cases
                    if (a_nan || b_nan) begin
                        // Output quiet NaN: sign=0, exponent=all 1s, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Result is infinity
                        z <= {sign_res, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Result is zero
                        z <= {sign_res, 31'd0};
                    end else begin
                        // Normal rounding (round to nearest even)
                        if (guard_bit && (round_bit | sticky_bit | norm_mantissa[0]))
                            mantissa_rounded <= {1'b0, norm_mantissa} + 25'd1;
                        else
                            mantissa_rounded <= {1'b0, norm_mantissa};

                        if (mantissa_rounded[24]) begin
                            // Mantissa overflowed after rounding
                            exponent_rounded <= norm_exponent + 10'd1;
                            if (exponent_rounded[7:0] >= 8'hFF) begin
                                // Overflow to infinity
                                z <= {sign_res, 8'hFF, 23'd0};
                            end else begin
                                // Shift right by 1 (drop lowest bit)
                                z <= {sign_res, exponent_rounded[7:0], mantissa_rounded[23:1]};
                            end
                        end else begin
                            exponent_rounded <= norm_exponent;
                            if (exponent_rounded[7:0] >= 8'hFF) begin
                                // Overflow to infinity
                                z <= {sign_res, 8'hFF, 23'd0};
                            end else if (exponent_rounded <= 0) begin
                                // Underflow to zero
                                z <= {sign_res, 31'd0};
                            end else begin
                                z <= {sign_res, exponent_rounded[7:0], mantissa_rounded[22:0]};
                            end
                        end
                    end
                end
            endcase
        end
    end

endmodule
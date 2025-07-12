module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // State encoding
    localparam S_IDLE       = 3'd0;
    localparam S_EXTRACT    = 3'd1;
    localparam S_MULTIPLY   = 3'd2;
    localparam S_NORMALIZE  = 3'd3;
    localparam S_ROUND      = 3'd4;
    localparam S_OUTPUT     = 3'd5;

    reg [2:0] state, next_state;

    // --------------------
    // Combinational extraction of input fields and special cases
    wire        a_sign = a[31];
    wire        b_sign = b[31];
    wire [7:0]  a_exponent = a[30:23];
    wire [7:0]  b_exponent = b[30:23];
    wire [22:0] a_fraction = a[22:0];
    wire [22:0] b_fraction = b[22:0];

    wire a_zero = (a_exponent == 8'd0) && (a_fraction == 23'd0);
    wire b_zero = (b_exponent == 8'd0) && (b_fraction == 23'd0);

    wire a_inf  = (a_exponent == 8'hFF) && (a_fraction == 23'd0);
    wire b_inf  = (b_exponent == 8'hFF) && (b_fraction == 23'd0);

    wire a_nan  = (a_exponent == 8'hFF) && (a_fraction != 23'd0);
    wire b_nan  = (b_exponent == 8'hFF) && (b_fraction != 23'd0);

    // Mantissas with implicit leading 1 (if normalized), else leading 0 (denormals)
    wire [23:0] a_mantissa = (a_exponent == 8'd0) ? {1'b0, a_fraction} : {1'b1, a_fraction};
    wire [23:0] b_mantissa = (b_exponent == 8'd0) ? {1'b0, b_fraction} : {1'b1, b_fraction};

    // Output registers to hold intermediate results
    reg         z_sign;
    reg [9:0]   z_exponent;   // wider width for exponent arithmetic
    reg [23:0]  z_mantissa;

    // Product register updated in multiply stage
    reg [47:0] product;

    // Normalization and rounding control bits
    reg guard_bit, round_bit, sticky_bit;

    // Intermediate mantissa and exponent after rounding
    reg [24:0] mantissa_rounded; // 25 bits to hold rounding carry
    reg [9:0]  exponent_rounded;

    // Internal flags for special cases saved in registers at extraction
    reg a_zero_r, b_zero_r;
    reg a_inf_r, b_inf_r;
    reg a_nan_r, b_nan_r;
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [23:0] a_mantissa_r, b_mantissa_r;

    // State machine sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            product <= 48'd0;
            z_sign <= 1'b0;
            z_exponent <= 10'd0;
            z_mantissa <= 24'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;
            exponent_rounded <= 10'd0;

            a_zero_r <= 1'b0; b_zero_r <= 1'b0;
            a_inf_r <= 1'b0;  b_inf_r <= 1'b0;
            a_nan_r <= 1'b0;  b_nan_r <= 1'b0;
            a_sign_r <= 1'b0; b_sign_r <= 1'b0;
            a_exp_r <= 8'd0;  b_exp_r <= 8'd0;
            a_mantissa_r <= 24'd0; b_mantissa_r <= 24'd0;

            z <= 32'd0;
        end else begin
            state <= next_state;

            case(state)
                S_IDLE: begin
                    // Wait here - move to extraction next cycle
                    z <= 32'd0;
                end
                S_EXTRACT: begin
                    // Register input fields and special case flags
                    a_zero_r <= a_zero;
                    b_zero_r <= b_zero;
                    a_inf_r <= a_inf;
                    b_inf_r <= b_inf;
                    a_nan_r <= a_nan;
                    b_nan_r <= b_nan;
                    a_sign_r <= a_sign;
                    b_sign_r <= b_sign;
                    a_exp_r <= a_exponent;
                    b_exp_r <= b_exponent;
                    a_mantissa_r <= a_mantissa;
                    b_mantissa_r <= b_mantissa;
                end
                S_MULTIPLY: begin
                    // Perform mantissa multiplication and exponent add/subtract bias
                    product <= a_mantissa_r * b_mantissa_r;
                    z_exponent <= a_exp_r + b_exp_r - EXP_BIAS;
                    z_sign <= a_sign_r ^ b_sign_r;
                end
                S_NORMALIZE: begin
                    // Normalization step based on product MSB
                    if (product[47]) begin
                        // MSB 1 at bit 47 - normalized
                        z_exponent <= z_exponent + 1;
                        z_mantissa <= product[47:24]; // top 24 bits
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB 0 at bit 47 - need left shift by 1, exponent stays same
                        z_mantissa <= product[46:23]; // shifted right by 1 bit compared to above
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end
                S_ROUND: begin
                    // Round to nearest even
                    mantissa_rounded <= {1'b0, z_mantissa} + (guard_bit & (round_bit | sticky_bit | z_mantissa[0]) ? 25'd1 : 25'd0);

                    if (mantissa_rounded[24]) begin
                        // Overflow in mantissa after rounding
                        exponent_rounded <= z_exponent + 1;
                        z_mantissa <= mantissa_rounded[24:2]; // shift right one to fit 23 bits
                    end else begin
                        exponent_rounded <= z_exponent;
                        z_mantissa <= mantissa_rounded[23:1];
                    end
                end
                S_OUTPUT: begin
                    // Final output assembly with special case handling

                    // Handle special cases first
                    if (a_nan_r || b_nan_r) begin
                        // Quiet NaN (MSB mantissa 1)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf_r && b_zero_r) || (b_inf_r && a_zero_r)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf_r || b_inf_r) begin
                        // Inf * nonzero = Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_zero_r || b_zero_r) begin
                        // zero * anything = zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number with possible overflow/underflow checks
                        if (exponent_rounded >= 255) begin
                            // Overflow to infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (exponent_rounded <= 0) begin
                            // Underflow to zero (flush to zero)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal case
                            z <= {z_sign, exponent_rounded[7:0], z_mantissa[22:0]};
                        end
                    end
                end
            endcase
        end
    end

    // State machine next state logic
    always @(*) begin
        case(state)
            S_IDLE:      next_state = S_EXTRACT;
            S_EXTRACT:   next_state = S_MULTIPLY;
            S_MULTIPLY:  next_state = S_NORMALIZE;
            S_NORMALIZE: next_state = S_ROUND;
            S_ROUND:     next_state = S_OUTPUT;
            S_OUTPUT:    next_state = S_IDLE;
            default:     next_state = S_IDLE;
        endcase
    end

endmodule
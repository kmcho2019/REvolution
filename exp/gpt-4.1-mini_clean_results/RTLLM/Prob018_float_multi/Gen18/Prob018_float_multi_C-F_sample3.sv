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
        ROUND_OUTPUT= 2'd2
    } state_t;

    reg [1:0] state, next_state;

    // Stage 1 registers: extracted fields and flags
    reg          a_sign_s1, b_sign_s1;
    reg  [7:0]   a_exp_s1, b_exp_s1;
    reg  [22:0]  a_frac_s1, b_frac_s1;
    reg          a_zero_s1, b_zero_s1;
    reg          a_inf_s1,  b_inf_s1;
    reg          a_nan_s1,  b_nan_s1;
    reg  [23:0]  a_mant_s1, b_mant_s1;

    // Stage 2 registers: product, exponent sum, sign, special flags and normalization intermediate
    reg  [47:0]  product_s2;
    reg  [9:0]   exp_sum_s2; // extended exponent sum with bias subtraction
    reg          sign_s2;
    reg          special_nan_s2;
    reg          special_nan_out_s2; // Inf*0=NaN special case
    reg          special_inf_s2;
    reg          special_zero_s2;

    reg  [23:0]  norm_mant_s2;
    reg  [9:0]   norm_exp_s2;
    reg          guard_bit_s2;
    reg          round_bit_s2;
    reg          sticky_bit_s2;

    // Stage 3 registers: rounded mantissa, exponent, final sign
    reg  [24:0]  mant_rounded_s3;
    reg  [9:0]   exp_rounded_s3;
    reg          sign_s3;

    // Sticky bit helper (combinational)
    wire sticky_bit_stage2;
    assign sticky_bit_stage2 = |( (product_s2[ ( (product_s2[47] ? 21 : 20) ) : 0 ]) );

    // Special case detection helpers (combinational) for inputs
    wire a_zero_w = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_zero_w = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
    wire a_inf_w  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_inf_w  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
    wire a_nan_w  = (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
    wire b_nan_w  = (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

    // Mantissas with implicit leading 1 for normalized inputs else 0
    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Next state logic
    always @(*) begin
        case(state)
            DECODE: next_state = MULTIPLY;
            MULTIPLY: next_state = ROUND_OUTPUT;
            ROUND_OUTPUT: next_state = DECODE;
            default: next_state = DECODE;
        endcase
    end

    // Main pipeline FSM and data path
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers and output
            state <= DECODE;

            // Stage 1 regs
            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_frac_s1 <= 23'd0; b_frac_s1 <= 23'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;

            // Stage 2 regs
            product_s2 <= 48'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            special_nan_s2 <= 1'b0;
            special_nan_out_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;
            norm_mant_s2 <= 24'd0;
            norm_exp_s2 <= 10'd0;
            guard_bit_s2 <= 1'b0;
            round_bit_s2 <= 1'b0;
            sticky_bit_s2 <= 1'b0;

            // Stage 3 regs
            mant_rounded_s3 <= 25'd0;
            exp_rounded_s3 <= 10'd0;
            sign_s3 <= 1'b0;

            // Output
            z <= 32'd0;
        end else begin
            state <= next_state;

            case (state)
                DECODE: begin
                    // Register input fields and special cases
                    a_sign_s1 <= a[31];
                    b_sign_s1 <= b[31];
                    a_exp_s1 <= a[30:23];
                    b_exp_s1 <= b[30:23];
                    a_frac_s1 <= a[22:0];
                    b_frac_s1 <= b[22:0];
                    a_zero_s1 <= a_zero_w;
                    b_zero_s1 <= b_zero_w;
                    a_inf_s1 <= a_inf_w;
                    b_inf_s1 <= b_inf_w;
                    a_nan_s1 <= a_nan_w;
                    b_nan_s1 <= b_nan_w;
                    a_mant_s1 <= a_mant_w;
                    b_mant_s1 <= b_mant_w;
                end

                MULTIPLY: begin
                    // Multiply mantissas and add exponents with bias correction
                    product_s2 <= a_mant_s1 * b_mant_s1;
                    exp_sum_s2 <= {2'd0, a_exp_s1} + {2'd0, b_exp_s1} - EXP_BIAS;
                    sign_s2 <= a_sign_s1 ^ b_sign_s1;

                    // Detect special cases for output selection
                    special_nan_s2 <= a_nan_s1 || b_nan_s1;
                    special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
                    special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;
                    special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;

                    // Normalize product and prepare rounding bits
                    if (product_s2[47]) begin
                        // Leading one at bit 47 means shift right and increment exponent
                        norm_mant_s2 <= product_s2[47:24];   // top 24 bits after shift
                        norm_exp_s2 <= exp_sum_s2 + 10'd1;
                        guard_bit_s2 <= product_s2[23];
                        round_bit_s2 <= product_s2[22];
                        sticky_bit_s2 <= |product_s2[21:0];
                    end else begin
                        // Leading one at bit 46 or below, no shift
                        norm_mant_s2 <= product_s2[46:23];   // top 24 bits
                        norm_exp_s2 <= exp_sum_s2;
                        guard_bit_s2 <= product_s2[22];
                        round_bit_s2 <= product_s2[21];
                        sticky_bit_s2 <= |product_s2[20:0];
                    end
                end

                ROUND_OUTPUT: begin
                    sign_s3 <= sign_s2;

                    // Round to nearest even
                    if (guard_bit_s2 && (round_bit_s2 || sticky_bit_s2 || norm_mant_s2[0]))
                        mant_rounded_s3 <= {1'b0, norm_mant_s2} + 25'd1;
                    else
                        mant_rounded_s3 <= {1'b0, norm_mant_s2};

                    exp_rounded_s3 <= norm_exp_s2;

                    // After rounding, check for mantissa overflow (bit 24 set)
                    if (mant_rounded_s3[24]) begin
                        exp_rounded_s3 <= norm_exp_s2 + 10'd1;
                        mant_rounded_s3 <= mant_rounded_s3 >> 1; // Shift right by 1
                    end

                    // Output generation happens combinationally after state update
                    // So defer output assignment to below
                end
            endcase

            // Output generation combinational with priority: special cases, overflow, underflow, normal
            if (state == ROUND_OUTPUT) begin
                if (special_nan_s2) begin
                    // Quiet NaN canonical: sign=0, exp=255, mantissa MSB=1
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_nan_out_s2) begin
                    // NaN output due to Inf*0 special case
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf_s2) begin
                    // Infinity output with correct sign
                    z <= {sign_s2, 8'hFF, 23'd0};
                end else if (special_zero_s2) begin
                    // Zero output with correct sign
                    z <= {sign_s2, 31'd0};
                end else if (exp_rounded_s3 >= 10'd255) begin
                    // Overflow to infinity
                    z <= {sign_s3, 8'hFF, 23'd0};
                end else if (exp_rounded_s3 <= 10'd0) begin
                    // Underflow to zero (no gradual underflow implemented)
                    z <= {sign_s3, 31'd0};
                end else begin
                    // Normal output: sign, exponent (8 bits), mantissa (23 bits)
                    z <= {sign_s3, exp_rounded_s3[7:0], mant_rounded_s3[22:0]};
                end
            end
        end
    end

endmodule
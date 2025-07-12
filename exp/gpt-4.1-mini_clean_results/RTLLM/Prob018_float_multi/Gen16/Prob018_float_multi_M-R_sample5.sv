module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;
    localparam IDLE     = 3'd0;
    localparam STAGE1   = 3'd1; // Extract & special case detect + sign, exponent, mantissa latch
    localparam STAGE2   = 3'd2; // Multiply mantissas + exponent add
    localparam STAGE3   = 3'd3; // Normalize + rounding + assemble output

    reg [2:0] counter;

    // ----- Stage 1 registers -----
    reg a_sign_s1, b_sign_s1;
    reg [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;
    reg a_is_zero_s1, b_is_zero_s1;
    reg a_is_inf_s1,  b_is_inf_s1;
    reg a_is_nan_s1,  b_is_nan_s1;
    reg [23:0] a_mant_s1, b_mant_s1;
    reg sign_s1;
    reg operand_valid_s1;

    // ----- Stage 2 registers -----
    reg [47:0] product_s2;
    reg [9:0]  exp_sum_s2; // extended to 10 bits for safe margin
    reg sign_s2;
    reg a_is_zero_s2, b_is_zero_s2;
    reg a_is_inf_s2,  b_is_inf_s2;
    reg a_is_nan_s2,  b_is_nan_s2;
    reg operand_valid_s2;

    // ----- Stage 3 registers -----
    reg [47:0] product_s3;
    reg [9:0]  exp_sum_s3;
    reg sign_s3;
    reg a_is_zero_s3, b_is_zero_s3;
    reg a_is_inf_s3,  b_is_inf_s3;
    reg a_is_nan_s3,  b_is_nan_s3;
    reg operand_valid_s3;

    // Normalization outputs for stage3
    reg [23:0] mant_norm_s3;
    reg guard_s3, round_s3, sticky_s3;
    reg [9:0] exp_norm_s3;

    // Rounded mantissa and exponent final
    reg [24:0] mant_round_s3;
    reg [8:0] exp_final_s3;
    reg sign_final_s3;

    // Sticky bit OR reduction function
    function sticky_or;
        input [21:0] bits;
        integer i;
        begin
            sticky_or = 1'b0;
            for (i=0; i<22; i=i+1) sticky_or = sticky_or | bits[i];
        end
    endfunction

    // FSM counter controls pipeline stages; wraps from 0 to 3 and back
    always @(posedge clk or posedge rst) begin
        if (rst) counter <= IDLE;
        else counter <= (counter == STAGE3) ? IDLE : counter + 1'b1;
    end

    // Stage 1: Extraction and special case detection; combinational from inputs, registered on STAGE1
    wire [7:0] a_exp_w = a[30:23];
    wire [7:0] b_exp_w = b[30:23];
    wire [22:0] a_frac_w = a[22:0];
    wire [22:0] b_frac_w = b[22:0];
    wire a_sign_w = a[31];
    wire b_sign_w = b[31];

    wire a_is_zero_w = (a_exp_w == 8'd0) && (a_frac_w == 0);
    wire b_is_zero_w = (b_exp_w == 8'd0) && (b_frac_w == 0);
    wire a_is_inf_w = (a_exp_w == 8'hFF) && (a_frac_w == 0);
    wire b_is_inf_w = (b_exp_w == 8'hFF) && (b_frac_w == 0);
    wire a_is_nan_w = (a_exp_w == 8'hFF) && (a_frac_w != 0);
    wire b_is_nan_w = (b_exp_w == 8'hFF) && (b_frac_w != 0);

    wire [23:0] a_mant_w = (a_exp_w == 8'd0) ? {1'b0, a_frac_w} : {1'b1, a_frac_w};
    wire [23:0] b_mant_w = (b_exp_w == 8'd0) ? {1'b0, b_frac_w} : {1'b1, b_frac_w};
    wire sign_w = a_sign_w ^ b_sign_w;

    wire operand_valid_w = ~ (a_is_nan_w | b_is_nan_w);

    always @(posedge clk) begin
        if (counter == STAGE1) begin
            a_sign_s1 <= a_sign_w;
            b_sign_s1 <= b_sign_w;
            a_exp_s1 <= a_exp_w;
            b_exp_s1 <= b_exp_w;
            a_frac_s1 <= a_frac_w;
            b_frac_s1 <= b_frac_w;
            a_is_zero_s1 <= a_is_zero_w;
            b_is_zero_s1 <= b_is_zero_w;
            a_is_inf_s1 <= a_is_inf_w;
            b_is_inf_s1 <= b_is_inf_w;
            a_is_nan_s1 <= a_is_nan_w;
            b_is_nan_s1 <= b_is_nan_w;
            a_mant_s1 <= a_mant_w;
            b_mant_s1 <= b_mant_w;
            sign_s1 <= sign_w;
            operand_valid_s1 <= operand_valid_w;
        end
    end

    // Stage 2: Multiply mantissas and add exponents; registered on STAGE2
    always @(posedge clk) begin
        if (counter == STAGE2) begin
            // Propagate special cases and sign
            a_is_zero_s2 <= a_is_zero_s1;
            b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2 <= a_is_inf_s1;
            b_is_inf_s2 <= b_is_inf_s1;
            a_is_nan_s2 <= a_is_nan_s1;
            b_is_nan_s2 <= b_is_nan_s1;
            sign_s2 <= sign_s1;
            operand_valid_s2 <= operand_valid_s1;

            if (operand_valid_s1) begin
                product_s2 <= a_mant_s1 * b_mant_s1; // 24x24=48 bits
                // exponent sum with bias subtraction
                exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;
            end else begin
                product_s2 <= 48'd0;
                exp_sum_s2 <= 10'd0;
            end
        end
    end

    // Stage 3: Normalization, rounding bits extraction and final assembly; registered on STAGE3
    always @(posedge clk) begin
        if (counter == STAGE3) begin
            a_is_zero_s3 <= a_is_zero_s2;
            b_is_zero_s3 <= b_is_zero_s2;
            a_is_inf_s3 <= a_is_inf_s2;
            b_is_inf_s3 <= b_is_inf_s2;
            a_is_nan_s3 <= a_is_nan_s2;
            b_is_nan_s3 <= b_is_nan_s2;
            sign_s3 <= sign_s2;
            operand_valid_s3 <= operand_valid_s2;

            product_s3 <= product_s2;
            exp_sum_s3 <= exp_sum_s2;

            // Normalization step
            if (operand_valid_s2) begin
                if (product_s2[47]) begin
                    // MSB set, shift right by 1 and increment exponent
                    mant_norm_s3 <= product_s2[47:24];
                    exp_norm_s3 <= exp_sum_s2 + 10'd1;
                    guard_s3 <= product_s2[23];
                    round_s3 <= product_s2[22];
                    sticky_s3 <= sticky_or(product_s2[21:0]);
                end else begin
                    mant_norm_s3 <= product_s2[46:23];
                    exp_norm_s3 <= exp_sum_s2;
                    guard_s3 <= product_s2[22];
                    round_s3 <= product_s2[21];
                    sticky_s3 <= sticky_or(product_s2[20:0]);
                end
            end else begin
                mant_norm_s3 <= 24'd0;
                guard_s3 <= 1'b0;
                round_s3 <= 1'b0;
                sticky_s3 <= 1'b0;
                exp_norm_s3 <= 10'd0;
            end

            // Rounding to nearest even
            if (operand_valid_s2) begin
                // Round increment when guard=1 and (round or sticky or LSB mantissa=1)
                if (guard_s3 && (round_s3 || sticky_s3 || mant_norm_s3[0]))
                    mant_round_s3 <= {1'b0, mant_norm_s3} + 25'd1;
                else
                    mant_round_s3 <= {1'b0, mant_norm_s3};

                // Check if rounding caused mantissa overflow (25 bits)
                if (mant_round_s3[24]) begin
                    exp_final_s3 <= exp_norm_s3[8:0] + 9'd1;
                    // After overflow, shift mantissa right by one (drop LSB)
                    mant_norm_s3 <= mant_round_s3[24:1]; // updated for output below
                end else begin
                    exp_final_s3 <= exp_norm_s3[8:0];
                end
            end else begin
                mant_round_s3 <= 25'd0;
                exp_final_s3 <= 9'd0;
            end

            sign_final_s3 <= sign_s3;

            // Output assembly and special cases handled combinationally below (using registers above)
        end
    end

    // Output logic combinational, updated synchronously in final stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else if (counter == STAGE3) begin
            // Priority for special cases
            if (a_is_nan_s3 || b_is_nan_s3) begin
                // Quiet NaN (sign=0, exp=all 1s, MSB mantissa=1)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_is_inf_s3 && b_is_zero_s3) || (b_is_inf_s3 && a_is_zero_s3)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_is_inf_s3 || b_is_inf_s3) begin
                // Inf times non-zero or Inf times Inf = Inf
                z <= {sign_final_s3, 8'hFF, 23'd0};
            end else if (a_is_zero_s3 || b_is_zero_s3) begin
                // Zero times anything = Zero
                z <= {sign_final_s3, 31'd0};
            end else begin
                // Normal number path: check overflow/underflow
                if (exp_final_s3 >= 9'hFF) begin
                    // Overflow to infinity
                    z <= {sign_final_s3, 8'hFF, 23'd0};
                end else if (exp_final_s3 <= 0) begin
                    // Underflow to zero (no gradual underflow implemented)
                    z <= {sign_final_s3, 31'd0};
                end else begin
                    // Normalized result
                    // mantissa is lower 23 bits; mant_norm_s3 might be updated by rounding overflow
                    z <= {sign_final_s3, exp_final_s3[7:0], mant_round_s3[22:0]};
                end
            end
        end
    end

endmodule
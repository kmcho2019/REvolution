module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1 registers
    reg [23:0] a_mantissa_s1, b_mantissa_s1;
    reg [9:0] a_exponent_s1, b_exponent_s1;
    reg a_sign_s1, b_sign_s1;
    reg a_is_zero_s1, b_is_zero_s1;
    reg a_is_inf_s1, b_is_inf_s1;
    reg a_is_nan_s1, b_is_nan_s1;
    reg special_case_s1;

    // Pipeline stage 2 registers
    reg [47:0] product_s2;
    reg [9:0] z_exponent_s2;
    reg z_sign_s2;
    reg special_case_s2;
    reg was_subnormal_s2;

    // Pipeline stage 3 registers
    reg [23:0] z_mantissa_s3;
    reg [9:0] z_exponent_s3;
    reg z_sign_s3;
    reg special_case_s3;

    // Combinational logic for special cases
    wire a_is_zero = (a[30:0] == 0);
    wire b_is_zero = (b[30:0] == 0);
    wire a_is_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_is_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_is_nan = (&a[30:23]) && (|a[22:0]);
    wire b_is_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_is_nan | b_is_nan | 
                       a_is_inf | b_is_inf |
                       (a_is_zero & b_is_inf) | (a_is_inf & b_is_zero) |
                       a_is_zero | b_is_zero;

    // Special case result (NaN has highest priority)
    wire [31:0] special_result = 
        (a_is_nan | b_is_nan | (a_is_zero & b_is_inf) | (a_is_inf & b_is_zero)) ? 
            {a_sign_s1 ^ b_sign_s1, 8'hFF, 23'h400000} : // NaN
        (a_is_inf | b_is_inf) ? 
            {a_sign_s1 ^ b_sign_s1, 8'hFF, 23'h000000} : // Inf
            {a_sign_s1 ^ b_sign_s1, 31'h00000000};      // Zero

    // Pipeline stage 1: Input processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_mantissa_s1 <= 0;
            b_mantissa_s1 <= 0;
            a_exponent_s1 <= 0;
            b_exponent_s1 <= 0;
            a_sign_s1 <= 0;
            b_sign_s1 <= 0;
            a_is_zero_s1 <= 0;
            b_is_zero_s1 <= 0;
            a_is_inf_s1 <= 0;
            b_is_inf_s1 <= 0;
            a_is_nan_s1 <= 0;
            b_is_nan_s1 <= 0;
            special_case_s1 <= 0;
        end else begin
            a_sign_s1 <= a[31];
            b_sign_s1 <= b[31];
            a_exponent_s1 <= {2'b0, a[30:23]};
            b_exponent_s1 <= {2'b0, b[30:23]};
            a_mantissa_s1 <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa_s1 <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
            a_is_zero_s1 <= a_is_zero;
            b_is_zero_s1 <= b_is_zero;
            a_is_inf_s1 <= a_is_inf;
            b_is_inf_s1 <= b_is_inf;
            a_is_nan_s1 <= a_is_nan;
            b_is_nan_s1 <= b_is_nan;
            special_case_s1 <= special_case;
        end
    end

    // Pipeline stage 2: Multiplication
    wire [47:0] product = a_mantissa_s1 * b_mantissa_s1;
    wire [9:0] exponent_sum = a_exponent_s1 + b_exponent_s1;
    wire both_denormal = (a_exponent_s1 == 0) & (b_exponent_s1 == 0);
    wire was_subnormal = (a_exponent_s1 == 0) | (b_exponent_s1 == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 0;
            z_exponent_s2 <= 0;
            z_sign_s2 <= 0;
            special_case_s2 <= 0;
            was_subnormal_s2 <= 0;
        end else begin
            product_s2 <= product;
            // Adjust exponent: sum - bias + normalization + subnormal adjustment
            z_exponent_s2 <= exponent_sum - 127 + (product[47] ? 1 : 0) - (both_denormal ? 1 : 0);
            z_sign_s2 <= a_sign_s1 ^ b_sign_s1;
            special_case_s2 <= special_case_s1;
            was_subnormal_s2 <= was_subnormal;
        end
    end

    // Pipeline stage 3: Normalization and rounding
    wire [47:0] normalized_product = product_s2[47] ? product_s2 : (product_s2 << 1);
    wire [9:0] adjusted_exponent = z_exponent_s2;
    wire guard_bit = normalized_product[22];
    wire round_bit = normalized_product[21];
    wire sticky = |normalized_product[20:0] | (was_subnormal_s2 & |normalized_product[47:23]);
    wire [23:0] pre_round_mantissa = normalized_product[46:23];
    wire do_round = guard_bit & (round_bit | sticky | pre_round_mantissa[0]);
    wire [23:0] rounded_mantissa = pre_round_mantissa + do_round;
    wire mantissa_overflow = &pre_round_mantissa & do_round;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z_mantissa_s3 <= 0;
            z_exponent_s3 <= 0;
            z_sign_s3 <= 0;
            special_case_s3 <= 0;
        end else begin
            z_mantissa_s3 <= mantissa_overflow ? 24'h800000 : rounded_mantissa;
            z_exponent_s3 <= mantissa_overflow ? adjusted_exponent + 1 : adjusted_exponent;
            z_sign_s3 <= z_sign_s2;
            special_case_s3 <= special_case_s2;
        end
    end

    // Final output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (special_case_s3) begin
                z <= special_result;
            end else if (z_exponent_s3[9] || (z_exponent_s3 >= 255)) begin
                z <= {z_sign_s3, 8'hFF, 23'h000000}; // Overflow -> Inf
            end else if (z_exponent_s3 == 0) begin
                z <= {z_sign_s3, 31'h00000000}; // Underflow -> Zero
            end else begin
                z <= {z_sign_s3, z_exponent_s3[7:0], z_mantissa_s3[22:0]};
            end
        end
    end

endmodule
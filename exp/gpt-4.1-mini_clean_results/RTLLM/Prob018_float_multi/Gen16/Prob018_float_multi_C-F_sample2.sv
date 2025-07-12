module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // Stage 1 registers: extracted fields of inputs and flags
    reg          a_sign_s1, b_sign_s1;
    reg  [7:0]   a_exp_s1, b_exp_s1;
    reg  [22:0]  a_frac_s1, b_frac_s1;
    reg          a_zero_s1, b_zero_s1;
    reg          a_inf_s1,  b_inf_s1;
    reg          a_nan_s1,  b_nan_s1;
    reg  [23:0]  a_mant_s1, b_mant_s1;

    // Stage 2 registers: product, exponent sum, sign, special flags
    reg  [47:0]  product_s2;
    reg  [9:0]   exp_sum_s2; // 10 bits to hold exponent addition + bias subtraction
    reg          sign_s2;
    reg          special_nan_s2;
    reg          special_inf_s2;
    reg          special_zero_s2;
    reg          special_nan_out_s2; // For Inf*0=NaN special case

    // Stage 3 registers: normalization, rounding bits, adjusted exponent, rounded mantissa and sign
    reg  [47:0]  norm_product_s3;
    reg  [9:0]   norm_exp_s3;
    reg          guard_bit_s3;
    reg          round_bit_s3;
    reg          sticky_bit_s3;
    reg  [23:0]  mantissa_s3;

    reg          round_increment_s3;
    reg  [24:0]  mant_rounded_s3;
    reg  [23:0]  mant_rounded_final_s3;
    reg  [9:0]   exp_rounded_s3;
    reg          sign_s3;

    // Helper functions for special case detection
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Wires for combinational special case detection and mantissa prep for stage 1 inputs
    wire a_zero_w = is_zero(a[30:23], a[22:0]);
    wire b_zero_w = is_zero(b[30:23], b[22:0]);
    wire a_inf_w  = is_inf(a[30:23], a[22:0]);
    wire b_inf_w  = is_inf(b[30:23], b[22:0]);
    wire a_nan_w  = is_nan(a[30:23], a[22:0]);
    wire b_nan_w  = is_nan(b[30:23], b[22:0]);

    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Pipeline logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset pipeline registers and output
            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_frac_s1 <= 23'd0; b_frac_s1 <= 23'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;

            product_s2 <= 48'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            special_nan_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;
            special_nan_out_s2 <= 1'b0;

            norm_product_s3 <= 48'd0;
            norm_exp_s3 <= 10'd0;
            guard_bit_s3 <= 1'b0;
            round_bit_s3 <= 1'b0;
            sticky_bit_s3 <= 1'b0;
            mantissa_s3 <= 24'd0;

            round_increment_s3 <= 1'b0;
            mant_rounded_s3 <= 25'd0;
            mant_rounded_final_s3 <= 24'd0;
            exp_rounded_s3 <= 10'd0;
            sign_s3 <= 1'b0;

            z <= 32'd0;
        end else begin
            // -------- STAGE 1: Input extraction and special case detection --------
            a_sign_s1 <= a[31];
            b_sign_s1 <= b[31];
            a_exp_s1 <= a[30:23];
            b_exp_s1 <= b[30:23];
            a_frac_s1 <= a[22:0];
            b_frac_s1 <= b[22:0];

            a_zero_s1 <= a_zero_w;
            b_zero_s1 <= b_zero_w;
            a_inf_s1  <= a_inf_w;
            b_inf_s1  <= b_inf_w;
            a_nan_s1  <= a_nan_w;
            b_nan_s1  <= b_nan_w;

            a_mant_s1 <= a_mant_w;
            b_mant_s1 <= b_mant_w;

            // -------- STAGE 2: Mantissa multiply, exponent add, sign XOR, special flags --------
            product_s2 <= a_mant_s1 * b_mant_s1;
            exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;
            sign_s2 <= a_sign_s1 ^ b_sign_s1;

            special_nan_s2 <= a_nan_s1 || b_nan_s1;
            // NaN output due to Inf * Zero special case
            special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
            special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;
            special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;

            // -------- STAGE 3: Normalize product, compute rounding bits, adjust exponent and mantissa --------
            // Normalize product:
            // If product MSB (bit 47) = 1, shift right 1 and increment exponent, else keep as is.
            if (product_s2[47]) begin
                norm_product_s3 <= product_s2 >> 1;
                norm_exp_s3 <= exp_sum_s2 + 10'd1;
            end else begin
                norm_product_s3 <= product_s2;
                norm_exp_s3 <= exp_sum_s2;
            end

            // Mantissa bits taken are bits [46:23] (24 bits)
            mantissa_s3 <= norm_product_s3[46:23];

            // Extract rounding bits for round-to-nearest-even
            guard_bit_s3 <= norm_product_s3[23];
            round_bit_s3 <= norm_product_s3[22];
            sticky_bit_s3 <= |norm_product_s3[21:0]; // OR reduction for sticky bit

            // Determine rounding increment: round to nearest even
            round_increment_s3 <= guard_bit_s3 && (round_bit_s3 || sticky_bit_s3 || mantissa_s3[0]);

            // Add rounding increment to mantissa (25 bits to handle carry)
            mant_rounded_s3 <= {1'b0, mantissa_s3} + round_increment_s3;

            // Handle mantissa overflow after rounding
            if (mant_rounded_s3[24]) begin
                mant_rounded_final_s3 <= mant_rounded_s3[24:1]; // Shift right 1
                exp_rounded_s3 <= norm_exp_s3 + 10'd1;
            end else begin
                mant_rounded_final_s3 <= mant_rounded_s3[23:0];
                exp_rounded_s3 <= norm_exp_s3;
            end

            sign_s3 <= sign_s2;

            // -------- OUTPUT generation --------
            // After stage 3 registers updated, generate final output
            if (special_nan_s2) begin
                // Quiet NaN canonical: sign=0, exp=255, mantissa MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_out_s2) begin
                // NaN output due to Inf*0 special case
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s2) begin
                // Infinity output, sign matches result sign
                z <= {sign_s2, 8'hFF, 23'd0};
            end else if (special_zero_s2) begin
                // Zero output, sign matches result sign
                z <= {sign_s2, 31'd0};
            end else if (exp_rounded_s3 >= 10'd255) begin
                // Overflow: output infinity
                z <= {sign_s3, 8'hFF, 23'd0};
            end else if (exp_rounded_s3 <= 10'd0) begin
                // Underflow: output zero (no gradual underflow supported)
                z <= {sign_s3, 31'd0};
            end else begin
                // Normal output: sign, exponent (8 bits), mantissa (23 bits)
                z <= {sign_s3, exp_rounded_s3[7:0], mant_rounded_final_s3[22:0]};
            end
        end
    end

endmodule
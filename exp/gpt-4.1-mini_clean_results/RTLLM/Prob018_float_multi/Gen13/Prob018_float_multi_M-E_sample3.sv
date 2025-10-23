module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // Pipeline cycle counter (3-bit) to track pipeline stage; reset on rst
    reg [2:0] counter;

    // Stage 1 registers: Extracted fields of inputs
    reg a_sign_s1, b_sign_s1;
    reg [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;
    reg a_zero_s1, b_zero_s1;
    reg a_inf_s1,  b_inf_s1;
    reg a_nan_s1,  b_nan_s1;

    // Mantissas with implicit leading 1 for normalized or 0 for denormals
    reg [23:0] a_mant_s1, b_mant_s1;

    // Stage 2 registers: product, sign, exponent sum, special flags
    reg [47:0] product_s2;
    reg [9:0]  exp_sum_s2; // 10 bits to catch overflow
    reg        sign_s2;
    reg        special_nan_s2;
    reg        special_nan_out_s2;
    reg        special_inf_s2;
    reg        special_zero_s2;

    // Stage 3 registers: normalized mantissa, exponent, rounding bits, final mantissa and exponent after rounding
    reg [47:0] norm_product_s3;
    reg [9:0]  norm_exp_s3;
    reg        guard_bit_s3;
    reg        round_bit_s3;
    reg        sticky_bit_s3;
    reg [23:0] mantissa_s3;

    reg        round_increment_s3;
    reg [24:0] mant_rounded_s3;
    reg [23:0] mant_rounded_final_s3;
    reg [9:0]  exp_rounded_s3;
    reg        sign_s3;

    // Helper function to detect zero, inf, nan
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Input extraction combinational block (Stage 1)
    wire a_zero_w = is_zero(a[30:23], a[22:0]);
    wire b_zero_w = is_zero(b[30:23], b[22:0]);
    wire a_inf_w = is_inf(a[30:23], a[22:0]);
    wire b_inf_w = is_inf(b[30:23], b[22:0]);
    wire a_nan_w = is_nan(a[30:23], a[22:0]);
    wire b_nan_w = is_nan(b[30:23], b[22:0]);

    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Sequential pipeline logic
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear stage registers
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
            special_nan_out_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;

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
        end else begin
            // Pipeline cycle counter increment (wrap-around at 3)
            counter <= counter == 3'd2 ? 3'd0 : counter + 3'd1;

            // Stage 1: sample inputs
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

            // Stage 2: mantissa multiply, exponent add, sign XOR, special flags
            // Multiply mantissas 24x24 = 48 bits combinationally, register result
            product_s2 <= a_mant_s1 * b_mant_s1;
            // Exponent sum: a_exp + b_exp - bias (bias 127) + possible normalization shift adjustment later
            exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;
            sign_s2 <= a_sign_s1 ^ b_sign_s1;

            special_nan_s2 <= a_nan_s1 || b_nan_s1;
            special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
            special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;
            special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;

            // Stage 3: normalization, rounding

            // Normalize product:
            // If MSB product_s2[47] == 1, shift right 1 and increment exponent by 1
            if (product_s2[47]) begin
                norm_product_s3 <= product_s2 >> 1;
                norm_exp_s3 <= exp_sum_s2 + 10'd1;
            end else begin
                norm_product_s3 <= product_s2;
                norm_exp_s3 <= exp_sum_s2;
            end

            // Extract mantissa bits [46:23]
            mantissa_s3 <= norm_product_s3[46:23];

            // Extract rounding bits for round to nearest even
            guard_bit_s3 <= norm_product_s3[23];
            round_bit_s3 <= norm_product_s3[22];
            sticky_bit_s3 <= |norm_product_s3[21:0];

            // Determine if rounding increment needed
            round_increment_s3 <= guard_bit_s3 && (round_bit_s3 || sticky_bit_s3 || mantissa_s3[0]);

            // Add rounding increment
            mant_rounded_s3 <= {1'b0, mantissa_s3} + round_increment_s3;

            // Check for mantissa overflow due to rounding, shift right if so and increment exponent
            if (mant_rounded_s3[24]) begin
                mant_rounded_final_s3 <= mant_rounded_s3[24:1];
                exp_rounded_s3 <= norm_exp_s3 + 10'd1;
            end else begin
                mant_rounded_final_s3 <= mant_rounded_s3[23:0];
                exp_rounded_s3 <= norm_exp_s3;
            end

            sign_s3 <= sign_s2;

            // Output register updates on last pipeline stage completion
            // Because pipeline latency is 3, output updates every cycle after initial latency

            // Compute final output
            // Handle special cases first
            if (special_nan_s2) begin
                // Quiet NaN canonical: sign=0, exp=255, mantissa MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_out_s2) begin
                // NaN output due to Inf*0
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s2) begin
                z <= {sign_s2, 8'hFF, 23'd0};
            end else if (special_zero_s2) begin
                z <= {sign_s2, 31'd0};
            end else if (exp_rounded_s3[9:8] != 2'b00) begin
                // Overflow: set to infinity with sign
                z <= {sign_s3, 8'hFF, 23'd0};
            end else if (exp_rounded_s3[9:0] == 10'd0) begin
                // Underflow: zero (no subnormal supported)
                z <= {sign_s3, 31'd0};
            end else begin
                // Normal number
                z <= {sign_s3, exp_rounded_s3[7:0], mant_rounded_final_s3[22:0]};
            end
        end
    end

endmodule
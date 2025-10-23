module float_multi (
    input           clk,
    input           rst,        // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // -------- STAGE 1: Extract and preprocess inputs --------
    reg          a_sign_s1, b_sign_s1;
    reg  [7:0]   a_exp_s1, b_exp_s1;
    reg  [22:0]  a_frac_s1, b_frac_s1;
    reg          a_zero_s1, b_zero_s1;
    reg          a_inf_s1,  b_inf_s1;
    reg          a_nan_s1,  b_nan_s1;
    reg          a_denorm_s1, b_denorm_s1;
    reg  [23:0]  a_mant_s1, b_mant_s1;     // mantissa with explicit leading bit
    reg  [9:0]   a_exp_adj_s1, b_exp_adj_s1; // adjusted exponent for denormals and normals (to 10 bits)

    // Functions for special case detection (combinational)
    function automatic is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function automatic is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function automatic is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    function automatic is_denorm(input [7:0] e, input [22:0] f);
        is_denorm = (e == 8'd0) && (f != 23'd0);
    endfunction

    // -------- STAGE 2: Multiply mantissas and add exponents --------
    reg  [47:0]  product_s2;
    reg  [9:0]   exp_sum_s2;
    reg          sign_s2;
    reg          special_nan_s2;
    reg          special_inf_s2;
    reg          special_zero_s2;
    reg          special_nan_out_s2; // Inf*0=NaN special case

    // -------- STAGE 3: Normalize, round and finalize output --------
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

    // Combinational wires for input extraction (to ease readability)
    wire a_sign_w = a[31];
    wire [7:0] a_exp_w = a[30:23];
    wire [22:0] a_frac_w = a[22:0];
    wire b_sign_w = b[31];
    wire [7:0] b_exp_w = b[30:23];
    wire [22:0] b_frac_w = b[22:0];

    wire a_zero_w = is_zero(a_exp_w, a_frac_w);
    wire b_zero_w = is_zero(b_exp_w, b_frac_w);
    wire a_inf_w  = is_inf(a_exp_w, a_frac_w);
    wire b_inf_w  = is_inf(b_exp_w, b_frac_w);
    wire a_nan_w  = is_nan(a_exp_w, a_frac_w);
    wire b_nan_w  = is_nan(b_exp_w, b_frac_w);
    wire a_denorm_w = is_denorm(a_exp_w, a_frac_w);
    wire b_denorm_w = is_denorm(b_exp_w, b_frac_w);

    // Mantissas: normalized numbers have implicit leading 1, denormals and zero have 0
    wire [23:0] a_mant_w = (a_exp_w == 8'd0) ? {1'b0, a_frac_w} : {1'b1, a_frac_w};
    wire [23:0] b_mant_w = (b_exp_w == 8'd0) ? {1'b0, b_frac_w} : {1'b1, b_frac_w};

    // Adjust exponent to 10 bits, for denormals use 1, else normal exponent
    wire [9:0] a_exp_adj_w = (a_exp_w == 8'd0) ? 10'd1 : {2'd0, a_exp_w};
    wire [9:0] b_exp_adj_w = (b_exp_w == 8'd0) ? 10'd1 : {2'd0, b_exp_w};

    always @(posedge clk) begin
        if (rst) begin
            // Stage 1 reset
            a_sign_s1 <= 0; b_sign_s1 <= 0;
            a_exp_s1 <= 0; b_exp_s1 <= 0;
            a_frac_s1 <= 0; b_frac_s1 <= 0;
            a_zero_s1 <= 0; b_zero_s1 <= 0;
            a_inf_s1 <= 0; b_inf_s1 <= 0;
            a_nan_s1 <= 0; b_nan_s1 <= 0;
            a_denorm_s1 <= 0; b_denorm_s1 <= 0;
            a_mant_s1 <= 0; b_mant_s1 <= 0;
            a_exp_adj_s1 <= 0; b_exp_adj_s1 <= 0;

            // Stage 2 reset
            product_s2 <= 0;
            exp_sum_s2 <= 0;
            sign_s2 <= 0;
            special_nan_s2 <= 0;
            special_inf_s2 <= 0;
            special_zero_s2 <= 0;
            special_nan_out_s2 <= 0;

            // Stage 3 reset
            norm_product_s3 <= 0;
            norm_exp_s3 <= 0;
            guard_bit_s3 <= 0;
            round_bit_s3 <= 0;
            sticky_bit_s3 <= 0;
            mantissa_s3 <= 0;

            round_increment_s3 <= 0;
            mant_rounded_s3 <= 0;
            mant_rounded_final_s3 <= 0;
            exp_rounded_s3 <= 0;
            sign_s3 <= 0;

            z <= 32'd0;
        end else begin
            // -------- STAGE 1 --------
            a_sign_s1 <= a_sign_w;
            b_sign_s1 <= b_sign_w;
            a_exp_s1 <= a_exp_w;
            b_exp_s1 <= b_exp_w;
            a_frac_s1 <= a_frac_w;
            b_frac_s1 <= b_frac_w;
            a_zero_s1 <= a_zero_w;
            b_zero_s1 <= b_zero_w;
            a_inf_s1 <= a_inf_w;
            b_inf_s1 <= b_inf_w;
            a_nan_s1 <= a_nan_w;
            b_nan_s1 <= b_nan_w;
            a_denorm_s1 <= a_denorm_w;
            b_denorm_s1 <= b_denorm_w;
            a_mant_s1 <= a_mant_w;
            b_mant_s1 <= b_mant_w;
            a_exp_adj_s1 <= a_exp_adj_w;
            b_exp_adj_s1 <= b_exp_adj_w;

            // -------- STAGE 2 --------
            // Multiply mantissas
            product_s2 <= a_mant_s1 * b_mant_s1;
            // Add exponents and subtract bias
            exp_sum_s2 <= a_exp_adj_s1 + b_exp_adj_s1 - EXP_BIAS;
            // XOR signs
            sign_s2 <= a_sign_s1 ^ b_sign_s1;

            // Special cases
            special_nan_s2 <= a_nan_s1 || b_nan_s1;
            special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
            special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;
            special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;

            // -------- STAGE 3 --------
            // Normalize product:
            // If MSB (bit 47) is 1, shift right by 1 and increment exponent
            if (product_s2[47]) begin
                norm_product_s3 <= product_s2 >> 1;
                norm_exp_s3 <= exp_sum_s2 + 10'd1;
            end else begin
                norm_product_s3 <= product_s2;
                norm_exp_s3 <= exp_sum_s2;
            end

            mantissa_s3 <= norm_product_s3[46:23];

            guard_bit_s3 <= norm_product_s3[23];
            round_bit_s3 <= norm_product_s3[22];
            sticky_bit_s3 <= |norm_product_s3[21:0];

            // Round to nearest even
            round_increment_s3 <= guard_bit_s3 && (round_bit_s3 || sticky_bit_s3 || mantissa_s3[0]);
            mant_rounded_s3 <= {1'b0, mantissa_s3} + round_increment_s3;

            // After rounding, check carry out overflow of mantissa
            if (mant_rounded_s3[24]) begin
                mant_rounded_final_s3 <= mant_rounded_s3[24:1]; // shift right by 1
                exp_rounded_s3 <= norm_exp_s3 + 10'd1;
            end else begin
                mant_rounded_final_s3 <= mant_rounded_s3[23:0];
                exp_rounded_s3 <= norm_exp_s3;
            end

            sign_s3 <= sign_s2;

            // -------- OUTPUT generation --------
            // Priority rules for output:
            // 1) NaN if any input NaN or Inf*0 (special_nan_out_s2)
            // 2) Infinity if Inf involved (special_inf_s2)
            // 3) Zero if zero involved (special_zero_s2)
            // 4) Overflow exponent => Inf
            // 5) Underflow exponent => zero (flush to zero)
            // 6) Otherwise normal number

            if (special_nan_s2 || special_nan_out_s2) begin
                // quiet NaN: sign=0, exponent=255, mantissa MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s2) begin
                // Infinity with correct sign
                z <= {sign_s3, 8'hFF, 23'd0};
            end else if (special_zero_s2) begin
                // Zero with correct sign
                z <= {sign_s3, 31'd0};
            end else if (exp_rounded_s3 >= 10'd255) begin
                // Overflow: Infinity
                z <= {sign_s3, 8'hFF, 23'd0};
            end else if (exp_rounded_s3 <= 10'd0) begin
                // Underflow: zero (flush)
                z <= {sign_s3, 31'd0};
            end else begin
                // Normalized number: sign, 8-bit exponent, 23-bit mantissa
                z <= {sign_s3, exp_rounded_s3[7:0], mant_rounded_final_s3[22:0]};
            end
        end
    end

endmodule
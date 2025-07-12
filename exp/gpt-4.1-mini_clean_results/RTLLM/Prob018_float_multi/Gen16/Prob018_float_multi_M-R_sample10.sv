module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // Pipeline stage counter (3 bits)
    reg [2:0] counter;

    // Stage 1: input extraction registers
    reg a_sign_s1, b_sign_s1;
    reg [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;
    reg a_zero_s1, b_zero_s1;
    reg a_inf_s1,  b_inf_s1;
    reg a_nan_s1,  b_nan_s1;
    reg [23:0] a_mant_s1, b_mant_s1;

    // Stage 2 registers
    reg [47:0] product_s2;
    reg [9:0]  exp_sum_s2;
    reg        sign_s2;
    reg        special_nan_s2;
    reg        special_nan_out_s2;
    reg        special_inf_s2;
    reg        special_zero_s2;

    // Stage 3 registers
    reg [47:0] norm_product_s3;
    reg [9:0]  norm_exp_s3;
    reg        sign_s3;
    reg [23:0] mantissa_s3;
    reg        guard_bit_s3;
    reg        round_bit_s3;
    reg        sticky_bit_s3;

    reg        round_increment_s3;
    reg [24:0] mant_rounded_s3;
    reg [23:0] mant_rounded_final_s3;
    reg [9:0]  exp_rounded_s3;

    // Combinational input field extraction & special case detection
    wire [7:0] a_exp_w = a[30:23];
    wire [7:0] b_exp_w = b[30:23];
    wire [22:0] a_frac_w = a[22:0];
    wire [22:0] b_frac_w = b[22:0];
    wire a_sign_w = a[31];
    wire b_sign_w = b[31];

    wire a_zero_w = (a_exp_w == 8'd0) && (a_frac_w == 23'd0);
    wire b_zero_w = (b_exp_w == 8'd0) && (b_frac_w == 23'd0);
    wire a_inf_w  = (a_exp_w == 8'hFF) && (a_frac_w == 23'd0);
    wire b_inf_w  = (b_exp_w == 8'hFF) && (b_frac_w == 23'd0);
    wire a_nan_w  = (a_exp_w == 8'hFF) && (a_frac_w != 23'd0);
    wire b_nan_w  = (b_exp_w == 8'hFF) && (b_frac_w != 23'd0);

    wire [23:0] a_mant_w = (a_exp_w == 8'd0) ? {1'b0, a_frac_w} : {1'b1, a_frac_w};
    wire [23:0] b_mant_w = (b_exp_w == 8'd0) ? {1'b0, b_frac_w} : {1'b1, b_frac_w};

    // Stage 1: input latch
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;

            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_frac_s1 <= 23'd0; b_frac_s1 <= 23'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;
        end else if (counter == 3'd0) begin
            counter <= counter + 3'd1;

            // Latch inputs and decoded info into stage 1 registers
            a_sign_s1 <= a_sign_w; b_sign_s1 <= b_sign_w;
            a_exp_s1 <= a_exp_w; b_exp_s1 <= b_exp_w;
            a_frac_s1 <= a_frac_w; b_frac_s1 <= b_frac_w;
            a_zero_s1 <= a_zero_w; b_zero_s1 <= b_zero_w;
            a_inf_s1 <= a_inf_w; b_inf_s1 <= b_inf_w;
            a_nan_s1 <= a_nan_w; b_nan_s1 <= b_nan_w;
            a_mant_s1 <= a_mant_w; b_mant_s1 <= b_mant_w;
        end else begin
            counter <= (counter == 3'd2) ? 3'd0 : counter + 3'd1;
        end
    end

    // Stage 2: multiply mantissas, add exponents, combine signs, and detect special cases
    always @(posedge clk) begin
        if (rst) begin
            product_s2 <= 48'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            special_nan_s2 <= 1'b0;
            special_nan_out_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;
        end else if (counter == 3'd1) begin
            product_s2 <= a_mant_s1 * b_mant_s1;
            exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;
            sign_s2 <= a_sign_s1 ^ b_sign_s1;

            special_nan_s2 <= a_nan_s1 || b_nan_s1;
            special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
            special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;
            special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;
        end
    end

    // Combinational normalization and rounding inputs for stage 3 register
    wire [47:0] norm_product_w = product_s2[47] ? (product_s2 >> 1) : product_s2;
    wire [9:0]  norm_exp_w = product_s2[47] ? (exp_sum_s2 + 10'd1) : exp_sum_s2;
    wire [23:0] mantissa_w = norm_product_w[46:23];
    wire guard_bit_w = norm_product_w[22];
    wire round_bit_w = norm_product_w[21];
    wire sticky_bit_w = |norm_product_w[20:0];
    wire round_increment_w = guard_bit_w && (round_bit_w || sticky_bit_w || mantissa_w[0]);
    wire [24:0] mant_rounded_w = {1'b0, mantissa_w} + (round_increment_w ? 25'd1 : 25'd0);
    wire mant_rounded_overflow_w = mant_rounded_w[24];
    wire [23:0] mant_rounded_final_w = mant_rounded_overflow_w ? mant_rounded_w[24:1] : mant_rounded_w[23:0];
    wire [9:0] exp_rounded_w = mant_rounded_overflow_w ? (norm_exp_w + 10'd1) : norm_exp_w;

    // Stage 3: normalization, rounding result register
    always @(posedge clk) begin
        if (rst) begin
            norm_product_s3 <= 48'd0;
            norm_exp_s3 <= 10'd0;
            sign_s3 <= 1'b0;
            mantissa_s3 <= 24'd0;
            guard_bit_s3 <= 1'b0;
            round_bit_s3 <= 1'b0;
            sticky_bit_s3 <= 1'b0;
            round_increment_s3 <= 1'b0;
            mant_rounded_s3 <= 25'd0;
            mant_rounded_final_s3 <= 24'd0;
            exp_rounded_s3 <= 10'd0;
        end else if (counter == 3'd2) begin
            norm_product_s3 <= norm_product_w;
            norm_exp_s3 <= norm_exp_w;
            sign_s3 <= sign_s2;
            mantissa_s3 <= mantissa_w;
            guard_bit_s3 <= guard_bit_w;
            round_bit_s3 <= round_bit_w;
            sticky_bit_s3 <= sticky_bit_w;
            round_increment_s3 <= round_increment_w;
            mant_rounded_s3 <= mant_rounded_w;
            mant_rounded_final_s3 <= mant_rounded_final_w;
            exp_rounded_s3 <= exp_rounded_w;
        end
    end

    // Output logic on stage 3 clock cycle
    always @(posedge clk) begin
        if (rst) begin
            z <= 32'd0;
        end else if (counter == 3'd2) begin
            if (special_nan_s2) begin
                // Quiet NaN canonical: sign=0, exp=255, mantissa MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_out_s2) begin
                // NaN due to Inf*0
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s2) begin
                z <= {sign_s2, 8'hFF, 23'd0};
            end else if (special_zero_s2) begin
                z <= {sign_s2, 31'd0};
            end else if (exp_rounded_s3[9:8] != 2'b00) begin
                // Overflow - represent as infinity
                z <= {sign_s3, 8'hFF, 23'd0};
            end else if (exp_rounded_s3 == 10'd0) begin
                // Underflow - zero output (no subnormal support)
                z <= {sign_s3, 31'd0};
            end else begin
                // Normal number
                z <= {sign_s3, exp_rounded_s3[7:0], mant_rounded_final_s3[22:0]};
            end
        end
    end

endmodule
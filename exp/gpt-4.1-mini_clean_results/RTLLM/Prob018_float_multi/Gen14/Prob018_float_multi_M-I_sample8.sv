module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Pipeline counter (3-bit)
    reg [2:0] counter;

    // Stage 1 registers: Input extraction and special case detection
    reg a_sign_s1, b_sign_s1;
    reg [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;

    reg a_is_zero_s1, b_is_zero_s1;
    reg a_is_inf_s1,  b_is_inf_s1;
    reg a_is_nan_s1,  b_is_nan_s1;

    reg a_sign_s2, b_sign_s2;
    reg [7:0] a_exp_s2, b_exp_s2;
    reg [22:0] a_frac_s2, b_frac_s2;

    reg a_is_zero_s2, b_is_zero_s2;
    reg a_is_inf_s2,  b_is_inf_s2;
    reg a_is_nan_s2,  b_is_nan_s2;

    // Mantissas stage 2 (with implicit bit and rounding bit zero)
    reg [24:0] a_mantissa_s2, b_mantissa_s2;

    // Stage 2 registers: multiplication and exponent sum
    reg [49:0] product_s2;
    reg [9:0]  exp_sum_s2;   // 10-bit to allow overflow

    reg sign_z_s2;

    // Stage 3 registers: normalization, rounding, special cases and output
    reg [49:0] product_s3;
    reg [9:0]  exp_sum_s3;
    reg sign_z_s3;

    reg a_is_zero_s3, b_is_zero_s3;
    reg a_is_inf_s3,  b_is_inf_s3;
    reg a_is_nan_s3,  b_is_nan_s3;

    reg special_nan_s3;
    reg special_inf_s3;
    reg special_zero_s3;
    reg special_nan_from_inf_zero_s3;

    // Normalization outputs
    reg [49:0] norm_product_s3;
    reg [9:0]  norm_exp_s3;

    // Rounding bits
    reg guard_bit_s3, round_bit_s3, sticky_bit_s3;

    // Mantissa after rounding
    reg [24:0] mant_round_s3;
    reg [23:0] mant_final_s3;
    reg [9:0]  exp_final_s3;

    // Output register next value
    reg [31:0] z_next;

    // Helper functions
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Counter increment
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
        end else begin
            if (counter == 3'd3)
                counter <= 3'd1; // stay in pipeline stage 1 after initial reset and process continuously
            else
                counter <= counter + 3'd1;
        end
    end

    // Stage 1: Extract fields, detect special cases
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s1   <= 1'b0;
            b_sign_s1   <= 1'b0;
            a_exp_s1    <= 8'd0;
            b_exp_s1    <= 8'd0;
            a_frac_s1   <= 23'd0;
            b_frac_s1   <= 23'd0;

            a_is_zero_s1 <= 1'b0;
            b_is_zero_s1 <= 1'b0;
            a_is_inf_s1  <= 1'b0;
            b_is_inf_s1  <= 1'b0;
            a_is_nan_s1  <= 1'b0;
            b_is_nan_s1  <= 1'b0;
        end else if (counter == 3'd0) begin
            a_sign_s1 <= a[31];
            b_sign_s1 <= b[31];
            a_exp_s1  <= a[30:23];
            b_exp_s1  <= b[30:23];
            a_frac_s1 <= a[22:0];
            b_frac_s1 <= b[22:0];

            a_is_zero_s1 <= is_zero(a[30:23], a[22:0]);
            b_is_zero_s1 <= is_zero(b[30:23], b[22:0]);
            a_is_inf_s1  <= is_inf(a[30:23], a[22:0]);
            b_is_inf_s1  <= is_inf(b[30:23], b[22:0]);
            a_is_nan_s1  <= is_nan(a[30:23], a[22:0]);
            b_is_nan_s1  <= is_nan(b[30:23], b[22:0]);
        end
    end

    // Stage 2 pipeline registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s2   <= 1'b0;
            b_sign_s2   <= 1'b0;
            a_exp_s2    <= 8'd0;
            b_exp_s2    <= 8'd0;
            a_frac_s2   <= 23'd0;
            b_frac_s2   <= 23'd0;

            a_is_zero_s2 <= 1'b0;
            b_is_zero_s2 <= 1'b0;
            a_is_inf_s2  <= 1'b0;
            b_is_inf_s2  <= 1'b0;
            a_is_nan_s2  <= 1'b0;
            b_is_nan_s2  <= 1'b0;

            a_mantissa_s2 <= 25'd0;
            b_mantissa_s2 <= 25'd0;

            product_s2   <= 50'd0;
            exp_sum_s2   <= 10'd0;
            sign_z_s2    <= 1'b0;
        end else if (counter == 3'd1) begin
            // Transfer stage 1 regs to stage 2 and prepare mantissas
            a_sign_s2   <= a_sign_s1;
            b_sign_s2   <= b_sign_s1;
            a_exp_s2    <= a_exp_s1;
            b_exp_s2    <= b_exp_s1;
            a_frac_s2   <= a_frac_s1;
            b_frac_s2   <= b_frac_s1;

            a_is_zero_s2 <= a_is_zero_s1;
            b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2  <= a_is_inf_s1;
            b_is_inf_s2  <= b_is_inf_s1;
            a_is_nan_s2  <= a_is_nan_s1;
            b_is_nan_s2  <= b_is_nan_s1;

            // Mantissa prepare with implicit leading 1 for normals, zero for denormals, and add zero LSB for rounding safety
            a_mantissa_s2 <= (a_exp_s1 == 8'd0) ? {1'b0, a_frac_s1, 1'b0} : {1'b1, a_frac_s1, 1'b0};
            b_mantissa_s2 <= (b_exp_s1 == 8'd0) ? {1'b0, b_frac_s1, 1'b0} : {1'b1, b_frac_s1, 1'b0};

            // Compute sign output
            sign_z_s2 <= a_sign_s1 ^ b_sign_s1;

            // Compute exponent sum with bias adjustment
            exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;

            // Mantissa multiply (combinational) - 25x25->50 bits
            product_s2 <= a_mantissa_s2 * b_mantissa_s2;
        end
    end

    // Stage 3 pipeline registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s3 <= 50'd0;
            exp_sum_s3 <= 10'd0;
            sign_z_s3  <= 1'b0;

            a_is_zero_s3 <= 1'b0;
            b_is_zero_s3 <= 1'b0;
            a_is_inf_s3  <= 1'b0;
            b_is_inf_s3  <= 1'b0;
            a_is_nan_s3  <= 1'b0;
            b_is_nan_s3  <= 1'b0;

            special_nan_s3           <= 1'b0;
            special_inf_s3           <= 1'b0;
            special_zero_s3          <= 1'b0;
            special_nan_from_inf_zero_s3 <= 1'b0;

            norm_product_s3 <= 50'd0;
            norm_exp_s3     <= 10'd0;

            guard_bit_s3 <= 1'b0;
            round_bit_s3 <= 1'b0;
            sticky_bit_s3 <= 1'b0;

            mant_round_s3 <= 25'd0;
            mant_final_s3 <= 24'd0;
            exp_final_s3  <= 10'd0;

            z_next <= 32'd0;
        end else if (counter == 3'd2) begin
            // Transfer inputs from stage 2 to stage 3
            product_s3    <= product_s2;
            exp_sum_s3    <= exp_sum_s2;
            sign_z_s3     <= sign_z_s2;

            a_is_zero_s3  <= a_is_zero_s2;
            b_is_zero_s3  <= b_is_zero_s2;
            a_is_inf_s3   <= a_is_inf_s2;
            b_is_inf_s3   <= b_is_inf_s2;
            a_is_nan_s3   <= a_is_nan_s2;
            b_is_nan_s3   <= b_is_nan_s2;

            // Detect special cases
            special_nan_s3 = a_is_nan_s2 || b_is_nan_s2;
            special_nan_from_inf_zero_s3 = (a_is_inf_s2 && b_is_zero_s2) || (b_is_inf_s2 && a_is_zero_s2);
            special_inf_s3 = (a_is_inf_s2 || b_is_inf_s2) && !special_nan_from_inf_zero_s3 && !special_nan_s3;
            special_zero_s3 = (a_is_zero_s2 || b_is_zero_s2) && !special_nan_from_inf_zero_s3 && !special_nan_s3 && !special_inf_s3;

            // Normalization:
            // If bit 49 of product is 1, shift right 1 and increment exponent by 1
            if (product_s2[49]) begin
                norm_product_s3 = product_s2 >> 1;
                norm_exp_s3 = exp_sum_s2 + 10'd1;
            end else begin
                norm_product_s3 = product_s2;
                norm_exp_s3 = exp_sum_s2;
            end

            // Rounding bits extraction
            guard_bit_s3 = norm_product_s3[24];
            round_bit_s3 = norm_product_s3[23];
            sticky_bit_s3 = |norm_product_s3[22:0];

            // Extract mantissa bits (23 fraction + leading 1) from bits [48:25]
            mant_final_s3 = norm_product_s3[48:25];

            // Round to nearest even
            if (guard_bit_s3 && (round_bit_s3 || sticky_bit_s3 || mant_final_s3[0])) begin
                mant_round_s3 = {1'b0, mant_final_s3} + 25'd1;
            end else begin
                mant_round_s3 = {1'b0, mant_final_s3};
            end

            // Check mantissa overflow from rounding
            if (mant_round_s3[24]) begin
                // overflow after rounding: shift right 1, increment exponent
                mant_final_s3 = mant_round_s3[24:1];
                exp_final_s3 = norm_exp_s3 + 10'd1;
            end else begin
                mant_final_s3 = mant_round_s3[23:0];
                exp_final_s3 = norm_exp_s3;
            end

            // Compose output
            if (special_nan_s3) begin
                // Quiet NaN: sign=0, exp=all 1's, mantissa MSB=1, others zero
                z_next = {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_from_inf_zero_s3) begin
                // inf * zero = NaN
                z_next = {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s3) begin
                // Infinity: sign computed, exp=all 1's, frac=0
                z_next = {sign_z_s3, 8'hFF, 23'd0};
            end else if (special_zero_s3) begin
                // Zero: sign computed, exp=0, frac=0
                z_next = {sign_z_s3, 31'd0};
            end else if (exp_final_s3[9]) begin
                // Overflow to infinity
                z_next = {sign_z_s3, 8'hFF, 23'd0};
            end else if (exp_final_s3 <= 10'd0) begin
                // Underflow to zero (no subnormals for simplicity)
                z_next = {sign_z_s3, 31'd0};
            end else begin
                // Normalized result
                z_next = {sign_z_s3, exp_final_s3[7:0], mant_final_s3[22:0]};
            end
        end
    end

    // Stage 4: Register output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else if (counter == 3'd3) begin
            z <= z_next;
        end
    end

endmodule
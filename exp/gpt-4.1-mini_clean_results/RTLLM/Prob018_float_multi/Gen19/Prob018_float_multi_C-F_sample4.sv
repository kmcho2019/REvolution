module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // 3-bit cycle counter for pipeline control (0 to 4)
    reg [2:0] counter;

    // --- Stage 1: Input extraction and special cases ---
    reg        a_sign_s1, b_sign_s1;
    reg  [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;
    reg        a_zero_s1, b_zero_s1;
    reg        a_inf_s1,  b_inf_s1;
    reg        a_nan_s1,  b_nan_s1;
    reg [23:0] a_mant_s1, b_mant_s1; // mantissa with hidden bit or zero bit

    // --- Stage 2: Prepare multiplier inputs, exponent sum, sign, and special flags ---
    reg [23:0] a_mant_s2, b_mant_s2;
    reg [9:0]  exp_sum_s2; // extended exponent sum
    reg        sign_s2;
    reg        special_nan_s2;
    reg        special_nan_out_s2;
    reg        special_inf_s2;
    reg        special_zero_s2;

    // --- Stage 3: Register multiplier inputs for pipelining ---
    reg [23:0] a_mant_s3, b_mant_s3;
    reg [9:0]  exp_sum_s3;
    reg        sign_s3;
    reg        special_nan_s3;
    reg        special_nan_out_s3;
    reg        special_inf_s3;
    reg        special_zero_s3;

    // --- Stage 4: Multiplier output and normalization prep ---
    reg [47:0] product_s4;
    reg [47:0] norm_product_s4;
    reg [9:0]  norm_exp_s4;
    reg        sign_s4;
    reg        special_nan_s4;
    reg        special_nan_out_s4;
    reg        special_inf_s4;
    reg        special_zero_s4;
    reg        guard_bit_s4;
    reg        round_bit_s4;
    reg        sticky_bit_s4;
    reg [23:0] mantissa_s4;

    // --- Stage 5: Rounding, final exponent adjustment, output formatting ---
    reg        sign_s5;
    reg        special_nan_s5;
    reg        special_nan_out_s5;
    reg        special_inf_s5;
    reg        special_zero_s5;

    reg [24:0] mant_rounded_s5;
    reg [23:0] mant_rounded_final_s5;
    reg [9:0]  exp_rounded_s5;

    // --- Functions for special cases ---
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // --- Sticky bit hierarchical reduction helper for 22 bits ---
    function sticky_reduce(input [21:0] bits);
        integer i;
        begin
            sticky_reduce = 1'b0;
            for (i = 0; i < 22; i = i + 1) begin
                if (bits[i])
                    sticky_reduce = 1'b1;
            end
        end
    endfunction

    // Stage 1: Combinational special cases and mantissa prep from inputs
    wire a_zero_w = is_zero(a[30:23], a[22:0]);
    wire b_zero_w = is_zero(b[30:23], b[22:0]);
    wire a_inf_w  = is_inf(a[30:23], a[22:0]);
    wire b_inf_w  = is_inf(b[30:23], b[22:0]);
    wire a_nan_w  = is_nan(a[30:23], a[22:0]);
    wire b_nan_w  = is_nan(b[30:23], b[22:0]);

    // Mantissas: implicit leading 1 for normalized, 0 for denormals/zeros
    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Counter increments every clock, reset to zero on rst
    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 3'd0;
        else
            counter <= (counter == 3'd4) ? 3'd0 : counter + 3'd1;
    end

    // Stage 1: Register inputs and extracted fields and flags
    always @(posedge clk) begin
        if (rst) begin
            a_sign_s1       <= 1'b0;
            b_sign_s1       <= 1'b0;
            a_exp_s1        <= 8'd0;
            b_exp_s1        <= 8'd0;
            a_frac_s1       <= 23'd0;
            b_frac_s1       <= 23'd0;
            a_zero_s1       <= 1'b0;
            b_zero_s1       <= 1'b0;
            a_inf_s1        <= 1'b0;
            b_inf_s1        <= 1'b0;
            a_nan_s1        <= 1'b0;
            b_nan_s1        <= 1'b0;
            a_mant_s1       <= 24'd0;
            b_mant_s1       <= 24'd0;
        end else begin
            a_sign_s1       <= a[31];
            b_sign_s1       <= b[31];
            a_exp_s1        <= a[30:23];
            b_exp_s1        <= b[30:23];
            a_frac_s1       <= a[22:0];
            b_frac_s1       <= b[22:0];
            a_zero_s1       <= a_zero_w;
            b_zero_s1       <= b_zero_w;
            a_inf_s1        <= a_inf_w;
            b_inf_s1        <= b_inf_w;
            a_nan_s1        <= a_nan_w;
            b_nan_s1        <= b_nan_w;
            a_mant_s1       <= a_mant_w;
            b_mant_s1       <= b_mant_w;
        end
    end

    // Stage 2: Prepare operands and exponent sum and special case flags
    always @(posedge clk) begin
        if (rst) begin
            a_mant_s2       <= 24'd0;
            b_mant_s2       <= 24'd0;
            exp_sum_s2      <= 10'd0;
            sign_s2         <= 1'b0;
            special_nan_s2      <= 1'b0;
            special_nan_out_s2  <= 1'b0;
            special_inf_s2      <= 1'b0;
            special_zero_s2     <= 1'b0;
        end else begin
            a_mant_s2       <= a_mant_s1;
            b_mant_s2       <= b_mant_s1;

            // sum exponents and subtract bias
            exp_sum_s2      <= (a_exp_s1 + b_exp_s1) - EXP_BIAS;

            sign_s2         <= a_sign_s1 ^ b_sign_s1;

            // Special cases:
            // NaN if any input NaN
            special_nan_s2      <= a_nan_s1 || b_nan_s1;

            // NaN output generated by Inf * Zero
            special_nan_out_s2  <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);

            // Inf if either input is Inf but no NaN generated above
            special_inf_s2      <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;

            // Zero if either input zero and no NaN/Inf
            special_zero_s2     <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;
        end
    end

    // Stage 3: Register operands and control signals before multiplier
    always @(posedge clk) begin
        if (rst) begin
            a_mant_s3       <= 24'd0;
            b_mant_s3       <= 24'd0;
            exp_sum_s3      <= 10'd0;
            sign_s3         <= 1'b0;
            special_nan_s3      <= 1'b0;
            special_nan_out_s3  <= 1'b0;
            special_inf_s3      <= 1'b0;
            special_zero_s3     <= 1'b0;
        end else begin
            a_mant_s3       <= a_mant_s2;
            b_mant_s3       <= b_mant_s2;
            exp_sum_s3      <= exp_sum_s2;
            sign_s3         <= sign_s2;
            special_nan_s3      <= special_nan_s2;
            special_nan_out_s3  <= special_nan_out_s2;
            special_inf_s3      <= special_inf_s2;
            special_zero_s3     <= special_zero_s2;
        end
    end

    // Stage 4: Multiply mantissas and prepare normalization bits
    always @(posedge clk) begin
        if (rst) begin
            product_s4          <= 48'd0;
            norm_product_s4     <= 48'd0;
            norm_exp_s4         <= 10'd0;
            sign_s4             <= 1'b0;
            special_nan_s4      <= 1'b0;
            special_nan_out_s4  <= 1'b0;
            special_inf_s4      <= 1'b0;
            special_zero_s4     <= 1'b0;
            guard_bit_s4        <= 1'b0;
            round_bit_s4        <= 1'b0;
            sticky_bit_s4       <= 1'b0;
            mantissa_s4         <= 24'd0;
        end else begin
            // 24x24 mantissa multiplication (can use DSP blocks)
            product_s4 <= a_mant_s3 * b_mant_s3;

            sign_s4 <= sign_s3;
            special_nan_s4 <= special_nan_s3;
            special_nan_out_s4 <= special_nan_out_s3;
            special_inf_s4 <= special_inf_s3;
            special_zero_s4 <= special_zero_s3;

            // Normalize product: if highest bit set, shift right 1 and increment exponent
            if (product_s4[47]) begin
                norm_product_s4 <= product_s4 >> 1;
                norm_exp_s4 <= exp_sum_s3 + 10'd1;
            end else begin
                norm_product_s4 <= product_s4;
                norm_exp_s4 <= exp_sum_s3;
            end

            // Extract mantissa bits [46:23] after normalization shift
            mantissa_s4 <= norm_product_s4[46:23];

            // Extract rounding bits
            guard_bit_s4 <= norm_product_s4[23];
            round_bit_s4 <= norm_product_s4[22];

            // Sticky bit from remaining lower bits with hierarchical OR
            // Sticky bits are bits [21:0]
            sticky_bit_s4 <= |norm_product_s4[21:0];
        end
    end

    // Stage 5: Final rounding, exponent adjustment, special case output
    always @(posedge clk) begin
        if (rst) begin
            sign_s5             <= 1'b0;
            special_nan_s5      <= 1'b0;
            special_nan_out_s5  <= 1'b0;
            special_inf_s5      <= 1'b0;
            special_zero_s5     <= 1'b0;
            mant_rounded_s5     <= 25'd0;
            mant_rounded_final_s5 <= 24'd0;
            exp_rounded_s5      <= 10'd0;
            z                   <= 32'd0;
        end else begin
            sign_s5             <= sign_s4;
            special_nan_s5      <= special_nan_s4;
            special_nan_out_s5  <= special_nan_out_s4;
            special_inf_s5      <= special_inf_s4;
            special_zero_s5     <= special_zero_s4;

            // Round to nearest even
            if (guard_bit_s4 && (round_bit_s4 || sticky_bit_s4 || mantissa_s4[0]))
                mant_rounded_s5 <= {1'b0, mantissa_s4} + 25'd1;
            else
                mant_rounded_s5 <= {1'b0, mantissa_s4};

            // If mantissa overflowed (bit 24 set), shift right and increment exponent
            if (mant_rounded_s5[24]) begin
                mant_rounded_final_s5 <= mant_rounded_s5[24:1];
                exp_rounded_s5 <= norm_exp_s4 + 10'd1;
            end else begin
                mant_rounded_final_s5 <= mant_rounded_s5[23:0];
                exp_rounded_s5 <= norm_exp_s4;
            end

            // Output generation following IEEE-754 priority:
            // NaN > NaN from Inf*0 > Inf > Zero > Overflow > Underflow > Normal

            if (special_nan_s5) begin
                // Quiet NaN canonical form: sign=0, exp=FF, MSB of frac=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_out_s5) begin
                // NaN generated by Inf*0
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s5) begin
                // Infinity
                z <= {sign_s5, 8'hFF, 23'd0};
            end else if (special_zero_s5) begin
                // Zero
                z <= {sign_s5, 31'd0};
            end else if (exp_rounded_s5[9:8] != 2'b00) begin
                // Overflow to infinity
                z <= {sign_s5, 8'hFF, 23'd0};
            end else if (exp_rounded_s5[7:0] == 8'd0) begin
                // Underflow (flush to zero, no denormals)
                z <= {sign_s5, 31'd0};
            end else begin
                // Normal result
                z <= {sign_s5, exp_rounded_s5[7:0], mant_rounded_final_s5[22:0]};
            end
        end
    end

endmodule
module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // Pipeline cycle counter (2 bits) for 4-stage pipeline
    reg [1:0] counter;

    // Stage 1 registers: Extracted fields of inputs
    reg        a_sign_s1, b_sign_s1;
    reg  [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;
    reg        a_zero_s1, b_zero_s1;
    reg        a_inf_s1,  b_inf_s1;
    reg        a_nan_s1,  b_nan_s1;
    reg [23:0] a_mant_s1, b_mant_s1; // mantissas with hidden bit or 0 for denormals

    // Stage 2 registers: multiplier inputs and exponent/sign sum + special flags
    reg [23:0] a_mant_s2, b_mant_s2;
    reg [9:0]  exp_sum_s2; // Exponent sum extended for overflow handling
    reg        sign_s2;
    reg        special_nan_s2;
    reg        special_nan_out_s2;
    reg        special_inf_s2;
    reg        special_zero_s2;

    // Multiplier output registered (48 bits)
    reg [47:0] product_s3;

    // Stage 3 registers: normalization, rounding bits, and exponent adjust
    reg [47:0] norm_product_s3;
    reg [9:0]  norm_exp_s3;
    reg        sign_s3;
    reg        special_nan_s3;
    reg        special_nan_out_s3;
    reg        special_inf_s3;
    reg        special_zero_s3;

    reg        guard_bit_s3;
    reg        round_bit_s3;
    reg        sticky_bit_s3;
    reg [23:0] mantissa_s3;

    // Stage 4 registers: rounding result, final mantissa and exponent
    reg        sign_s4;
    reg        special_nan_s4;
    reg        special_nan_out_s4;
    reg        special_inf_s4;
    reg        special_zero_s4;

    reg [24:0] mant_rounded_s4;
    reg [23:0] mant_rounded_final_s4;
    reg [9:0]  exp_rounded_s4;

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

    // Input combinational wires for special cases and mantissas
    wire a_zero_w = is_zero(a[30:23], a[22:0]);
    wire b_zero_w = is_zero(b[30:23], b[22:0]);
    wire a_inf_w = is_inf(a[30:23], a[22:0]);
    wire b_inf_w = is_inf(b[30:23], b[22:0]);
    wire a_nan_w = is_nan(a[30:23], a[22:0]);
    wire b_nan_w = is_nan(b[30:23], b[22:0]);

    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Sticky bit hierarchical OR reduction helper (22 bits)
    wire sticky_part1 = |product_s3[21:6];     // upper 16 bits
    wire sticky_part2 = |product_s3[5:0];      // lower 6 bits
    wire sticky_bit_combined = sticky_part1 | sticky_part2;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 2'd0;
            z <= 32'd0;

            // Clear all pipeline registers stage 1
            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_frac_s1 <= 23'd0; b_frac_s1 <= 23'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;

            // Stage 2
            a_mant_s2 <= 24'd0; b_mant_s2 <= 24'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            special_nan_s2 <= 1'b0;
            special_nan_out_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;

            // Stage 3
            product_s3 <= 48'd0;
            norm_product_s3 <= 48'd0;
            norm_exp_s3 <= 10'd0;
            sign_s3 <= 1'b0;
            special_nan_s3 <= 1'b0;
            special_nan_out_s3 <= 1'b0;
            special_inf_s3 <= 1'b0;
            special_zero_s3 <= 1'b0;
            guard_bit_s3 <= 1'b0;
            round_bit_s3 <= 1'b0;
            sticky_bit_s3 <= 1'b0;
            mantissa_s3 <= 24'd0;

            // Stage 4
            sign_s4 <= 1'b0;
            special_nan_s4 <= 1'b0;
            special_nan_out_s4 <= 1'b0;
            special_inf_s4 <= 1'b0;
            special_zero_s4 <= 1'b0;
            mant_rounded_s4 <= 25'd0;
            mant_rounded_final_s4 <= 24'd0;
            exp_rounded_s4 <= 10'd0;
        end else begin
            // 4-stage pipeline counter increment (0 to 3)
            counter <= counter == 2'd3 ? 2'd0 : counter + 2'd1;

            // Stage 1: Extract inputs fields & special cases
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

            // Stage 2: Register mantissas and exponent sum + sign and special flags
            a_mant_s2 <= a_mant_s1;
            b_mant_s2 <= b_mant_s1;

            exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;
            sign_s2 <= a_sign_s1 ^ b_sign_s1;

            special_nan_s2 <= a_nan_s1 || b_nan_s1;
            special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
            special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;
            special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;

            // Stage 3: Perform mantissa multiplication, then normalize and compute rounding bits
            product_s3 <= a_mant_s2 * b_mant_s2;

            // Propagate sign and special flags
            sign_s3 <= sign_s2;
            special_nan_s3 <= special_nan_s2;
            special_nan_out_s3 <= special_nan_out_s2;
            special_inf_s3 <= special_inf_s2;
            special_zero_s3 <= special_zero_s2;

            // Normalize product & exponent adjust
            if (product_s3[47]) begin
                norm_product_s3 <= product_s3 >> 1;
                norm_exp_s3 <= exp_sum_s2 + 10'd1;
            end else begin
                norm_product_s3 <= product_s3;
                norm_exp_s3 <= exp_sum_s2;
            end

            // Extract mantissa bits [46:23]
            mantissa_s3 <= norm_product_s3[46:23];

            // Rounding bits extraction
            guard_bit_s3 <= norm_product_s3[23];
            round_bit_s3 <= norm_product_s3[22];

            // Sticky bit hierarchical OR: reduce wide OR to smaller OR gates
            sticky_bit_s3 <= sticky_bit_combined;

            // Stage 4: rounding and final adjustments
            sign_s4 <= sign_s3;
            special_nan_s4 <= special_nan_s3;
            special_nan_out_s4 <= special_nan_out_s3;
            special_inf_s4 <= special_inf_s3;
            special_zero_s4 <= special_zero_s3;

            // Round to nearest even
            if (guard_bit_s3 && (round_bit_s3 || sticky_bit_s3 || mantissa_s3[0]))
                mant_rounded_s4 <= {1'b0, mantissa_s3} + 25'd1;
            else
                mant_rounded_s4 <= {1'b0, mantissa_s3};

            // Handle mantissa overflow after rounding
            if (mant_rounded_s4[24]) begin
                mant_rounded_final_s4 <= mant_rounded_s4[24:1];
                exp_rounded_s4 <= norm_exp_s3 + 10'd1;
            end else begin
                mant_rounded_final_s4 <= mant_rounded_s4[23:0];
                exp_rounded_s4 <= norm_exp_s3;
            end

            // Output generation on stage 4 (4 cycles latency)
            // Priority: NaN > Inf > Zero > Overflow > Underflow > Normal
            if (special_nan_s4) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN canonical
            end else if (special_nan_out_s4) begin
                z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN from Inf*0
            end else if (special_inf_s4) begin
                z <= {sign_s4, 8'hFF, 23'd0};    // Infinity
            end else if (special_zero_s4) begin
                z <= {sign_s4, 31'd0};           // Zero
            end else if (exp_rounded_s4[9:8] != 2'b00) begin
                // Overflow: set to infinity
                z <= {sign_s4, 8'hFF, 23'd0};
            end else if (exp_rounded_s4[7:0] == 8'd0) begin
                // Underflow to zero (no gradual underflow implemented)
                z <= {sign_s4, 31'd0};
            end else begin
                // Normal result
                z <= {sign_s4, exp_rounded_s4[7:0], mant_rounded_final_s4[22:0]};
            end
        end
    end

endmodule
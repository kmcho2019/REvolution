module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;

    // Pipeline stage counter: 0=input decode, 1=mul, 2=normalize+round+output
    reg [1:0] stage_cnt;

    // -------------------
    // Stage 0: Input decode and special cases detection
    // -------------------
    reg         a_sign_s0, b_sign_s0;
    reg  [7:0]  a_exp_s0, b_exp_s0;
    reg  [22:0] a_frac_s0, b_frac_s0;
    reg         a_zero_s0, b_zero_s0;
    reg         a_inf_s0,  b_inf_s0;
    reg         a_nan_s0,  b_nan_s0;

    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_is_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_is_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Mantissas with implicit leading 1 if normalized
    reg [23:0] a_mantissa_s0, b_mantissa_s0;

    // -------------------
    // Stage 1: Multiply mantissas and add exponents
    // -------------------
    reg [23:0] a_mantissa_s1, b_mantissa_s1;
    reg [9:0]  exponent_sum_s1;
    reg        sign_s1;
    reg        a_zero_s1, b_zero_s1, a_inf_s1, b_inf_s1, a_nan_s1, b_nan_s1;

    reg [47:0] product_s1;  // 24x24 mantissa product

    // -------------------
    // Stage 2: Normalize, round, and output generation
    // -------------------
    reg        sign_s2;
    reg [9:0]  exponent_s2;
    reg [23:0] mantissa_s2;
    reg        guard_s2, round_s2, sticky_s2;
    reg        a_zero_s2, b_zero_s2, a_inf_s2, b_inf_s2, a_nan_s2, b_nan_s2;

    // Rounded mantissa and exponent
    reg [24:0] mantissa_rounded_s2;
    reg [9:0]  exponent_rounded_s2;

    // Sticky bit calculation helper function (combinational)
    function automatic bit calc_sticky(input [21:0] bits);
        integer i;
        begin
            calc_sticky = 1'b0;
            for (i=0; i<22; i=i+1)
                if (bits[i]) calc_sticky = 1'b1;
        end
    endfunction

    // -------------------
    // Stage 0 registers: capture inputs and flags
    // -------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s0 <= 0; b_sign_s0 <= 0;
            a_exp_s0 <= 0;  b_exp_s0 <= 0;
            a_frac_s0 <= 0; b_frac_s0 <= 0;
            a_zero_s0 <= 0; b_zero_s0 <= 0;
            a_inf_s0 <= 0;  b_inf_s0 <= 0;
            a_nan_s0 <= 0;  b_nan_s0 <= 0;
            a_mantissa_s0 <= 0; b_mantissa_s0 <= 0;
            stage_cnt <= 0;
            z <= 0;
        end else begin
            if (stage_cnt == 2'd2) stage_cnt <= 0;
            else stage_cnt <= stage_cnt + 1;

            // Only load inputs at stage 0
            if (stage_cnt == 2'd0) begin
                a_sign_s0 <= a_sign;
                b_sign_s0 <= b_sign;
                a_exp_s0 <= a_exp;
                b_exp_s0 <= b_exp;
                a_frac_s0 <= a_frac;
                b_frac_s0 <= b_frac;

                a_zero_s0 <= a_is_zero;
                b_zero_s0 <= b_is_zero;
                a_inf_s0 <= a_is_inf;
                b_inf_s0 <= b_is_inf;
                a_nan_s0 <= a_is_nan;
                b_nan_s0 <= b_is_nan;

                // Prepare mantissa with leading 1 if normalized
                a_mantissa_s0 <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                b_mantissa_s0 <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};
            end
        end
    end

    // -------------------
    // Stage 1 registers: multiplication and exponent addition
    // -------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_mantissa_s1 <= 0;
            b_mantissa_s1 <= 0;
            exponent_sum_s1 <= 0;
            sign_s1 <= 0;
            product_s1 <= 0;
            a_zero_s1 <= 0; b_zero_s1 <= 0; a_inf_s1 <= 0; b_inf_s1 <= 0; a_nan_s1 <= 0; b_nan_s1 <= 0;
        end else if (stage_cnt == 2'd1) begin
            a_mantissa_s1 <= a_mantissa_s0;
            b_mantissa_s1 <= b_mantissa_s0;
            // Exponent add, bias subtract with 10-bit width for overflow check
            exponent_sum_s1 <= ( {2'd0, a_exp_s0} + {2'd0, b_exp_s0} ) - EXP_BIAS;
            sign_s1 <= a_sign_s0 ^ b_sign_s0;

            a_zero_s1 <= a_zero_s0;
            b_zero_s1 <= b_zero_s0;
            a_inf_s1 <= a_inf_s0;
            b_inf_s1 <= b_inf_s0;
            a_nan_s1 <= a_nan_s0;
            b_nan_s1 <= b_nan_s0;

            // Perform multiplication (24x24)
            product_s1 <= a_mantissa_s0 * b_mantissa_s0;
        end
    end

    // -------------------
    // Stage 2: Normalize, rounding, special case handling and output
    // -------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_s2 <= 0;
            exponent_s2 <= 0;
            mantissa_s2 <= 0;
            guard_s2 <= 0; round_s2 <= 0; sticky_s2 <= 0;
            a_zero_s2 <= 0; b_zero_s2 <= 0; a_inf_s2 <= 0; b_inf_s2 <= 0; a_nan_s2 <= 0; b_nan_s2 <= 0;
            mantissa_rounded_s2 <= 0;
            exponent_rounded_s2 <= 0;
            z <= 0;
        end else if (stage_cnt == 2'd2) begin
            sign_s2 <= sign_s1;
            a_zero_s2 <= a_zero_s1;
            b_zero_s2 <= b_zero_s1;
            a_inf_s2  <= a_inf_s1;
            b_inf_s2  <= b_inf_s1;
            a_nan_s2  <= a_nan_s1;
            b_nan_s2  <= b_nan_s1;

            // Normalize mantissa and adjust exponent based on product MSB
            if (product_s1[47]) begin
                // Leading one at bit 47 -> shift right 1 (divide by 2), increment exponent
                mantissa_s2 <= product_s1[47:24]; // top 24 bits after shift right 1
                exponent_s2 <= exponent_sum_s1 + 10'd1;
                guard_s2 <= product_s1[23];
                round_s2 <= product_s1[22];
                sticky_s2 <= |product_s1[21:0];
            end else begin
                // Leading one at bit 46 or less -> no shift
                mantissa_s2 <= product_s1[46:23];
                exponent_s2 <= exponent_sum_s1;
                guard_s2 <= product_s1[22];
                round_s2 <= product_s1[21];
                sticky_s2 <= |product_s1[20:0];
            end

            // Rounding: round-to-nearest-even
            if (guard_s2 && (round_s2 || sticky_s2 || mantissa_s2[0]))
                mantissa_rounded_s2 <= {1'b0, mantissa_s2} + 25'd1;
            else
                mantissa_rounded_s2 <= {1'b0, mantissa_s2};

            // Adjust exponent if mantissa overflowed after rounding
            if (mantissa_rounded_s2[24]) begin
                exponent_rounded_s2 <= exponent_s2 + 10'd1;
            end else begin
                exponent_rounded_s2 <= exponent_s2;
            end

            // Special cases output generation
            // We defer to combinational logic below for final output assignment
        end
    end

    // -------------------
    // Final combinational output assignment
    // -------------------
    always @(*) begin
        // Default output zero
        z = 32'd0;

        // Stage 2 data needed for output:
        // sign_s2, exponent_rounded_s2, mantissa_rounded_s2, special flags

        // Special cases
        if (a_nan_s2 || b_nan_s2) begin
            // NaN output: quiet NaN with MSB of mantissa set
            z = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if ((a_inf_s2 && b_zero_s2) || (b_inf_s2 && a_zero_s2)) begin
            // Inf * 0 = NaN
            z = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (a_inf_s2 || b_inf_s2) begin
            // Result is infinity with sign
            z = {sign_s2, 8'hFF, 23'd0};
        end else if (a_zero_s2 || b_zero_s2) begin
            // Result is zero with sign
            z = {sign_s2, 31'd0};
        end else begin
            // Normal rounded output
            if (exponent_rounded_s2[7:0] >= 8'hFF) begin
                // Overflow to infinity
                z = {sign_s2, 8'hFF, 23'd0};
            end else if (exponent_rounded_s2 <= 0) begin
                // Underflow to zero
                z = {sign_s2, 31'd0};
            end else begin
                if (mantissa_rounded_s2[24]) begin
                    // Mantissa overflowed, shift right 1
                    z = {sign_s2, exponent_rounded_s2[7:0], mantissa_rounded_s2[23:1]};
                end else begin
                    z = {sign_s2, exponent_rounded_s2[7:0], mantissa_rounded_s2[22:0]};
                end
            end
        end
    end

endmodule
module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Stage 0 registers: operand extraction and special cases
    reg         a_sign_s0, b_sign_s0;
    reg  [7:0]  a_exp_s0, b_exp_s0;
    reg  [22:0] a_frac_s0, b_frac_s0;
    reg         a_is_zero_s0, b_is_zero_s0;
    reg         a_is_inf_s0,  b_is_inf_s0;
    reg         a_is_nan_s0,  b_is_nan_s0;
    reg  [23:0] a_mant_s0, b_mant_s0;
    reg         sign_s0;
    reg         mult_enable_s0; // Enable multiplication only when needed

    // Stage 1 registers: mantissa multiplication, exponent add, partial normalization
    reg  [47:0] product_s1;
    reg  [8:0]  exp_sum_s1;     // 9 bits for exponent sum and adjustments
    reg         sign_s1;
    reg         a_is_zero_s1, b_is_zero_s1;
    reg         a_is_inf_s1,  b_is_inf_s1;
    reg         a_is_nan_s1,  b_is_nan_s1;
    reg         mult_enable_s1;

    // Stage 2 registers: normalization, rounding bits extraction, rounding and final output prep
    reg  [47:0] product_s2;
    reg  [8:0]  exp_norm_s2;
    reg         sign_s2;
    reg         a_is_zero_s2, b_is_zero_s2;
    reg         a_is_inf_s2,  b_is_inf_s2;
    reg         a_is_nan_s2,  b_is_nan_s2;

    // Normalized mantissa and rounding bits
    reg  [23:0] mant_norm_s2;
    reg         guard_s2, round_s2, sticky_s2;

    // Rounding result
    reg  [24:0] mant_rounded_s2;
    reg  [8:0]  exp_rounded_s2;

    // Final output signals
    reg  [22:0] mant_final_s3;
    reg  [7:0]  exp_final_s3;
    reg         sign_final_s3;

    // Balanced sticky bit calculation function
    function sticky_or;
        input [21:0] bits;
        reg [10:0] stage1;
        reg [5:0] stage2;
        reg [2:0] stage3;
        reg stage4;
        integer i;
        begin
            // Stage 1: 2-input OR pairs
            for(i=0; i<11; i=i+1) begin
                stage1[i] = bits[2*i] | bits[2*i+1];
            end
            // Stage 2
            for(i=0; i<6; i=i+1) begin
                if(i == 5)
                    stage2[i] = stage1[10];
                else
                    stage2[i] = stage1[2*i] | stage1[2*i+1];
            end
            // Stage 3
            for(i=0; i<3; i=i+1) begin
                if(i == 2)
                    stage3[i] = stage2[5];
                else
                    stage3[i] = stage2[2*i] | stage2[2*i+1];
            end
            // Stage 4: final OR
            stage4 = stage3[0] | stage3[1] | stage3[2];
            sticky_or = stage4;
        end
    endfunction

    // Stage 0: Extract fields, detect special cases and decide mult_enable
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s0    <= 0; b_sign_s0    <= 0;
            a_exp_s0     <= 0; b_exp_s0     <= 0;
            a_frac_s0    <= 0; b_frac_s0    <= 0;
            a_is_zero_s0 <= 0; b_is_zero_s0 <= 0;
            a_is_inf_s0  <= 0; b_is_inf_s0  <= 0;
            a_is_nan_s0  <= 0; b_is_nan_s0  <= 0;
            a_mant_s0    <= 0; b_mant_s0    <= 0;
            sign_s0      <= 0;
            mult_enable_s0 <= 0;
        end else begin
            a_sign_s0 <= a[31];
            b_sign_s0 <= b[31];

            a_exp_s0 <= a[30:23];
            b_exp_s0 <= b[30:23];

            a_frac_s0 <= a[22:0];
            b_frac_s0 <= b[22:0];

            a_is_zero_s0 <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            b_is_zero_s0 <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

            a_is_inf_s0 <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            b_is_inf_s0 <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

            a_is_nan_s0 <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            b_is_nan_s0 <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Implicit leading 1 for normals; zero for denormals
            a_mant_s0 <= (a_exp_s0 == 8'd0) ? {1'b0, a_frac_s0} : {1'b1, a_frac_s0};
            b_mant_s0 <= (b_exp_s0 == 8'd0) ? {1'b0, b_frac_s0} : {1'b1, b_frac_s0};

            sign_s0 <= a_sign_s0 ^ b_sign_s0;

            // Enable multiplication only if operands are normal or denormal (or zero), no NaNs
            // Multiply only if neither operand is NaN or if multiplier is not forced to special case
            mult_enable_s0 <= ~(a_is_nan_s0 | b_is_nan_s0) &&
                              ~((a_is_inf_s0 && b_is_zero_s0) || (b_is_inf_s0 && a_is_zero_s0)) &&
                              ~(a_is_inf_s0 && b_is_inf_s0 && (a_is_zero_s0 || b_is_zero_s0) == 1'b0);
        end
    end

    // Stage 1: Multiply mantissas and add exponents, propagate special flags and sign
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s1 <= 48'd0;
            exp_sum_s1 <= 9'd0;
            sign_s1 <= 0;
            a_is_zero_s1 <= 0; b_is_zero_s1 <= 0;
            a_is_inf_s1 <= 0; b_is_inf_s1 <= 0;
            a_is_nan_s1 <= 0; b_is_nan_s1 <= 0;
            mult_enable_s1 <= 0;
        end else begin
            a_is_zero_s1 <= a_is_zero_s0; b_is_zero_s1 <= b_is_zero_s0;
            a_is_inf_s1  <= a_is_inf_s0;  b_is_inf_s1  <= b_is_inf_s0;
            a_is_nan_s1  <= a_is_nan_s0;  b_is_nan_s1  <= b_is_nan_s0;
            sign_s1      <= sign_s0;
            mult_enable_s1 <= mult_enable_s0;

            if (mult_enable_s0) begin
                // Optimize multiplication using partial products:
                // Split each 24-bit operand into upper and lower 12 bits
                // product = A * B = (A_hi*2^12 + A_lo)*(B_hi*2^12 + B_lo)
                // = A_hi*B_hi*2^24 + (A_hi*B_lo + A_lo*B_hi)*2^12 + A_lo*B_lo
                reg [11:0] A_hi, A_lo, B_hi, B_lo;
                reg [23:0] p0, p1, p2, p3;
                reg [47:0] partial_product;

                A_hi = a_mant_s0[23:12];
                A_lo = a_mant_s0[11:0];
                B_hi = b_mant_s0[23:12];
                B_lo = b_mant_s0[11:0];

                p0 = A_hi * B_hi;
                p1 = A_hi * B_lo;
                p2 = A_lo * B_hi;
                p3 = A_lo * B_lo;

                // Compose the final product
                partial_product = {p0, 24'd0} + 
                                  ({p1, 12'd0} + {p2, 12'd0}) + 
                                  p3;

                product_s1 <= partial_product;

                // Add exponents and subtract bias
                exp_sum_s1 <= a_exp_s0 + b_exp_s0 - EXP_BIAS;
            end else begin
                product_s1 <= 48'd0;
                exp_sum_s1 <= 9'd0;
            end
        end
    end

    // Stage 2: Normalize, extract rounding bits, perform rounding, and prepare final output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 48'd0;
            exp_norm_s2 <= 9'd0;
            sign_s2 <= 0;
            a_is_zero_s2 <= 0; b_is_zero_s2 <= 0;
            a_is_inf_s2 <= 0; b_is_inf_s2 <= 0;
            a_is_nan_s2 <= 0; b_is_nan_s2 <= 0;

            mant_norm_s2 <= 24'd0;
            guard_s2 <= 1'b0;
            round_s2 <= 1'b0;
            sticky_s2 <= 1'b0;

            mant_rounded_s2 <= 25'd0;
            exp_rounded_s2 <= 9'd0;

            mant_final_s3 <= 23'd0;
            exp_final_s3 <= 8'd0;
            sign_final_s3 <= 0;

            z <= 32'd0;
        end else begin
            // Pass flags and sign
            product_s2 <= product_s1;
            exp_norm_s2 <= exp_sum_s1;
            sign_s2 <= sign_s1;
            a_is_zero_s2 <= a_is_zero_s1; b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2 <= a_is_inf_s1; b_is_inf_s2 <= b_is_inf_s1;
            a_is_nan_s2 <= a_is_nan_s1; b_is_nan_s2 <= b_is_nan_s1;

            // Normalize product:
            // If MSB (bit 47) is 1, shift right by 1, increment exponent
            if (mult_enable_s1 && product_s1[47]) begin
                mant_norm_s2 <= product_s1[47:24]; // 24 bits mantissa with leading 1
                exp_norm_s2 <= exp_sum_s1 + 9'd1;

                guard_s2 <= product_s1[23];
                round_s2 <= product_s1[22];
                sticky_s2 <= sticky_or(product_s1[21:0]);
            end else if (mult_enable_s1) begin
                mant_norm_s2 <= product_s1[46:23];
                exp_norm_s2 <= exp_sum_s1;

                guard_s2 <= product_s1[22];
                round_s2 <= product_s1[21];
                sticky_s2 <= sticky_or(product_s1[20:0]);
            end else begin
                mant_norm_s2 <= 24'd0;
                guard_s2 <= 1'b0;
                round_s2 <= 1'b0;
                sticky_s2 <= 1'b0;
                exp_norm_s2 <= 9'd0;
            end

            // Round to nearest even: round if guard = 1 and (round or sticky or LSB)
            if (guard_s2 && (round_s2 | sticky_s2 | mant_norm_s2[0])) begin
                mant_rounded_s2 <= {1'b0, mant_norm_s2} + 25'd1;
            end else begin
                mant_rounded_s2 <= {1'b0, mant_norm_s2};
            end

            // Adjust exponent if rounding caused overflow on mantissa
            if (mant_rounded_s2[24]) begin
                exp_rounded_s2 <= exp_norm_s2 + 9'd1;
                mant_final_s3 <= mant_rounded_s2[24:2]; // shift right 1, drop LSB
            end else begin
                exp_rounded_s2 <= exp_norm_s2;
                mant_final_s3 <= mant_rounded_s2[22:0];
            end

            exp_final_s3 <= exp_rounded_s2[7:0]; // truncate to 8 bits
            sign_final_s3 <= sign_s2;

            // Output generation with priority to special cases
            if (a_is_nan_s2 || b_is_nan_s2) begin
                // Quiet NaN: sign=0, exp=all 1s, MSB mantissa=1 for quiet NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_is_inf_s2 && b_is_zero_s2) || (b_is_inf_s2 && a_is_zero_s2)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_is_inf_s2 || b_is_inf_s2) begin
                // Inf times non-zero or Inf times Inf = Inf
                z <= {sign_final_s3, 8'hFF, 23'd0};
            end else if (a_is_zero_s2 || b_is_zero_s2) begin
                // Zero times anything = Zero
                z <= {sign_final_s3, 31'd0};
            end else begin
                // Normal numbers: handle overflow, underflow and normal output
                if (exp_final_s3 >= 8'hFF) begin
                    // Overflow to infinity
                    z <= {sign_final_s3, 8'hFF, 23'd0};
                end else if (exp_final_s3 <= 0) begin
                    // Underflow: flush to zero (no subnormal generation for simplicity)
                    z <= {sign_final_s3, 31'd0};
                end else begin
                    // Normal output
                    z <= {sign_final_s3, exp_final_s3, mant_final_s3};
                end
            end
        end
    end

endmodule
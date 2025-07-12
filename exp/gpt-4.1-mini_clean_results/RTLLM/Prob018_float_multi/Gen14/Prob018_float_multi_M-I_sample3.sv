module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Pipeline stage counter: 0 = input capture, 1 = multiply, 2 = normalize/output
    reg [1:0] counter;

    // Stage 0 registers: input extraction and special cases
    reg          a_sign_s0, b_sign_s0;
    reg  [7:0]   a_exp_s0, b_exp_s0;
    reg  [22:0]  a_frac_s0, b_frac_s0;
    reg          a_zero_s0, b_zero_s0;
    reg          a_inf_s0, b_inf_s0;
    reg          a_nan_s0, b_nan_s0;
    reg  [23:0]  a_mant_s0, b_mant_s0;

    // Stage 1 registers: multiplication results and intermediate signals
    reg  [1:0]   special_case_s1; 
    // 0: none, 1: NaN, 2: Inf, 3: Zero with special NaN output (inf*0)
    reg          sign_s1;
    reg  [8:0]   exp_sum_s1;   // 9 bits: 8 bits exponent plus overflow bit
    reg  [47:0]  product_s1;

    // Stage 2 registers: normalization, rounding, output assemble
    reg  [1:0]   special_case_s2;
    reg          sign_s2;
    reg  [8:0]   exp_norm_s2;
    reg  [23:0]  mantissa_norm_s2;

    // ----- Stage 0 combinational special cases -----
    wire a_is_zero = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_is_zero = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

    wire a_is_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_is_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

    wire a_is_nan  = (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
    wire b_is_nan  = (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

    wire [23:0] a_mantissa_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mantissa_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // ----- Stage 1 special case determination (after input capture) -----
    // Encoded special cases for easy checking in later stages:
    // 00: none, 01: NaN, 10: Inf, 11: Zero with inf*zero NaN output

    wire special_nan_s1 = a_is_nan || b_is_nan;
    wire special_nan_out_s1 = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
    wire special_inf_s1 = (a_is_inf || b_is_inf) && !special_nan_out_s1 && !special_nan_s1;
    wire special_zero_s1 = (a_is_zero || b_is_zero) && !special_nan_out_s1 && !special_inf_s1 && !special_nan_s1;

    // Mantissa product
    wire [47:0] product_w = a_mant_s0 * b_mant_s0;

    // Exponent sum (9 bits for overflow)
    wire [9:0] exp_sum_w_10b = {1'b0, a_exp_s0} + {1'b0, b_exp_s0} - EXP_BIAS;
    wire [8:0] exp_sum_w = exp_sum_w_10b[8:0]; // cut MSB, keep 9 bits (max 383 decimal)

    // Sign XOR
    wire sign_w = a_sign_s0 ^ b_sign_s0;

    // ----- Stage 2 normalization and rounding -----

    // Normalization: if product[47] == 1, shift right 1 and add 1 to exponent
    wire norm_shift = product_s1[47];
    wire [8:0] exp_norm_pre = exp_sum_s1 + (norm_shift ? 9'd1 : 9'd0);
    wire [47:0] product_norm = norm_shift ? (product_s1 >> 1) : product_s1;

    // Extract mantissa (24 bits: [46:23])
    wire [23:0] mantissa_raw = product_norm[46:23];

    // Rounding bits
    wire guard_bit = product_norm[22];
    wire round_bit = product_norm[21];
    wire sticky_bit = |product_norm[20:0];

    wire round_incr = guard_bit && (round_bit || sticky_bit || mantissa_raw[0]);

    // Mantissa rounding (25 bits to hold possible carry)
    wire [24:0] mantissa_rounded = {1'b0, mantissa_raw} + round_incr;

    // Check if rounding overflowed mantissa
    wire mantissa_overflow = mantissa_rounded[24];

    // Adjust mantissa and exponent if overflow
    wire [23:0] mantissa_final = mantissa_overflow ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire [8:0]  exp_final = mantissa_overflow ? exp_norm_pre + 9'd1 : exp_norm_pre;

    // Overflow if exponent >= 255 or <0 (underflow)
    wire overflow = (exp_final[8]) || (exp_final[7:0] >= 8'hFF);
    wire underflow = (!exp_final[8]) && (exp_final[7:0] == 8'd0);

    // Assemble outputs
    wire [31:0] nan_result = {1'b0, 8'hFF, 1'b1, 22'd0};
    wire [31:0] inf_result = {sign_s2, 8'hFF, 23'd0};
    wire [31:0] zero_result = {sign_s2, 31'd0};
    wire [31:0] normal_result = {sign_s2, exp_final[7:0], mantissa_final[22:0]};

    // ----- Pipeline registers -----
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'd0;
            z <= 32'd0;

            // Stage 0 regs reset
            a_sign_s0 <= 1'b0; b_sign_s0 <= 1'b0;
            a_exp_s0 <= 8'd0; b_exp_s0 <= 8'd0;
            a_frac_s0 <= 23'd0; b_frac_s0 <= 23'd0;
            a_zero_s0 <= 1'b0; b_zero_s0 <= 1'b0;
            a_inf_s0 <= 1'b0; b_inf_s0 <= 1'b0;
            a_nan_s0 <= 1'b0; b_nan_s0 <= 1'b0;
            a_mant_s0 <= 24'd0; b_mant_s0 <= 24'd0;

            // Stage 1 regs reset
            special_case_s1 <= 2'b00;
            sign_s1 <= 1'b0;
            exp_sum_s1 <= 9'd0;
            product_s1 <= 48'd0;

            // Stage 2 regs reset
            special_case_s2 <= 2'b00;
            sign_s2 <= 1'b0;
            exp_norm_s2 <= 9'd0;
            mantissa_norm_s2 <= 24'd0;
        end else begin
            counter <= counter + 2'd1;

            case(counter)
                2'd0: begin
                    // Capture inputs and special cases
                    a_sign_s0 <= a[31];
                    b_sign_s0 <= b[31];
                    a_exp_s0 <= a[30:23];
                    b_exp_s0 <= b[30:23];
                    a_frac_s0 <= a[22:0];
                    b_frac_s0 <= b[22:0];
                    a_zero_s0 <= a_is_zero;
                    b_zero_s0 <= b_is_zero;
                    a_inf_s0 <= a_is_inf;
                    b_inf_s0 <= b_is_inf;
                    a_nan_s0 <= a_is_nan;
                    b_nan_s0 <= b_is_nan;
                    a_mant_s0 <= a_mantissa_w;
                    b_mant_s0 <= b_mantissa_w;
                end

                2'd1: begin
                    // Perform multiplication and exponent addition, set special cases
                    product_s1 <= product_w;
                    exp_sum_s1 <= exp_sum_w;
                    sign_s1 <= sign_w;
                    special_case_s1 <=
                        (special_nan_s1) ? 2'b01 :
                        (special_nan_out_s1) ? 2'b11 :
                        (special_inf_s1) ? 2'b10 :
                        (special_zero_s1) ? 2'b11 : 2'b00;
                end

                2'd2: begin
                    // Normalization, rounding, output formatting
                    special_case_s2 <= special_case_s1;
                    sign_s2 <= sign_s1;
                    exp_norm_s2 <= exp_final;
                    mantissa_norm_s2 <= mantissa_final;

                    // Output mux based on special cases and overflow/underflow
                    case (special_case_s1)
                        2'b01: z <= nan_result; // NaN
                        2'b11: z <= nan_result; // inf*zero -> NaN
                        2'b10: z <= inf_result; // Infinity
                        default: begin
                            if (overflow)
                                z <= inf_result;
                            else if (underflow)
                                z <= zero_result;
                            else
                                z <= normal_result;
                        end
                    endcase
                end
            endcase
        end
    end
endmodule
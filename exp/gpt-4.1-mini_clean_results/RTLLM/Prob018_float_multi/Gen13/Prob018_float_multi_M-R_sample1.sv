module float_multi (
    input            clk,
    input            rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Pipeline counter: 0 = input capture, 1 = calc done, output valid
    reg [1:0] counter;

    // Stage 1 registers: input extraction and special case detection
    reg          a_sign_r, b_sign_r;
    reg  [7:0]   a_exp_r, b_exp_r;
    reg  [22:0]  a_frac_r, b_frac_r;
    reg  [23:0]  a_mant_r, b_mant_r;
    reg          a_zero_r, b_zero_r;
    reg          a_inf_r,  b_inf_r;
    reg          a_nan_r,  b_nan_r;

    // Stage 2 registers: multiplication results and intermediate signals
    reg  [47:0]  product_r;
    reg  [9:0]   exp_sum_r;
    reg          sign_r;

    // Normalized & rounded results registers
    reg  [9:0]   exp_norm_r;
    reg  [23:0]  mantissa_norm_r;

    // Special case flags latched to stage 2
    reg special_nan_r, special_nan_out_r, special_inf_r, special_zero_r;

    // ----- Combinational signals for stage 1 -----
    wire a_is_zero = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_is_zero = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

    wire a_is_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_is_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

    wire a_is_nan  = (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
    wire b_is_nan  = (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

    wire [23:0] a_mantissa = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mantissa = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // ----- Combinational signals for stage 2 (multiplication, exponent calc) -----
    wire [47:0] product_w = a_mant_r * b_mant_r;
    wire [9:0]  exp_sum_w = a_exp_r + b_exp_r - EXP_BIAS;
    wire        sign_w = a_sign_r ^ b_sign_r;

    wire special_nan_w       = a_nan_r || b_nan_r;
    wire special_nan_out_w   = (a_inf_r && b_zero_r) || (b_inf_r && a_zero_r);
    wire special_inf_w       = (a_inf_r || b_inf_r) && !special_nan_out_w;
    wire special_zero_w      = (a_zero_r || b_zero_r) && !special_nan_out_w && !special_inf_w;

    // ----- Normalization and rounding wires -----
    wire [47:0] norm_product_w;
    wire [9:0]  norm_exp_w;

    assign {norm_exp_w, norm_product_w} = (product_w[47]) ?
        {exp_sum_w + 10'd1, product_w >> 1} :
        {exp_sum_w, product_w};

    wire [23:0] mantissa_w = norm_product_w[46:23];

    wire guard_bit = norm_product_w[23];
    wire round_bit = norm_product_w[22];
    wire sticky_bit = |norm_product_w[21:0];

    wire round_increment = guard_bit && (round_bit || sticky_bit || mantissa_w[0]);

    wire [24:0] mantissa_rounded = {1'b0, mantissa_w} + round_increment;

    wire mantissa_overflow = mantissa_rounded[24];

    wire [23:0] mantissa_final = mantissa_overflow ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire [9:0]  exp_final = mantissa_overflow ? norm_exp_w + 10'd1 : norm_exp_w;

    // ----- Output muxing -----
    wire overflow = (exp_final[9:8] != 2'b00);
    wire underflow = (exp_final[9:0] == 0);

    wire [31:0] nan_result = {1'b0, 8'hFF, 1'b1, 22'd0};
    wire [31:0] inf_result = {sign_w, 8'hFF, 23'd0};
    wire [31:0] zero_result = {sign_w, 31'd0};
    wire [31:0] normal_result = {sign_w, exp_final[7:0], mantissa_final[22:0]};

    // ----- Pipeline registers update -----
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'd0;
            z <= 32'd0;

            a_sign_r <= 1'b0; b_sign_r <= 1'b0;
            a_exp_r <= 8'd0; b_exp_r <= 8'd0;
            a_frac_r <= 23'd0; b_frac_r <= 23'd0;
            a_mant_r <= 24'd0; b_mant_r <= 24'd0;

            a_zero_r <= 1'b0; b_zero_r <= 1'b0;
            a_inf_r <= 1'b0; b_inf_r <= 1'b0;
            a_nan_r <= 1'b0; b_nan_r <= 1'b0;

            product_r <= 48'd0;
            exp_sum_r <= 10'd0;
            sign_r <= 1'b0;

            exp_norm_r <= 10'd0;
            mantissa_norm_r <= 24'd0;

            special_nan_r <= 1'b0;
            special_nan_out_r <= 1'b0;
            special_inf_r <= 1'b0;
            special_zero_r <= 1'b0;
        end else begin
            // Pipeline counter increment and wrap
            counter <= counter + 2'd1;

            case(counter)
                2'd0: begin
                    // Capture inputs
                    a_sign_r <= a[31];
                    b_sign_r <= b[31];
                    a_exp_r  <= a[30:23];
                    b_exp_r  <= b[30:23];
                    a_frac_r <= a[22:0];
                    b_frac_r <= b[22:0];
                    a_mant_r <= a_mantissa;
                    b_mant_r <= b_mantissa;

                    a_zero_r <= a_is_zero;
                    b_zero_r <= b_is_zero;
                    a_inf_r  <= a_is_inf;
                    b_inf_r  <= b_is_inf;
                    a_nan_r  <= a_is_nan;
                    b_nan_r  <= b_is_nan;
                end

                2'd1: begin
                    // Capture product and exponents, signs, special flags
                    product_r <= product_w;
                    exp_sum_r <= exp_sum_w;
                    sign_r <= sign_w;

                    special_nan_r <= special_nan_w;
                    special_nan_out_r <= special_nan_out_w;
                    special_inf_r <= special_inf_w;
                    special_zero_r <= special_zero_w;
                end

                2'd2: begin
                    // Apply normalization and rounding results from combinational wires
                    exp_norm_r <= exp_final;
                    mantissa_norm_r <= mantissa_final;

                    // Generate output based on special cases and overflow/underflow
                    if (special_nan_r)
                        z <= nan_result;
                    else if (special_nan_out_r)
                        z <= nan_result; // NaN from inf*zero
                    else if (special_inf_r)
                        z <= inf_result;
                    else if (special_zero_r)
                        z <= zero_result;
                    else if (overflow)
                        z <= inf_result;
                    else if (underflow)
                        z <= zero_result;
                    else
                        z <= normal_result;
                end

                default: ;
            endcase
        end
    end
endmodule
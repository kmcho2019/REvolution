module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage enables
    reg stage1_en, stage2_en, stage3_en, stage4_en;

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Registered pipeline values
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign_reg, b_sign_reg;
    reg [47:0] product;
    reg z_sign_reg;
    reg [7:0] z_exponent;
    reg [23:0] z_mantissa;

    // Special case detection (combinational)
    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);
    
    wire any_zero = a_zero || b_zero;
    wire any_inf = a_inf || b_inf;
    wire any_nan = a_nan || b_nan;
    wire inf_times_zero = (a_inf && b_zero) || (a_zero && b_inf);

    // Stage 1: Input processing and register
    always @(posedge clk) begin
        if (rst) begin
            stage1_en <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_sign_reg <= 0;
            b_sign_reg <= 0;
        end else begin
            stage1_en <= 1;
            a_sign_reg <= a_sign;
            b_sign_reg <= b_sign;
            a_exponent <= a_exp;
            b_exponent <= b_exp;
            a_mantissa <= (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
            b_mantissa <= (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};
        end
    end

    // Stage 2: Multiplication
    always @(posedge clk) begin
        if (rst) begin
            stage2_en <= 0;
            product <= 0;
            z_sign_reg <= 0;
        end else if (stage1_en) begin
            stage2_en <= 1;
            product <= a_mantissa * b_mantissa;
            z_sign_reg <= a_sign_reg ^ b_sign_reg;
        end else begin
            stage2_en <= 0;
        end
    end

    // Stage 3: Normalization and exponent calculation
    wire [7:0] exp_sum = a_exponent + b_exponent;
    wire [7:0] exp_biased = exp_sum - 8'd127;
    wire product_msb = product[47];
    
    wire [23:0] norm_mantissa = product_msb ? product[47:24] : product[46:23];
    wire [7:0] norm_exponent = product_msb ? (exp_biased + 1) : exp_biased;
    wire guard_bit = product[22];
    wire round_bit = product[21];
    wire sticky_bit = |product[20:0];
    wire round_up = guard_bit && (round_bit || sticky_bit || norm_mantissa[0]);

    always @(posedge clk) begin
        if (rst) begin
            stage3_en <= 0;
            z_mantissa <= 0;
            z_exponent <= 0;
        end else if (stage2_en) begin
            stage3_en <= 1;
            // Apply rounding if needed
            if (round_up) begin
                z_mantissa <= norm_mantissa + 1;
                // Handle mantissa overflow during rounding
                z_exponent <= (norm_mantissa == 24'hFFFFFF) ? (norm_exponent + 1) : norm_exponent;
            end else begin
                z_mantissa <= norm_mantissa;
                z_exponent <= norm_exponent;
            end
        end else begin
            stage3_en <= 0;
        end
    end

    // Stage 4: Output formatting
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign_reg, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign_reg, 31'b0};
    wire [31:0] normal_out = {z_sign_reg, z_exponent, z_mantissa[22:0]};

    always @(posedge clk) begin
        if (rst) begin
            stage4_en <= 0;
            z <= 0;
        end else if (stage3_en) begin
            stage4_en <= 1;
            // Priority encoder for special cases
            if (any_nan || inf_times_zero) begin
                z <= nan_out;
            end else if (any_inf) begin
                z <= inf_out;
            end else if (any_zero) begin
                z <= zero_out;
            end else if (z_exponent == 8'hFF) begin // Overflow
                z <= inf_out;
            end else if (z_exponent == 0) begin // Underflow
                z <= zero_out;
            end else begin
                z <= normal_out;
            end
        end else begin
            stage4_en <= 0;
        end
    end

endmodule
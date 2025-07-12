module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1: Input registers
    reg [31:0] a_reg, b_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Input decomposition (combinational)
    wire a_sign = a_reg[31];
    wire b_sign = b_reg[31];
    wire [7:0] a_exp = a_reg[30:23];
    wire [7:0] b_exp = b_reg[30:23];
    wire [22:0] a_frac = a_reg[22:0];
    wire [22:0] b_frac = b_reg[22:0];

    // Special case detection (combinational)
    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);

    // Mantissa preparation with hidden bit
    wire [23:0] a_mant = (a_exp != 0) ? {1'b1, a_frac} : {1'b0, a_frac};
    wire [23:0] b_mant = (b_exp != 0) ? {1'b1, b_frac} : {1'b0, b_frac};

    // Pipeline stage 2: Compute registers
    reg sign_stage2;
    reg [7:0] exp_sum_stage2;
    reg [47:0] product_stage2;
    reg special_case_stage2;
    reg inf_stage2;
    reg zero_stage2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_stage2 <= 0;
            exp_sum_stage2 <= 0;
            product_stage2 <= 0;
            special_case_stage2 <= 0;
            inf_stage2 <= 0;
            zero_stage2 <= 0;
        end else begin
            sign_stage2 <= a_sign ^ b_sign;
            exp_sum_stage2 <= a_exp + b_exp - 8'd127;
            product_stage2 <= a_mant * b_mant;
            special_case_stage2 <= a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
            inf_stage2 <= a_inf || b_inf;
            zero_stage2 <= a_zero || b_zero;
        end
    end

    // Normalization and rounding (combinational)
    wire product_msb = product_stage2[47];
    wire [23:0] norm_mant = product_msb ? product_stage2[47:24] : product_stage2[46:23];
    wire [7:0] norm_exp = product_msb ? (exp_sum_stage2 + 1) : exp_sum_stage2;

    wire guard_bit = product_stage2[22];
    wire round_bit = product_stage2[21];
    wire sticky = |product_stage2[20:0];
    wire round_inc = guard_bit && (round_bit || sticky || norm_mant[0]);

    wire [23:0] rounded_mant = round_inc ? norm_mant + 1 : norm_mant;
    wire [7:0] final_exp = (&norm_mant && round_inc) ? norm_exp + 1 : norm_exp;

    // Overflow/underflow detection
    wire overflow = (final_exp >= 8'hFF);
    wire underflow = (final_exp == 0);

    // Pipeline stage 3: Output registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (special_case_stage2) begin
                z <= 32'h7FC00000; // NaN
            end else if (inf_stage2) begin
                z <= {sign_stage2, 8'hFF, 23'b0}; // Infinity
            end else if (zero_stage2) begin
                z <= {sign_stage2, 31'b0}; // Zero
            end else if (overflow) begin
                z <= {sign_stage2, 8'hFF, 23'b0}; // Overflow to infinity
            end else if (underflow) begin
                z <= {sign_stage2, 31'b0}; // Underflow to zero
            end else begin
                z <= {sign_stage2, final_exp, rounded_mant[22:0]}; // Normal result
            end
        end
    end

endmodule
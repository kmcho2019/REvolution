module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exponent = a[30:23];
    wire [7:0] b_exponent = b[30:23];
    wire [22:0] a_mantissa = a[22:0];
    wire [22:0] b_mantissa = b[22:0];

    // Special case detection
    wire a_zero = (a_exponent == 0) && (a_mantissa == 0);
    wire b_zero = (b_exponent == 0) && (b_mantissa == 0);
    wire a_inf = (a_exponent == 8'hFF) && (a_mantissa == 0);
    wire b_inf = (b_exponent == 8'hFF) && (b_mantissa == 0);
    wire a_nan = (a_exponent == 8'hFF) && (a_mantissa != 0);
    wire b_nan = (b_exponent == 8'hFF) && (b_mantissa != 0);

    // Normalized mantissas with implicit bit
    wire [23:0] a_mant_norm = (a_exponent != 0) ? {1'b1, a_mantissa} : {1'b0, a_mantissa};
    wire [23:0] b_mant_norm = (b_exponent != 0) ? {1'b1, b_mantissa} : {1'b0, b_mantissa};

    // Multiply mantissas (48-bit result)
    wire [47:0] product = a_mant_norm * b_mant_norm;

    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent};
    wire [8:0] exp_adj = exp_sum - 9'd127;
    wire exp_overflow = exp_adj[8] || (&exp_adj[7:0]);

    // Normalization and rounding
    wire norm_shift = product[47];
    wire [23:0] shifted_mant = norm_shift ? product[46:23] : product[45:22];
    wire round_bit = norm_shift ? product[22] : product[21];
    wire sticky_bit = norm_shift ? (|product[21:0]) : (|product[20:0]);
    wire round_up = round_bit & (shifted_mant[0] | sticky_bit);
    wire [22:0] final_mantissa = shifted_mant[23:1] + round_up;

    // Final exponent after normalization
    wire [8:0] final_exp_tmp = norm_shift ? (exp_adj + 1) : exp_adj;
    wire final_exp_overflow = final_exp_tmp[8] || (&final_exp_tmp[7:0]);
    wire [7:0] final_exponent = final_exp_overflow ? 8'hFF : final_exp_tmp[7:0];

    // Result construction
    wire [31:0] normal_result = {a_sign ^ b_sign, final_exponent, final_mantissa};
    wire [31:0] nan_result = 32'h7FC00000;
    wire [31:0] inf_result = {a_sign ^ b_sign, 8'hFF, 23'b0};
    wire [31:0] zero_result = {a_sign ^ b_sign, 31'b0};

    // Priority-encoded output selection
    wire [31:0] result;
    assign result = (a_nan || b_nan) ? nan_result :
                   ((a_inf && b_zero) || (b_inf && a_zero)) ? nan_result :
                   (a_inf || b_inf) ? inf_result :
                   (a_zero || b_zero) ? zero_result :
                   (exp_overflow || final_exp_overflow) ? inf_result :
                   normal_result;

    // Register output on clock edge
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            z <= result;
        end
    end

endmodule
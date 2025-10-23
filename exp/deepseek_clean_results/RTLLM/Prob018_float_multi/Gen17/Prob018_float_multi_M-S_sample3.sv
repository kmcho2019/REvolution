module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Input processing
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_man = a[22:0];
    wire [22:0] b_man = b[22:0];

    // Special case detection
    wire a_is_zero = (a_exp == 0) & (a_man == 0);
    wire b_is_zero = (b_exp == 0) & (b_man == 0);
    wire a_is_inf = (a_exp == 8'hFF) & (a_man == 0);
    wire b_is_inf = (b_exp == 8'hFF) & (b_man == 0);
    wire a_is_nan = (a_exp == 8'hFF) & (a_man != 0);
    wire b_is_nan = (b_exp == 8'hFF) & (b_man != 0);

    wire is_nan = a_is_nan | b_is_nan | (a_is_inf & b_is_zero) | (b_is_inf & a_is_zero);
    wire is_inf = (a_is_inf | b_is_inf) & ~is_nan;
    wire is_zero = (a_is_zero | b_is_zero) & ~is_nan & ~is_inf;

    // Normal numbers processing
    wire [23:0] a_mantissa = (a_exp != 0) ? {1'b1, a_man} : {1'b0, a_man};
    wire [23:0] b_mantissa = (b_exp != 0) ? {1'b1, b_man} : {1'b0, b_man};
    wire [47:0] product = a_mantissa * b_mantissa;

    wire product_msb = product[47];
    wire [22:0] product_mantissa = product_msb ? product[46:24] : product[45:23];
    wire round_bit = product_msb ? product[23] : product[22];
    wire sticky_bit = product_msb ? |product[22:0] : |product[21:0];
    wire [22:0] rounded_mantissa = product_mantissa + (round_bit & (product_mantissa[0] | sticky_bit));

    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp} - 9'd127;
    wire [8:0] final_exp = exp_sum + product_msb;
    wire exp_overflow = (final_exp[8] | (final_exp[7:0] >= 8'hFF));
    wire exp_underflow = (final_exp < 9'd1);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (is_nan) begin
                z <= {a_sign ^ b_sign, 8'hFF, 1'b1, 22'b0}; // NaN
            end else if (is_inf | exp_overflow) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Inf
            end else if (is_zero | exp_underflow) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Zero
            end else begin
                z <= {a_sign ^ b_sign, final_exp[7:0], rounded_mantissa};
            end
        end
    end

endmodule
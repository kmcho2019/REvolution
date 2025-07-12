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
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_man = a[22:0];
    wire [22:0] b_man = b[22:0];

    // Special case detection
    wire a_nan = (a_exp == 8'hFF) & (|a_man);
    wire b_nan = (b_exp == 8'hFF) & (|b_man);
    wire a_inf = (a_exp == 8'hFF) & (~|a_man);
    wire b_inf = (b_exp == 8'hFF) & (~|b_man);
    wire a_zero = (a_exp == 0) & (~|a_man);
    wire b_zero = (b_exp == 0) & (~|b_man);

    // Combined special cases
    wire is_nan = a_nan | b_nan | (a_inf & b_zero) | (b_inf & a_zero);
    wire is_inf = a_inf | b_inf;
    wire is_zero = a_zero | b_zero;

    // Normalized mantissas with implicit bit
    wire [23:0] a_mant = {|a_exp, a_man};
    wire [23:0] b_mant = {|b_exp, b_man};

    // Multiplication core
    wire [47:0] product = a_mant * b_mant;
    wire product_msb = product[47];
    wire [7:0] exp_sum = a_exp + b_exp - 8'd127 + product_msb;
    wire [22:0] final_man = product_msb ? product[46:24] : product[45:23];

    // Overflow/underflow
    wire overflow = &exp_sum | (exp_sum >= 8'hFE);
    wire underflow = exp_sum[7] & (exp_sum != 8'hFF);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            case (1'b1)
                is_nan: z <= 32'h7FC00000;
                is_inf: z <= {a_sign ^ b_sign, 8'hFF, 23'b0};
                is_zero: z <= {a_sign ^ b_sign, 31'b0};
                overflow: z <= {a_sign ^ b_sign, 8'hFF, 23'b0};
                underflow: z <= {a_sign ^ b_sign, 31'b0};
                default: z <= {a_sign ^ b_sign, exp_sum, final_man};
            endcase
        end
    end

endmodule
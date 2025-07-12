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
    wire [23:0] a_man = |a_exp ? {1'b1, a[22:0]} : 24'b0;
    wire [23:0] b_man = |b_exp ? {1'b1, b[22:0]} : 24'b0;

    // Special cases
    wire is_nan = (a_exp == 8'hFF && |a[22:0]) || (b_exp == 8'hFF && |b[22:0]);
    wire is_inf = (a_exp == 8'hFF) || (b_exp == 8'hFF);
    wire is_zero = (a_exp == 0) || (b_exp == 0);

    // Multiplication core
    wire [47:0] product = a_man * b_man;
    wire [7:0] exp_sum = a_exp + b_exp - 8'd127;
    wire norm_bit = product[47];
    wire [7:0] final_exp = exp_sum + norm_bit;
    wire [22:0] final_man = product[46:24];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (is_nan || (is_inf && is_zero)) begin
                z <= 32'h7FC00000; // NaN
            end else if (is_inf) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
            end else if (is_zero) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Zero
            end else begin
                z <= {a_sign ^ b_sign, final_exp, final_man};
            end
        end
    end

endmodule
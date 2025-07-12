module float_multi(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Extract components
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_man = a[22:0];
    wire [22:0] b_man = b[22:0];

    // Special cases
    wire a_zero = (a_exp == 0) && (a_man == 0);
    wire b_zero = (b_exp == 0) && (b_man == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_man == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_man == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_man != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_man != 0);

    // Normalized mantissas with implicit bit
    wire [23:0] a_norm = {|a_exp, a_man};
    wire [23:0] b_norm = {|b_exp, b_man};

    // Multiply mantissas
    wire [47:0] product = a_norm * b_norm;

    // Calculate exponent
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp};
    wire [8:0] exp_adj = exp_sum - 9'd127;

    // Normalization
    wire norm_shift = product[47];
    wire [22:0] final_man = norm_shift ? product[46:24] : product[45:23];
    wire [7:0] final_exp = norm_shift ? exp_adj[7:0] + 1 : exp_adj[7:0];

    // Result assembly
    always @* begin
        if (a_nan || b_nan) begin
            z = 32'h7FC00000; // NaN
        end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
            z = 32'h7FC00000; // 0*inf = NaN
        end else if (a_inf || b_inf) begin
            z = {a_sign ^ b_sign, 8'hFF, 23'b0}; // Inf
        end else if (a_zero || b_zero) begin
            z = {a_sign ^ b_sign, 31'b0}; // Zero
        end else if (exp_adj[8] || (&final_exp)) begin // Overflow
            z = {a_sign ^ b_sign, 8'hFF, 23'b0}; // Inf
        end else begin
            z = {a_sign ^ b_sign, final_exp, final_man};
        end
    end

endmodule
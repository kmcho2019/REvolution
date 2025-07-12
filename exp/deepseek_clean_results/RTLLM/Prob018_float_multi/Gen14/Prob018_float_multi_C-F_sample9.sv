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

    // Normalized mantissas with implicit bit
    wire [23:0] a_mant = (a_exp != 0) ? {1'b1, a_man} : {1'b0, a_man};
    wire [23:0] b_mant = (b_exp != 0) ? {1'b1, b_man} : {1'b0, b_man};

    // Special case detection (prioritized)
    wire is_nan = (a_exp == 8'hFF && |a_man) || (b_exp == 8'hFF && |b_man);
    wire is_inf = (a_exp == 8'hFF && ~|a_man) || (b_exp == 8'hFF && ~|b_man);
    wire is_zero = (a_exp == 0 && ~|a_man) || (b_exp == 0 && ~|b_man);
    wire inf_zero = ((a_exp == 8'hFF && b_exp == 0) || (b_exp == 8'hFF && a_exp == 0));

    // Multiplication core
    wire [47:0] product = a_mant * b_mant;
    wire product_msb = product[47];
    wire [7:0] exp_sum = a_exp + b_exp - 8'd127;
    wire [7:0] final_exp = product_msb ? exp_sum + 1 : exp_sum;
    wire [22:0] final_man = product_msb ? product[46:24] : product[45:23];

    // Overflow/underflow detection
    wire overflow = (&final_exp) || (final_exp >= 8'hFF);
    wire underflow = (final_exp == 0) || (final_exp[7] && (final_exp != 8'hFF));

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Priority-encoded special cases
            if (is_nan || inf_zero) begin
                z <= 32'h7FC00000; // NaN
            end else if (is_inf) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
            end else if (is_zero) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Zero
            end else if (overflow) begin
                z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Overflow -> Infinity
            end else if (underflow) begin
                z <= {a_sign ^ b_sign, 31'b0}; // Underflow -> Zero
            end else begin
                z <= {a_sign ^ b_sign, final_exp, final_man}; // Normal case
            end
        end
    end

endmodule
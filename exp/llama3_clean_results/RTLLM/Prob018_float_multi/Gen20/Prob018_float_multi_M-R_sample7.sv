// float_multi.v
module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

reg [31:0] pre_a, pre_b;
reg pre_rst;

// Preprocessing
assign pre_a = a;
assign pre_b = b;
assign pre_rst = rst;

// Operand Preprocessing Module
float_preproc u_preproc(
    .a(pre_a),
    .b(pre_b),
    .rst(pre_rst),
    .a_mantissa(a_mantissa),
    .b_mantissa(b_mantissa),
    .a_exponent(a_exponent),
    .b_exponent(b_exponent),
    .a_sign(a_sign),
    .b_sign(b_sign)
);

// Mantissa Multiplication Module
float_mult u_mult(
    .a_mantissa(a_mantissa),
    .b_mantissa(b_mantissa),
    .product(mantissa_product)
);

// Exponent and Sign Processing Module
float_exp u_exp(
    .a_exponent(a_exponent),
    .b_exponent(b_exponent),
    .a_sign(a_sign),
    .b_sign(b_sign),
    .exponent(final_exponent),
    .sign(final_sign)
);

// Rounding and Post-processing Module
float_round u_round(
    .mantissa_product(mantissa_product),
    .exponent(final_exponent),
    .sign(final_sign),
    .result(final_result)
);

// Clock Domain Crossing (CDC)
reg [31:0] cdc_result;
always @(posedge clk) begin
    cdc_result <= final_result;
end

assign z = cdc_result;

// Internal Signals
reg [23:0] a_mantissa, b_mantissa, mantissa_product;
reg [7:0] a_exponent, b_exponent, final_exponent;
reg a_sign, b_sign, final_sign;
reg [31:0] final_result;

endmodule

// float_preproc.v
module float_preproc(
    input [31:0] a, b,
    input rst,
    output reg [23:0] a_mantissa, b_mantissa,
    output reg [7:0] a_exponent, b_exponent,
    output reg a_sign, b_sign
);

always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 0;
        b_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
    end else begin
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
    end
end

endmodule

// float_mult.v
module float_mult(
    input [23:0] a_mantissa, b_mantissa,
    output reg [49:0] product
);

always @(posedge clk) begin
    product <= a_mantissa * b_mantissa;
end

endmodule

// float_exp.v
module float_exp(
    input [7:0] a_exponent, b_exponent,
    input a_sign, b_sign,
    output reg [7:0] exponent,
    output reg sign
);

always @(posedge clk) begin
    exponent <= a_exponent + b_exponent - 8'd127;
    sign <= a_sign ^ b_sign;
end

endmodule

// float_round.v
module float_round(
    input [49:0] mantissa_product,
    input [7:0] exponent,
    input sign,
    output reg [31:0] result
);

always @(posedge clk) begin
    // Rounding logic implementation
    if (exponent > 8'd254) begin
        result <= (sign)? 32'hff800000 : 32'h7f800000; // Overflow
    end else if (exponent < 8'd1) begin
        result <= {sign, 8'b0, mantissa_product[22:0]}; // Underflow or denormalized
    end else begin
        result <= {sign, exponent, mantissa_product[22:0]}; // Normalized result
    end
end

endmodule
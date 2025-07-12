module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [31:0] a_sign, a_exponent, a_mantissa;
reg [31:0] b_sign, b_exponent, b_mantissa;
reg [49:0] product;
reg [7:0] z_exponent;
reg [22:0] z_mantissa;
reg z_sign;

// Input processing module
module input_processing(
    input [31:0] a, b,
    output reg [31:0] a_sign, a_exponent, a_mantissa,
    output reg [31:0] b_sign, b_exponent, b_mantissa
);
    assign a_sign = a[31];
    assign a_exponent = a[30:23];
    assign a_mantissa = {1'b1, a[22:0]};
    assign b_sign = b[31];
    assign b_exponent = b[30:23];
    assign b_mantissa = {1'b1, b[22:0]};
endmodule

// Mantissa multiplication module
module mantissa_multiplication(
    input [23:0] a_mantissa, b_mantissa,
    output reg [49:0] product
);
    assign product = a_mantissa * b_mantissa;
endmodule

// Exponent calculation module
module exponent_calculation(
    input [8:0] a_exponent, b_exponent,
    output reg [8:0] z_exponent
);
    assign z_exponent = a_exponent + b_exponent - 9'd127;
endmodule

// Rounding module
module rounding(
    input [49:0] product,
    output reg [22:0] z_mantissa
);
    reg [1:0] guard_round_sticky;
    assign guard_round_sticky = product[23:22];
    assign z_mantissa = product[49:27];
endmodule

// Result formatting module
module result_formatting(
    input z_sign, [8:0] z_exponent, [22:0] z_mantissa,
    output reg [31:0] z
);
    assign z = {z_sign, z_exponent, z_mantissa};
endmodule

// Instantiate modules
input_processing ip(
    .a(a), .b(b),
    .a_sign(a_sign), .a_exponent(a_exponent), .a_mantissa(a_mantissa),
    .b_sign(b_sign), .b_exponent(b_exponent), .b_mantissa(b_mantissa)
);

mantissa_multiplication mm(
    .a_mantissa(a_mantissa[23:0]), .b_mantissa(b_mantissa[23:0]),
    .product(product)
);

exponent_calculation ec(
    .a_exponent(a_exponent), .b_exponent(b_exponent),
    .z_exponent(z_exponent)
);

rounding r(
    .product(product),
    .z_mantissa(z_mantissa)
);

result_formatting rf(
    .z_sign(a_sign ^ b_sign), .z_exponent(z_exponent), .z_mantissa(z_mantissa),
    .z(z)
);

endmodule
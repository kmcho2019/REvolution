// Stage 1: Input Processing
module input_processing(
    input [31:0] a, b,
    output reg [23:0] a_mantissa, b_mantissa,
    output reg [8:0] a_exponent, b_exponent,
    output reg a_sign, b_sign,
    output reg a_nan, b_nan,
    output reg a_inf, b_inf
);

    assign a_mantissa = a[22:0];
    assign b_mantissa = b[22:0];
    assign a_exponent = a[30:23];
    assign b_exponent = b[30:23];
    assign a_sign = a[31];
    assign b_sign = b[31];
    assign a_nan = (a_exponent == 9'b11111111) && (a_mantissa != 0);
    assign b_nan = (b_exponent == 9'b11111111) && (b_mantissa != 0);
    assign a_inf = (a_exponent == 9'b11111111) && (a_mantissa == 0);
    assign b_inf = (b_exponent == 9'b11111111) && (b_mantissa == 0);

endmodule

// Stage 2: Exponent Processing
module exponent_processing(
    input [8:0] a_exponent, b_exponent,
    output reg [8:0] z_exponent,
    output reg overflow
);

    assign z_exponent = a_exponent + b_exponent - 9'b10000000;
    assign overflow = (z_exponent > 9'b11111110);

endmodule

// Stage 3: Mantissa Multiplication
module mantissa_multiplication(
    input [23:0] a_mantissa, b_mantissa,
    output reg [49:0] product
);

    assign product = {1'b1, a_mantissa} * {1'b1, b_mantissa};

endmodule

// Stage 4: Rounding and Normalization
module rounding_normalization(
    input [49:0] product,
    output reg [23:0] z_mantissa,
    output reg round_bit, guard_bit, sticky
);

    assign round_bit = product[23];
    assign guard_bit = product[24];
    assign sticky = |product[22:0];
    assign z_mantissa = (guard_bit || round_bit || sticky) ? product[48:25] + 1 : product[48:25];

endmodule

// Stage 5: Output Formatting
module output_formatting(
    input a_sign, b_sign,
    input [8:0] z_exponent,
    input [23:0] z_mantissa,
    input a_nan, b_nan, a_inf, b_inf,
    output reg [31:0] z
);

    reg z_sign;
    assign z_sign = a_sign ^ b_sign;

    always @(*) begin
        if (a_nan || b_nan) begin
            // NaN handling
            z = 32'b1;
        end else if (a_inf || b_inf) begin
            // Infinity handling
            if (a_sign ^ b_sign) begin
                z = 32'b1000_0000_0000_0000_0000_0000_0000_0000; // Negative Infinity
            end else begin
                z = 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Positive Infinity
            end
        end else begin
            // Normal result
            z = {z_sign, z_exponent, z_mantissa};
        end
    end

endmodule

// Top-level module
module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    wire [23:0] a_mantissa, b_mantissa;
    wire [8:0] a_exponent, b_exponent;
    wire a_sign, b_sign;
    wire a_nan, b_nan, a_inf, b_inf;
    wire [8:0] z_exponent;
    wire overflow;
    wire [49:0] product;
    wire [23:0] z_mantissa;
    wire round_bit, guard_bit, sticky;

    input_processing ip(
        .a(a), .b(b),
        .a_mantissa(a_mantissa), .b_mantissa(b_mantissa),
        .a_exponent(a_exponent), .b_exponent(b_exponent),
        .a_sign(a_sign), .b_sign(b_sign),
        .a_nan(a_nan), .b_nan(b_nan),
        .a_inf(a_inf), .b_inf(b_inf)
    );

    exponent_processing ep(
        .a_exponent(a_exponent), .b_exponent(b_exponent),
        .z_exponent(z_exponent), .overflow(overflow)
    );

    mantissa_multiplication mm(
        .a_mantissa(a_mantissa), .b_mantissa(b_mantissa),
        .product(product)
    );

    rounding_normalization rn(
        .product(product),
        .z_mantissa(z_mantissa),
        .round_bit(round_bit), .guard_bit(guard_bit), .sticky(sticky)
    );

    output_formatting of(
        .a_sign(a_sign), .b_sign(b_sign),
        .z_exponent(z_exponent), .z_mantissa(z_mantissa),
        .a_nan(a_nan), .b_nan(b_nan), .a_inf(a_inf), .b_inf(b_inf),
        .z(z)
    );

endmodule
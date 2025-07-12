module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Modular Design
wire [23:0] a_mantissa, b_mantissa;
wire [7:0] a_exponent, b_exponent;
wire a_sign, b_sign;

// Input Processing Module
input_processing ip(
    .a(a),
    .b(b),
    .a_mantissa(a_mantissa),
    .b_mantissa(b_mantissa),
    .a_exponent(a_exponent),
    .b_exponent(b_exponent),
    .a_sign(a_sign),
    .b_sign(b_sign)
);

// Pipelined Architecture
reg [23:0] mantissa_product;
reg [7:0] exponent_sum;
reg sign;
always @(posedge clk) begin
    if (rst) begin
        mantissa_product <= 0;
        exponent_sum <= 0;
        sign <= 0;
    end else begin
        // Stage 1: Mantissa Multiplication
        mantissa_product <= a_mantissa * b_mantissa;
        
        // Stage 2: Exponent Calculation
        exponent_sum <= a_exponent + b_exponent - 8'd127;
        
        // Stage 3: Sign Calculation
        sign <= a_sign ^ b_sign;
    end
end

// Rounding and Overflow/Underflow Handling Module
rounding_unit ru(
    .mantissa_product(mantissa_product),
    .exponent_sum(exponent_sum),
    .sign(sign),
    .z(z)
);

endmodule

module input_processing(
    input [31:0] a, b,
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

module rounding_unit(
    input [23:0] mantissa_product,
    input [7:0] exponent_sum,
    input sign,
    output reg [31:0] z
);

reg [23:0] rounded_mantissa;
reg [7:0] final_exponent;
reg final_sign;

always @(posedge clk) begin
    if (rst) begin
        rounded_mantissa <= 0;
        final_exponent <= 0;
        final_sign <= 0;
    end else begin
        // Rounding Logic
        rounded_mantissa <= mantissa_product + 1'b1;
        
        // Overflow/Underflow Handling
        if (exponent_sum > 8'd254) begin
            final_exponent <= 8'd255;
            rounded_mantissa <= 0;
        end else if (exponent_sum < 8'd1) begin
            final_exponent <= 0;
        end else begin
            final_exponent <= exponent_sum;
        end
        
        final_sign <= sign;
        
        // Output Formatting
        z <= {final_sign, final_exponent, rounded_mantissa[22:0]};
    end
end

endmodule
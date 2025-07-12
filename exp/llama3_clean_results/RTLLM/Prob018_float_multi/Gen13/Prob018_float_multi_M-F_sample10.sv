module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [31:0] a_sign, a_exponent, a_mantissa;
reg [31:0] b_sign, b_exponent, b_mantissa;
reg [31:0] z_sign, z_exponent, z_mantissa;
reg [23:0] product_mantissa;
reg [8:0] product_exponent;
reg sign_bit;
reg [2:0] counter;

// Clock gating
reg clk_gated;

always @(posedge clk) begin
    if (rst) begin
        clk_gated <= 0;
    end else if (counter!= 0) begin
        clk_gated <= 1;
    end else begin
        clk_gated <= 0;
    end
end

// Floating-point representation
always @(posedge clk) begin
    if (rst) begin
        a_sign <= 0;
        a_exponent <= 0;
        a_mantissa <= 0;
        b_sign <= 0;
        b_exponent <= 0;
        b_mantissa <= 0;
        counter <= 0;
    end else if (counter == 0 && clk_gated) begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= {1'b1, a[22:0]};
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= {1'b1, b[22:0]};
        counter <= counter + 1;
    end
end

// Exponent calculation
always @(posedge clk) begin
    if (counter == 1 && clk_gated) begin
        product_exponent <= a_exponent + b_exponent - 127;
    end
end

// Mantissa multiplication
reg [49:0] product;
always @(posedge clk) begin
    if (counter == 1 && clk_gated) begin
        product <= (a_mantissa * b_mantissa);
    end
end

// Rounding and normalization
always @(posedge clk) begin
    if (counter == 2 && clk_gated) begin
        if (product[49]) begin
            product_mantissa <= product[48:25];
            product_exponent <= product_exponent + 1;
        end else begin
            product_mantissa <= product[47:24];
        end
        sign_bit <= a_sign ^ b_sign;
        counter <= counter + 1;
    end
end

// Special cases handling
always @(posedge clk) begin
    if (counter == 3 && clk_gated) begin
        if ((a_exponent == 255 && a_mantissa!= 0) || (b_exponent == 255 && b_mantissa!= 0)) begin
            z <= 32'h7fc00000; // NaN
        end else if ((a_exponent == 255 && a_mantissa == 0) || (b_exponent == 255 && b_mantissa == 0)) begin
            z <= sign_bit? 32'hff800000 : 32'h7f800000; // Infinity
        end else if (product_exponent > 255) begin
            z <= sign_bit? 32'hff7fffff : 32'h7f7fffff; // Overflow
        end else if (product_exponent < 1) begin
            z <= 32'h00000000; // Underflow
        end else begin
            z <= {sign_bit, product_exponent + 127, product_mantissa[23:1]};
        end
        counter <= 0;
    end
end

endmodule
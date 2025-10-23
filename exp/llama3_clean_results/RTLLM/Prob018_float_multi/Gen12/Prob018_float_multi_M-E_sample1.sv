module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [7:0] a_exponent, b_exponent;
reg [22:0] a_mantissa, b_mantissa;
reg sign_bit;
reg [23:0] product_mantissa;
reg [8:0] product_exponent;
reg [2:0] counter;

// Exponent calculation
always @(posedge clk) begin
    if (rst) begin
        a_exponent <= 0;
        b_exponent <= 0;
        product_exponent <= 0;
    end else begin
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        product_exponent <= a_exponent + b_exponent;
    end
end

// Mantissa multiplication
always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 0;
        b_mantissa <= 0;
        product_mantissa <= 0;
    end else begin
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        product_mantissa <= (a_mantissa * b_mantissa) >> 23;
    end
end

// Sign bit calculation
always @(posedge clk) begin
    if (rst) begin
        sign_bit <= 0;
    end else begin
        sign_bit <= a[31] ^ b[31];
    end
end

// Normalization
always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
    end else if (counter == 0) begin
        if (product_mantissa[23]) begin
            product_mantissa <= product_mantissa >> 1;
            product_exponent <= product_exponent + 1;
        end
        counter <= counter + 1;
    end else if (counter == 1) begin
        counter <= 0;
    end
end

// Rounding
always @(posedge clk) begin
    if (rst) begin
        z <= 0;
    end else if (counter == 1) begin
        if (product_mantissa[22]) begin
            product_mantissa <= product_mantissa + 1;
        end
        z <= {sign_bit, product_exponent, product_mantissa[22:0]};
    end
end

// Special cases handling
always @(posedge clk) begin
    if (rst) begin
        // Reset special cases
    end else if (a_exponent == 255 && a_mantissa != 0) begin
        // NaN
        z <= 32'h7fc00000;
    end else if (b_exponent == 255 && b_mantissa != 0) begin
        // NaN
        z <= 32'h7fc00000;
    end else if (a_exponent == 255 && a_mantissa == 0) begin
        // Infinity
        z <= sign_bit? 32'hff800000 : 32'h7f800000;
    end else if (b_exponent == 255 && b_mantissa == 0) begin
        // Infinity
        z <= sign_bit? 32'hff800000 : 32'h7f800000;
    end else if (product_exponent > 255) begin
        // Overflow
        z <= sign_bit? 32'hff7fffff : 32'h7f7fffff;
    end else if (product_exponent < 1) begin
        // Underflow
        z <= 32'h00000000;
    end
end

endmodule
module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Hybrid Floating-Point Representation
wire [23:0] a_mantissa, b_mantissa;
wire [7:0] a_exponent, b_exponent;
wire a_sign, b_sign;

// Segmented Multiplication
reg [23:0] product_segment1, product_segment2;
reg [23:0] product;
always @(posedge clk) begin
    if (rst) begin
        product_segment1 <= 0;
        product_segment2 <= 0;
    end else begin
        product_segment1 <= a_mantissa[15:0] * b_mantissa[15:0];
        product_segment2 <= a_mantissa[23:16] * b_mantissa[23:16];
        product <= product_segment1 + (product_segment2 << 16);
    end
end

// Pipelined Exponent Calculation
reg [7:0] exponent_sum;
reg [7:0] final_exponent;
always @(posedge clk) begin
    if (rst) begin
        exponent_sum <= 0;
        final_exponent <= 0;
    end else begin
        exponent_sum <= a_exponent + b_exponent - 8'd127;
        final_exponent <= exponent_sum;
    end
end

// Rounding and Normalization Unit
reg [23:0] rounded_mantissa;
reg sign;
always @(posedge clk) begin
    if (rst) begin
        rounded_mantissa <= 0;
        sign <= 0;
    end else begin
        // Rounding Logic
        rounded_mantissa <= product + 1'b1;
        
        // Normalization
        if (rounded_mantissa[23]) begin
            rounded_mantissa <= rounded_mantissa >> 1;
            final_exponent <= final_exponent + 1'b1;
        end
        
        sign <= a_sign ^ b_sign;
    end
end

// Output Generation
always @(posedge clk) begin
    if (rst) begin
        z <= 0;
    end else begin
        z <= {sign, final_exponent, rounded_mantissa[22:0]};
    end
end

endmodule
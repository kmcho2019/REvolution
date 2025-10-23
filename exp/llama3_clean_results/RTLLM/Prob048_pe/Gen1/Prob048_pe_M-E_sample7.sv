module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

// Stage 1: Booth Multiplier
reg [31:0] a_reg, b_reg;
reg [63:0] product;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
    end
end

// Simplified Booth Multiplier for illustration purposes
// In practice, a more efficient implementation would be used
always @(*) begin
    product = a_reg * b_reg;
end

// Stage 2: Accumulator
reg [31:0] c_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + product[31:0]; // Accumulate the lower 32 bits of the product
    end
end

assign c = c_reg;

endmodule
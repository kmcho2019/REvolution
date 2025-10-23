module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

// Pipeline registers
reg [31:0] a_reg, b_reg;
reg [31:0] product;
reg [31:0] accum;

// Stage 1: Input registration and multiplication
always @(posedge clk) begin
    if (rst) begin
        a_reg <= 0;
        b_reg <= 0;
        product <= 0;
    end else begin
        a_reg <= a;
        b_reg <= b;
        product <= a_reg * b_reg;
    end
end

// Stage 2: Accumulation
always @(posedge clk) begin
    if (rst) begin
        accum <= 0;
        c <= 0;
    end else begin
        accum <= accum + product;
        c <= accum;
    end
end

endmodule
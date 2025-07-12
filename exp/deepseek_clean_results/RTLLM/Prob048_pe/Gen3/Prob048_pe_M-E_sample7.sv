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
reg [31:0] acc_reg;

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
        acc_reg <= 0;
        c <= 0;
    end else begin
        acc_reg <= acc_reg + product;
        c <= acc_reg;
    end
end

endmodule
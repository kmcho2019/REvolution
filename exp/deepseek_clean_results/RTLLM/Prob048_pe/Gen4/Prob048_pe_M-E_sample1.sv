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
reg inputs_changed;

// Stage 1: Input registration and multiplication
always @(posedge clk) begin
    if (rst) begin
        a_reg <= 0;
        b_reg <= 0;
        product <= 0;
        inputs_changed <= 0;
    end else begin
        a_reg <= a;
        b_reg <= b;
        product <= a_reg * b_reg;
        inputs_changed <= (a != a_reg) || (b != b_reg);
    end
end

// Stage 2: Conditional accumulation
always @(posedge clk) begin
    if (rst) begin
        acc_reg <= 0;
        c <= 0;
    end else if (inputs_changed) begin
        acc_reg <= acc_reg + product;
        c <= acc_reg + product;
    end
end

endmodule
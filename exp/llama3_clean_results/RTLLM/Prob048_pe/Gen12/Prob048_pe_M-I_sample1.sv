module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Clock Gating
reg clk_gated;
always @(posedge clk) begin
    if (rst) begin
        clk_gated <= 1'b0;
    end else if (a != 32'd0 || b != 32'd0) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Pipeline Stage 1: Multiplication
reg [31:0] mult_result;
always @(posedge clk_gated) begin
    if (rst) begin
        mult_result <= 32'd0;
    end else begin
        mult_result <= a * b;
    end
end

// Pipeline Stage 2: Accumulation
reg [31:0] c_reg;
always @(posedge clk_gated) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult_result;
    end
end

// Output Assignment
assign c = c_reg;

endmodule
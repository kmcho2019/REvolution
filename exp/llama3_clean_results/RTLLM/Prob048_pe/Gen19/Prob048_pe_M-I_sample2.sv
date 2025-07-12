module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Pipelining Registers
reg [31:0] mult_reg;
reg [31:0] accum_reg;

// Pipeline Stage 1: Multiplication
always @(posedge clk) begin
    if (rst) begin
        mult_reg <= 32'd0;
    end else begin
        mult_reg <= a * b;
    end
end

// Pipeline Stage 2: Accumulation
always @(posedge clk) begin
    if (rst) begin
        accum_reg <= 32'd0;
    end else begin
        accum_reg <= accum_reg + mult_reg;
    end
end

// Output Assignment
assign c = accum_reg;

endmodule
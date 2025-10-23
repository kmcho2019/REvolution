module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Combinational Logic for Multiplication
wire [31:0] mult;

assign mult = a * b;

// Accumulator Register
reg [31:0] c_reg;

// Sequential Logic for Accumulation
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult;
    end
end

// Output Assignment
assign c = c_reg;

endmodule
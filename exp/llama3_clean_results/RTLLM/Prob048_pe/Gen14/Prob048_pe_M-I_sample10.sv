module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Pipelined Multiplication and Accumulation
reg [31:0] mult_result;
reg [31:0] accum_result;

always @(posedge clk) begin
    if (rst) begin
        mult_result <= 32'd0;
        accum_result <= 32'd0;
    end else begin
        mult_result <= a * b;
        accum_result <= accum_result + mult_result;
    end
end

// Output Assignment
assign c = accum_result;

endmodule
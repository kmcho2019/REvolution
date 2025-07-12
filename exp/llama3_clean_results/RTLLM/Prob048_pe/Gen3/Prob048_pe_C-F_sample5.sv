module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output reg [31:0] c  // Accumulated result
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0; // Reset the accumulator register to 0 on reset
    end else begin
        // Explicit multiplication and accumulation for clarity
        c <= c + (a * b); // Accumulate the product of a and b into the register c
    end
end

endmodule
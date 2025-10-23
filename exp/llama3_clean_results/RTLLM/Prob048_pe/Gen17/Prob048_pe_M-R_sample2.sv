module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Accumulator register

always @(posedge clk) begin
    if (rst) begin
        // Reset accumulator register when reset signal is active
        c_reg <= 32'd0;
    end else begin
        // Accumulate the product of input operands in the register
        c_reg <= c_reg + (a * b);
    end
end

assign c = c_reg;  // Assign accumulated result to output

endmodule
module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result

// Assign output to the register
assign c = c_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the accumulator register to 0
        c_reg <= 32'd0;
    end else begin
        // Multiply the input operands and add to the accumulator register
        c_reg <= c_reg + (a * b);
    end
end

endmodule
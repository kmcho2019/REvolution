module pe(
    input clk,        // Clock signal
    input rst,        // Reset signal
    input [31:0] a,   // 32-bit input operand A
    input [31:0] b,   // 32-bit input operand B
    output [31:0] c   // 32-bit output representing the accumulated result
);

reg [31:0] c_reg;    // Register to store the accumulated result

// Initialize the output
assign c = c_reg;

// Always block for synchronous operations
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the register if the reset signal is high
        c_reg <= 32'd0;
    end else begin
        // Update the register by adding the product of the input operands to its current value
        c_reg <= c_reg + (a * b);
    end
end

endmodule
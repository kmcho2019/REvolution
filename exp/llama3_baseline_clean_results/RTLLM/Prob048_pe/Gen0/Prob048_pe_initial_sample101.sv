module pe(
    input clk,      // Clock signal
    input rst,      // Reset signal
    input [31:0] a, // 32-bit input operand A
    input [31:0] b, // 32-bit input operand B
    output [31:0] c // 32-bit output representing the accumulated result
);

reg [31:0] c_reg; // Register to store the accumulated result

// Always block to update the register on positive edge of clock or reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the register to 0 when reset signal is high
        c_reg <= 0;
    end else begin
        // Update the register by adding the product of input operands to its current value
        c_reg <= c_reg + (a * b);
    end
end

// Assign the output to the register
assign c = c_reg;

endmodule
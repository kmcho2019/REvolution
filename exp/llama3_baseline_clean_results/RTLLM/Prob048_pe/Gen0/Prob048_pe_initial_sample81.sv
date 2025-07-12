module pe(
    input clk, // Clock signal
    input rst, // Reset signal
    input [31:0] a, // 32-bit input operand A
    input [31:0] b, // 32-bit input operand B
    output [31:0] c // 32-bit output representing the accumulated result
);

reg [31:0] c_reg; // Register to store the accumulated result

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the accumulator register to 0
        c_reg <= 0;
    end else begin
        // Accumulate the product of a and b
        c_reg <= c_reg + (a * b);
    end
end

assign c = c_reg; // Assign the register value to the output

endmodule
module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result

assign c = c_reg;  // Drive the output from the register

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;  // Reset the register to 0 on reset
    end else begin
        c_reg <= c_reg + (a * b);  // Accumulate the product of a and b
    end
end

endmodule
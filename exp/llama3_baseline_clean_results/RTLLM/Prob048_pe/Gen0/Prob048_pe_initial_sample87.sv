module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // 32-bit input operand A
    input [31:0] b,  // 32-bit input operand B
    output [31:0] c  // 32-bit output representing the accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result

assign c = c_reg;  // Assign the output port "c" to the register "c_reg"

always @ (posedge clk or posedge rst) begin
    if (rst) begin  // Reset condition
        c_reg <= 32'd0;  // Reset the register "c_reg" to 0
    end else begin
        c_reg <= c_reg + (a * b);  // Update the register "c_reg" by adding the product of "a" and "b"
    end
end

endmodule
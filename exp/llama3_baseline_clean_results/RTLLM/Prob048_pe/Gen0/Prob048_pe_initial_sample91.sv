module pe(
    input           clk,  // Clock signal
    input           rst,  // Reset signal
    input   [31:0]  a,    // 32-bit input operand A
    input   [31:0]  b,    // 32-bit input operand B
    output  [31:0]  c     // 32-bit output representing the accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the register to 0 when the reset signal is high
        c_reg <= 32'd0;
    end else begin
        // Multiply the input operands and accumulate the result in the register
        c_reg <= c_reg + (a * b);
    end
end

// Assign the output 'c' to the register 'c_reg'
assign c = c_reg;

endmodule
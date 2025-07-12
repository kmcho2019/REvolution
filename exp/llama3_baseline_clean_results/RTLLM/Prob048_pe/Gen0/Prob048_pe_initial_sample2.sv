module pe (
    input         clk,    // Clock signal
    input         rst,    // Reset signal
    input  [31:0] a,      // 32-bit input operand A
    input  [31:0] b,      // 32-bit input operand B
    output [31:0] c       // 32-bit output representing the accumulated result
);

reg [31:0] c_reg; // Register to store the accumulated result

assign c = c_reg; // Continuous assignment to output the accumulated result

always @ (posedge clk or posedge rst) begin
    if (rst) begin // If reset signal is high
        c_reg <= 32'd0; // Reset the accumulator register to 0
    end else begin // If reset signal is low
        c_reg <= c_reg + (a * b); // Accumulate the product of the input operands
    end
end

endmodule
module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result

always @(posedge clk) begin
    if (rst) begin
        // Reset the register when reset signal is high
        c_reg <= 32'd0;
    end else begin
        // Accumulate the result in the register
        c_reg <= c_reg + (a * b);
    end
end

// Output Assignment
assign c = c_reg;

endmodule
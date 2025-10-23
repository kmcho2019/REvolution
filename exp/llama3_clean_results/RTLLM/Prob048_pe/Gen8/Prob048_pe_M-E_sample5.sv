module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Accumulator register

// Bit-Level Multiplication and Pipelined Accumulation
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + (a[0] * b[0]);
        for (int i = 1; i < 32; i++) begin
            c_reg <= c_reg + (a[i] * b[i]) << i;
        end
    end
end

// Output Assignment
assign c = c_reg;

endmodule
module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;
wire [31:0] mult_result;

// Multiply a and b
assign mult_result = a * b;

// Update c_reg on the positive edge of the clock
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult_result;
    end
end

// Assign c_reg to output c
assign c = c_reg;

endmodule
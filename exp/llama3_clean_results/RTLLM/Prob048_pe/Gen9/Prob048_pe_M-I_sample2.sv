module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] product;  // Register to store the product of a and b
reg [31:0] c_reg;  // Register to store the accumulated result

assign c = c_reg;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        product <= a * b;
        c_reg <= c_reg + product;
    end
end

endmodule
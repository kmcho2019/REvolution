module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
reg [31:0] product_reg;  // Register to hold the product of a and b

// Calculate the product of a and b
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;  // Reset condition
        product_reg <= 32'd0;  // Reset product register
    end else begin
        product_reg <= a * b;  // Update product register
        c_reg <= c_reg + product_reg;  // Accumulate product
    end
end

// Assign the output
assign c = c_reg;

endmodule
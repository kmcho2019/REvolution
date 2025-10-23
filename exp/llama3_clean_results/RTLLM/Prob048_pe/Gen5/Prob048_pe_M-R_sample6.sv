module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
wire [31:0] product;  // Wire to hold the product of a and b

// Calculate the product of a and b
assign product = a * b;

// Conditional update of c_reg based on rst
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;  // Reset condition
    end else begin
        c_reg <= c_reg + product;  // Accumulate product
    end
end

// Assign the output
assign c = c_reg;

endmodule
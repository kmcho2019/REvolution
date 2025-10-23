module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
wire [31:0] product;  // Wire to store the product of a and b

// Combinational logic to perform multiplication
assign product = a * b;

// Always block to update the accumulator
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + product;
    end
end

// Output assignment
assign c = c_reg;

endmodule
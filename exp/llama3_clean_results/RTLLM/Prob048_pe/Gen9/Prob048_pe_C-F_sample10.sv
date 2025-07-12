module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Register to store the accumulated result
reg [31:0] c_reg;

// Assign output
assign c = c_reg;

// Always block to handle reset and multiplication-accumulation
always @(posedge clk) begin
    if (rst) begin
        // Reset condition: set the accumulated result to 0
        c_reg <= 32'd0;
    end else begin
        // Multiplication-accumulation operation
        c_reg <= c_reg + (a * b);
    end
end

endmodule
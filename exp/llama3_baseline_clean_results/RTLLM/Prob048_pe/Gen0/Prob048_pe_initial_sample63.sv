module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the register when the reset signal is high
        c_reg <= 32'd0;
    end else begin
        // Accumulate the product of the input operands when the reset signal is low
        c_reg <= c_reg + (a * b);
    end
end

// Continuous assignment to output the current value of the register
assign c = c_reg;

endmodule
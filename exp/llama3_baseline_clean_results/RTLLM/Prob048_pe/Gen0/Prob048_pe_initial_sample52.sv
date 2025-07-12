module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg; // Register to store the accumulated result

assign c = c_reg; // Assign the register value to the output port

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // If the reset signal is high, set the register to 0
        c_reg <= 32'd0;
    end else begin
        // If the reset signal is low, update the register by adding the product of the input operands to its current value
        c_reg <= c_reg + (a * b);
    end
end

endmodule
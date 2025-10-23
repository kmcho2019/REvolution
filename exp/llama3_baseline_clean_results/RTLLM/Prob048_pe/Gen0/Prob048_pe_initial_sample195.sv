module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // If reset signal is high, set the register c to 0
        c <= 32'd0;
    end else begin
        // If reset signal is low, update the register c by adding the product of a and b to its current value
        c <= c + (a * b);
    end
end

endmodule
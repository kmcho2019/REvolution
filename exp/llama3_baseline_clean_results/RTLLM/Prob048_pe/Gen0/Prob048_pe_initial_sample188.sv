module pe(
    input clk, // Clock signal
    input rst, // Reset signal
    input [31:0] a, // 32-bit input operand A
    input [31:0] b, // 32-bit input operand B
    output reg [31:0] c  // 32-bit output representing the accumulated result
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // If reset signal is high, set register c to 0
        c <= 32'd0;
    end else begin
        // If reset signal is low, update register c by adding the product of a and b to its current value
        c <= c + (a * b);
    end
end

endmodule
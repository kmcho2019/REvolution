module pe (
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] c
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0; // Reset the accumulator register to 0 on reset
    end else begin
        c <= c + (a * b); // Accumulate the product of a and b into the register c
    end
end

endmodule
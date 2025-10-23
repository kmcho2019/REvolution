module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the accumulator register 'c' when the reset signal 'rst' is high
        c <= 32'd0;
    end else begin
        // Multiply input operands 'a' and 'b', and add the product to the accumulator register 'c'
        c <= c + (a * b);
    end
end

endmodule
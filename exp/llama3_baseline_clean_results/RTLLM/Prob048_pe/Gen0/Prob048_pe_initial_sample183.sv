module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg;

assign c = c_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // If reset signal is high, reset the accumulator register to 0
        c_reg <= 32'd0;
    end else begin
        // If reset signal is low, accumulate the result of a * b into the register
        c_reg <= c_reg + (a * b);
    end
end

endmodule
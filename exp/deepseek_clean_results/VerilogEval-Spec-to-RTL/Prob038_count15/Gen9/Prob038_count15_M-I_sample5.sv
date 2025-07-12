module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg clk_enable;
wire gated_clk = clk_enable & clk;

always @(*) begin
    clk_enable = ~(q == 4'b1111); // Disable clock when counter reaches 15
end

always @(posedge gated_clk or posedge reset) begin
    if (reset) q <= 0;
    else q <= q + 1;
end

endmodule
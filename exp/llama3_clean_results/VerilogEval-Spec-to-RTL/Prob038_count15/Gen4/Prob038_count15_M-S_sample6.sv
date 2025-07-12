module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q = 4'd0
);

always @(posedge clk)
    if (reset) q <= 4'd0;
    else q <= q + 1;

endmodule
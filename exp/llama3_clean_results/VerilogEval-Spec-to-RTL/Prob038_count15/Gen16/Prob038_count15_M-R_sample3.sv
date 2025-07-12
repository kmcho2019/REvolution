module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

always @(posedge clk)
    if (reset)
        q <= 4'd0;
    else
        q <= (q == 4'd15) ? 4'd0 : q + 4'd1;

endmodule
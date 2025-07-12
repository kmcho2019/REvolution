module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*)
    if (reset) next_q = 4'd0;
    else next_q = q + 1'd1;

always @(posedge clk)
    q <= next_q;

endmodule
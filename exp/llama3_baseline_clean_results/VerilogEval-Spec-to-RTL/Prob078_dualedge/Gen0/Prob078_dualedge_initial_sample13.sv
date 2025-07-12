module TopModule (
    input  clk,
    input  d,
    output reg q
);

reg internal_q;

always @(posedge clk)
    internal_q <= d;

always @(negedge clk)
    q <= internal_q;

endmodule
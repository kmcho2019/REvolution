module TopModule (
    input  clk,
    input  d,
    output reg q
);

always @(posedge clk or negedge clk)
    q <= d;

endmodule
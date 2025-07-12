module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

initial q = 1'b0;

always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;
    else    q <= d;

endmodule
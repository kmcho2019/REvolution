module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar)
    q <= 0;

always @(posedge clk)
    if (!ar) q <= d;

endmodule
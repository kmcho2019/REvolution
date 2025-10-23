module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg mid_q;

always @(negedge clk or posedge ar)
    if (ar) mid_q <= 1'b0; else mid_q <= d;

always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0; else q <= mid_q;

endmodule
module TopModule(
    input clk,
    input d,
    output q
);

reg q1, q2;
wire sel;

assign sel = clk;

always @(posedge clk)
    q1 <= d;

always @(negedge clk)
    q2 <= d;

assign q = (sel) ? q1 : q2;

endmodule
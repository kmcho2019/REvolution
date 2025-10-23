module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg stage1_q;
reg stage2_q;

always @(posedge clk or posedge ar)
    if (ar) stage1_q <= 1'b0; else if (clk) stage1_q <= d;

always @(posedge clk or posedge ar)
    if (ar) stage2_q <= 1'b0; else stage2_q <= stage1_q;

assign q = stage2_q;

endmodule
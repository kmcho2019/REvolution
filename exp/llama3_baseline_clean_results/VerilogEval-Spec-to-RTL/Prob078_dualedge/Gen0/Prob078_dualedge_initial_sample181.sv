module TopModule(
    input clk,
    input d,
    output reg q
);

reg dFF1_q;

always @(posedge clk)
    dFF1_q <= d;

always @(negedge clk)
    q <= dFF1_q;

endmodule
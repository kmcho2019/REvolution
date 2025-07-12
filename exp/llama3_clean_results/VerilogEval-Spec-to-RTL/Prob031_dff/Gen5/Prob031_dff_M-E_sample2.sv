module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_nxt;

always @(posedge clk)
    q_nxt <= d;

always @(*)
    q <= (clk) ? d : q_nxt;

endmodule
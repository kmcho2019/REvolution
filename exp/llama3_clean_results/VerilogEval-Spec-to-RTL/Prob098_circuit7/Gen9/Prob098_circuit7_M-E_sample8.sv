module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1;
always @(posedge clk)
    q <= a ? ~q : q;

endmodule
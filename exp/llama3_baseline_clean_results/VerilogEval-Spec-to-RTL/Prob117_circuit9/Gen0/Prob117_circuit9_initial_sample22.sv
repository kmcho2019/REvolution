module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

initial q = 4;

always @(posedge clk)
    if (!a && $past(a))
        q <= q + 1;

endmodule
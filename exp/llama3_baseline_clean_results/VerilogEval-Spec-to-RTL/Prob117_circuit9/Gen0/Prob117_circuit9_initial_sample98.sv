module TopModule(
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] count;

initial count = 4'd4;

always @(posedge clk)
    if (~a)
        count = (count == 7) ? 0 : count + 1;

assign q = count;

endmodule
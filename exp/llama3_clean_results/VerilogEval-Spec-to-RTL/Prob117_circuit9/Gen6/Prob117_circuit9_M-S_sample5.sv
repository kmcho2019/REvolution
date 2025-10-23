module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) 
    q <= (a) ? 4 : (q == 6) ? 0 : q + 1;

endmodule
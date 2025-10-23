module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) 
    q <= reset ? 4'd0 : (q == 4'd9 ? 4'd0 : q + 1);

endmodule
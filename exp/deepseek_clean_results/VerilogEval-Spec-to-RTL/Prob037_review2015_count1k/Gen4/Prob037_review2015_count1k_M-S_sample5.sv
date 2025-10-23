module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk)
    q <= reset ? 10'd0 : (q == 10'd999) ? 10'd0 : q + 1'b1;

endmodule
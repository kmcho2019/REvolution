module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

parameter MAX_COUNT = 10'd999;
parameter COUNTER_WIDTH = 10;

wire wrap = (q == MAX_COUNT);

always @(posedge clk) begin
    q <= reset ? 10'd0 : 
         wrap ? 10'd0 : 
         q + 1'b1;
end

endmodule
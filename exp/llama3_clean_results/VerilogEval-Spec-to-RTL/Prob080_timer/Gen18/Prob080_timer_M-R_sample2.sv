module DownCounter(
    input clk,
    input load,
    input [9:0] data,
    output reg [9:0] count
);

always @(posedge clk)
    count <= load ? data : (count > 0) ? count - 1 : 0;

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

reg [9:0] count;

DownCounter down_counter(clk, load, data, count);
always @(posedge clk)
    tc <= (count == 10'd0);

endmodule
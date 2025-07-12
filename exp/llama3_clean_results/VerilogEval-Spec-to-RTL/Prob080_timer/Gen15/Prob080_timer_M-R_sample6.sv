module DownCounter(
    input clk,
    input load,
    input [9:0] data,
    output [9:0] count,
    output tc
);

reg [9:0] internal_count;
assign count = internal_count;
assign tc = (internal_count == 10'd0);

always @(posedge clk)
    internal_count <= (load) ? data : (internal_count > 10'd0) ? internal_count - 1 : internal_count;

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

wire [9:0] count;
wire tc_internal;

DownCounter down_counter(clk, load, data, count, tc_internal);
assign tc = tc_internal;

endmodule
module DownCounter(
    input clk,
    input load,
    input [9:0] data,
    output [9:0] count
);

reg [9:0] internal_count;
wire [9:0] next_count;
assign next_count = load ? data : (internal_count == 10'd0) ? 10'd0 : internal_count - 1;
assign count = internal_count;

always @(posedge clk)
    internal_count <= next_count;

endmodule

module ControlLogic(
    input clk,
    input load,
    input [9:0] count,
    output tc
);

assign tc = (count == 10'd0);

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

wire [9:0] count;

DownCounter down_counter(clk, load, data, count);
ControlLogic control_logic(clk, load, count, tc);

endmodule
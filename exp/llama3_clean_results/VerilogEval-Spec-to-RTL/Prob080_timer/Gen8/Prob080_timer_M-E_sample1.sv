module DownCounter(
    input clk,
    input load,
    input [9:0] data,
    input enable,
    output [9:0] count
);

reg [9:0] internal_count;
assign count = internal_count;

always @(posedge clk)
    if (load)
        internal_count <= data;
    else if (enable)
        internal_count <= (internal_count == 10'd0) ? 10'd0 : internal_count - 1;

endmodule

module ControlLogic(
    input clk,
    input load,
    input [9:0] count,
    output enable,
    output tc
);

assign enable = ~load;
assign tc = (count == 10'd0);

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

wire enable;
wire [9:0] count;

DownCounter down_counter(clk, load, data, enable, count);
ControlLogic control_logic(clk, load, count, enable, tc);

endmodule
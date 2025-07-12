module DownCounter(
    input clk,
    input load,
    input [9:0] data,
    output reg [9:0] count
);

always @(posedge clk)
    if (load)
        count <= data;
    else if (count > 10'd0)
        count <= count - 1;

endmodule

module ControlLogic(
    input [9:0] count,
    output reg tc
);

always @(*)
    tc = (count == 10'd0);

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

wire [9:0] count;

DownCounter down_counter(clk, load, data, count);
ControlLogic control_logic(count, tc);

endmodule
module DownCounter(
    input clk,
    input load,
    input [9:0] data,
    output [9:0] count
);

reg [9:0] internal_count;
assign count = internal_count;

always @(posedge clk)
    if (load)
        internal_count <= data;
    else if (internal_count!= 10'd0)
        internal_count <= internal_count - 1'd1; // Explicitly use 1'd1 for decrement

endmodule

module ControlLogic(
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
ControlLogic control_logic(count, tc);

endmodule
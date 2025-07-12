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
    else if (enable && internal_count!= 10'd0)
        internal_count <= internal_count - 1;

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

wire [9:0] count;
wire enable;

DownCounter down_counter(clk, load, data, ~load, count);

assign enable = ~load;
assign tc = (count == 10'd0);

endmodule
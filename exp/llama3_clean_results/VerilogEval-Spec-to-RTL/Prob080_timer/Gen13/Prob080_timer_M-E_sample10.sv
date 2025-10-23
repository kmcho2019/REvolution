module VariableWidthCounter(
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
    else if (enable && internal_count != 10'd0)
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

assign enable = ~load;
VariableWidthCounter variable_width_counter(clk, load, data, enable, count);
assign tc = (count == 10'd0);

endmodule
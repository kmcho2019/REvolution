module DownCounter(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] internal_count;
always @(posedge clk)
    if (load)
        internal_count <= data;
    else if (internal_count != 10'd0)
        internal_count <= internal_count - 1;

assign tc = (internal_count == 10'd0);

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

DownCounter down_counter(clk, load, data, tc);

endmodule
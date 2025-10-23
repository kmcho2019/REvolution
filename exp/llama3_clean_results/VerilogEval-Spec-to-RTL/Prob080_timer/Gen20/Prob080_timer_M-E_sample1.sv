module ParameterizableDownCounter(
    input clk,
    input rst_n, // Active low reset
    input load,
    input [9:0] data,
    output [9:0] count,
    output tc // Terminal count
);

reg [9:0] internal_count;
reg [9:0] preload_value;

assign count = internal_count;
assign tc = (internal_count == 10'd0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        internal_count <= 10'd0;
        preload_value <= 10'd0;
    end else if (load) begin
        preload_value <= data;
        internal_count <= preload_value;
    end else if (internal_count > 0) begin
        internal_count <= internal_count - 1;
    end
end

endmodule

module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

wire [9:0] count;
wire tc_int;

ParameterizableDownCounter down_counter(clk, 1'b1, load, data, count, tc_int);
assign tc = tc_int;

endmodule
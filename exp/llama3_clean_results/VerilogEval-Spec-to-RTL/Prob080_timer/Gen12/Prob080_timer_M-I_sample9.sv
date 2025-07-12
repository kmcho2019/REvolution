module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] internal_count;
always @(posedge clk)
    internal_count <= load ? data : (internal_count == 10'd0) ? 10'd0 : internal_count - 1;

assign tc = (internal_count == 10'd0);

endmodule
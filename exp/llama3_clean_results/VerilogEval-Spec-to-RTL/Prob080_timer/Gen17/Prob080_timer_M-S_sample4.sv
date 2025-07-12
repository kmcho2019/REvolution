module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] internal_count;
assign tc = (internal_count == 10'd0);

always @(posedge clk)
    if (load)
        internal_count <= data;
    else if (internal_count != 10'd0)
        internal_count <= internal_count - 1;

endmodule
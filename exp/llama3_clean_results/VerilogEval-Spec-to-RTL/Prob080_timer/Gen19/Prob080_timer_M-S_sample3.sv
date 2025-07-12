module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;

always @(posedge clk)
    if (load)
        count <= data;
    else if (count != 10'd0)
        count <= count - 1;

assign tc = (count == 10'd0);

endmodule
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
assign tc = (count == 10'd0);

always @(posedge clk)
    if (load)
        count <= data;
    else if (count!= 10'd0)
        count <= count - 1;

endmodule
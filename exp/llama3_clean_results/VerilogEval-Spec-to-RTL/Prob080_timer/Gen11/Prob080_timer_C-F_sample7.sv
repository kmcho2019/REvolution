module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
assign tc = (counter == 10'd0);

always @(posedge clk)
    if (load)
        counter <= data;
    else if (counter!= 10'd0)
        counter <= counter - 1;

endmodule
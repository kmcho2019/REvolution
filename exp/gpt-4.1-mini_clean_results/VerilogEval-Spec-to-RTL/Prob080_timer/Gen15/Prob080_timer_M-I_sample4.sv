module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire enable;

assign enable = ~load & (counter != 0);

always @(posedge clk)
    counter <= load ? data : (enable ? counter - 1 : counter);

assign tc = (counter == 0);

endmodule
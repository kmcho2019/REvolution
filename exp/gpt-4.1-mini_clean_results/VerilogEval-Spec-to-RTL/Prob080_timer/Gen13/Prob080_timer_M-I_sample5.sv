module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire cnt_en = load | (counter != 0);

always @(posedge clk)
    if (cnt_en)
        counter <= load ? data : counter - 1;

assign tc = (counter == 0);

endmodule
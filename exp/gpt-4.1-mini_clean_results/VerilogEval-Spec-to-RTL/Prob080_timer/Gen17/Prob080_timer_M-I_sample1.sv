module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire count_enable;

assign count_enable = ~load & (counter != 0);

always @(posedge clk) begin
    if (load)
        counter <= data;
    else if (count_enable)
        counter <= counter - 1;
    else
        counter <= counter;
end

assign tc = (counter == 0);

endmodule
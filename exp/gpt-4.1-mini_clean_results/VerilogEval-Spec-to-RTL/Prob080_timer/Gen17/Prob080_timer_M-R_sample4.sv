module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;

wire enable = load | (counter != 10'd0);

always @(posedge clk) begin
    if (load)
        counter <= data;
    else if (enable)
        counter <= counter - 1;
end

assign tc = (counter == 10'd0);

endmodule
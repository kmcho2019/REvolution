module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire [9:0] dec_count;
wire [9:0] next_count;
wire enable;

assign dec_count = counter - 1;
assign next_count = load ? data : dec_count;
assign enable = load | (counter != 0);

always @(posedge clk) begin
    if (enable)
        counter <= next_count;
end

assign tc = (counter == 0);

endmodule
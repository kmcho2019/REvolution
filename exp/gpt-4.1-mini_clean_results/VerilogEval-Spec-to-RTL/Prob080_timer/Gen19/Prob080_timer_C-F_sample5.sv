module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire [9:0] counter_next;
wire count_enable;

assign count_enable = ~load & (counter != 0);
assign counter_next = count_enable ? (counter - 1) : counter;

always @(posedge clk) begin
    counter <= load ? data : counter_next;
end

assign tc = (counter == 0);

endmodule
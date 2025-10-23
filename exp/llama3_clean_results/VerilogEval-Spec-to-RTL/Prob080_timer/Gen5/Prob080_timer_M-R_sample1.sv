module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire [9:0] next_counter;

assign next_counter = load ? data : (counter > 0) ? counter - 1'd1 : counter;
assign tc = (counter == 10'd0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    counter <= next_counter;
end

endmodule
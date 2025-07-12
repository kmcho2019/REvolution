module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire [9:0] next_counter;
assign next_counter = load? data : (counter == 10'd0)? 10'd0 : counter - 1;
assign tc = (counter == 10'd0);

always @(posedge clk)
    counter <= next_counter;

endmodule
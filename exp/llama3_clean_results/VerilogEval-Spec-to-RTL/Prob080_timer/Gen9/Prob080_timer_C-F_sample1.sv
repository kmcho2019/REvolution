module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [9:0] next_counter;

assign tc = (counter == 0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    next_counter = load ? data : (counter == 0) ? 0 : counter - 1;
    counter <= next_counter;
end

endmodule
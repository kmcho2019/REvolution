module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;

// Combinational logic to determine next state
wire [9:0] next_counter;
assign next_counter = load ? data : (counter == 10'd0) ? 10'd0 : (load ? counter : counter - 1);

// Sequential logic to update counter
always @(posedge clk) begin
    counter <= next_counter;
end

// Combinational logic to assert tc
assign tc = (counter == 10'd0) ? 1'b1 : 1'b0;

endmodule
module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

// Combinational logic to calculate the next state of the counter
wire [9:0] next_q;
assign next_q = (reset || q == 10'd999) ? 10'd0 : q + 10'd1;

// Sequential logic to update the counter's state
always @(posedge clk) begin
    q <= next_q;
end

endmodule
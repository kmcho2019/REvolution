module TopModule(
    input clk,
    input in,
    output reg out
);

// Describe the combinational logic using assign with an intermediate wire
wire next_out;
assign next_out = in ^ out;

// Update the output of the flip-flop on the positive edge of the clock
always @(posedge clk) begin
    out <= next_out;
end

endmodule
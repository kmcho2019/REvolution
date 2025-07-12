module TopModule(
    input clk,
    input in,
    output reg out
);

// Directly calculate the next state of the flip-flop using a continuous assignment
assign next_out = in ^ out;

// Update the output on the positive edge of the clock
always @ (posedge clk) begin
    out <= next_out;
end

endmodule
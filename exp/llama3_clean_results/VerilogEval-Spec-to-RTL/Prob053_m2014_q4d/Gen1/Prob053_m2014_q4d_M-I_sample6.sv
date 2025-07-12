module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_out; // Intermediate signal to hold the next state of the flip-flop

always @(*) begin
    next_out = in ^ out; // Calculate the next state based on current inputs
end

always @ (posedge clk) begin
    out <= next_out; // Update the output on the positive edge of the clock
end

endmodule
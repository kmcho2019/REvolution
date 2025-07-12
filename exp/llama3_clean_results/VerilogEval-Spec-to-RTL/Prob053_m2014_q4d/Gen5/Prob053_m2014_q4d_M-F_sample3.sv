module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_state; // Variable to hold the next state of the flip-flop

always @(*) begin
    next_state = in ^ out; // Calculate the next state of the flip-flop
end

always @(posedge clk) begin
    out <= next_state; // Update the output of the flip-flop
end

endmodule
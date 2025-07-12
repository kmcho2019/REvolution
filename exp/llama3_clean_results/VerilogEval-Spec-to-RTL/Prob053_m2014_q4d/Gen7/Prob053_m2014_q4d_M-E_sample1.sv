module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_state; // Intermediate signal for the XOR operation result

// Combinational logic for XOR operation
always @(*) begin
    next_state = in ^ out; // Calculate next state using in and current out
end

// Sequential logic for D flip-flop
always @(posedge clk) begin
    out <= next_state; // Update out with next_state on the rising edge of the clock
end

endmodule
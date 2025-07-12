module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_out; // Explicitly define next_out as a reg

// Calculate the next state of the flip-flop using an always block for combinational logic
always @(*) begin
    next_out = in ^ out; // Use the explicitly defined next_out
end

// Update the output on the positive edge of the clock
always @ (posedge clk) begin
    out = next_out; // Using blocking assignment for clarity
end

endmodule
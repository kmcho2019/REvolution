module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Synchronous reset D flip-flop implementation
// Uses a non-blocking assignment for the reset condition to ensure correct synchronization with the clock edge
always @(posedge clk) begin
    // Concise conditional assignment to handle reset and normal operation
    q <= r ? 1'b0 : d; // Reset to 0 if r is high, otherwise load input d
end

endmodule
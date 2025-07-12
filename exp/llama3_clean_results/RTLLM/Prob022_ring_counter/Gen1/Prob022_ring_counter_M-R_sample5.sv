module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

// Handle reset asynchronously
always @(negedge reset) begin
    state <= 8'b0000_0001; // Reset to initial state
end

// Update state on clock edge
always @(posedge clk) begin
    if (!reset) begin
        // Perform cyclic shift
        state <= (state >> 1) | (state[0] << 7); // Shift right and wrap around
    end
end

// Assign the current state to the output
assign out = state;

endmodule
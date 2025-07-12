module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

// Handle reset condition
always @(posedge reset) begin
    state <= 8'b0000_0001; // Reset to initial state
end

// Handle clock edge for state update
always @(posedge clk) begin
    if (!reset) begin
        state <= {state[6:0], state[7]}; // Shift right and wrap around
    end
end

// Assign the current state to the output
assign out = state;

endmodule
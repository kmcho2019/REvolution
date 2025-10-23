module TopModule #(
    parameter int WIDTH = 5,
    parameter int TAP1 = 4, // Interpretation of position 5 in 0-based indexing
    parameter int TAP2 = 2  // Interpretation of position 3 in 0-based indexing
)(
    input clk,
    input reset,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] state; // Current state of the LFSR

// Update the state by shifting right and filling the MSB with the next state bit
always @(posedge clk) begin
    if (reset) begin
        // Reset to a known non-zero state (e.g., 1 followed by zeros)
        state <= {1'b1, {WIDTH-1{1'b0}}};
    end else begin
        // Calculate the next state bit directly and update the state
        state <= {state[0] ^ state[TAP1] ^ state[TAP2], state[WIDTH-1:1]};
    end
end

assign q = state;

endmodule
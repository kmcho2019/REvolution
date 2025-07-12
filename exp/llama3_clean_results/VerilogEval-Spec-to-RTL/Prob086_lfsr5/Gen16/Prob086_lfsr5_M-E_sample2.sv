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

wire next_state_bit; // Next state bit calculation

// Calculate the next state bit based on the taps
assign next_state_bit = state[TAP1] ^ state[TAP2];

// Update the state by shifting right and filling the MSB with the next state bit
always @(posedge clk) begin
    if (reset) begin
        // Reset to a non-zero state (e.g., all ones for simplicity)
        state <= {WIDTH{1'b1}};
    end else begin
        state <= {next_state_bit, state[WIDTH-1:1]};
    end
end

assign q = state;

endmodule
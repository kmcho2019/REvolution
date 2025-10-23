module TopModule #(
    parameter int WIDTH = 5,
    parameter int TAP1 = 4, // MSB position in 0-based indexing
    parameter int TAP2 = 2  // Third position from MSB in 0-based indexing
)(
    input clk,
    input reset,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] state; // Current state of the LFSR

// Function to calculate the next state bit
function bit next_state_bit_input;
    input [WIDTH-1:0] current_state;
    begin
        next_state_bit_input = current_state[0] ^ current_state[TAP2];
    end
endfunction

// Calculate the next state bit
wire next_state_bit = next_state_bit_input(state);

// Update the state by shifting right and filling the MSB with the next state bit
always @(posedge clk) begin
    if (reset) begin
        // Reset to a known non-zero state (e.g., 1 followed by zeros)
        state <= {1'b1, {WIDTH-1{1'b0}}};
    end else begin
        // Shift the state right and fill the MSB with the next state bit
        state <= {next_state_bit, state[WIDTH-1:1]};
    end
end

assign q = state;

endmodule
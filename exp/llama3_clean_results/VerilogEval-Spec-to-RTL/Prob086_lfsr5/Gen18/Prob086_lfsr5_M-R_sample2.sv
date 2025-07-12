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

always @(posedge clk) begin
    if (reset) begin
        // Reset all bits of the state to 1
        state <= {WIDTH{1'b1}};
    end else begin
        // Calculate the next state
        state[0] <= state[WIDTH-1]; // The LSB is the MSB shifted in
        for (int i = 1; i < WIDTH; i++) begin
            if (i == TAP1 || i == TAP2) begin
                // For tap positions, XOR with the LSB
                state[i] <= state[i-1] ^ state[0];
            end else begin
                // For non-tap positions, simply shift
                state[i] <= state[i-1];
            end
        end
    end
end

assign q = state;

endmodule
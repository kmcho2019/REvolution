module TopModule #(
    parameter WIDTH = 5,
    parameter TAP1 = 4, // Position 5 in 0-based indexing
    parameter TAP2 = 2  // Position 3 in 0-based indexing
)(
    input clk,
    input reset,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= {WIDTH{1'b0}}; // Reset to all zeros except for the LSB
        state[0] <= 1'b1;
    end else begin
        // Calculate the next state
        state[WIDTH-1] <= state[TAP1] ^ state[TAP2] ^ state[0]; // MSB calculation
        for (int i = WIDTH-2; i > 0; i--) begin
            state[i] <= state[i-1]; // Shift right for other bits
        end
        state[0] <= state[WIDTH-1]; // LSB is the new MSB
    end
end

assign q = state; // Output the current state

endmodule
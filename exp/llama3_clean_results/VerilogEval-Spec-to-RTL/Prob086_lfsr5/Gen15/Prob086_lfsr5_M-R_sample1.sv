module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

wire next_state_bit; // Next state bit calculation

assign next_state_bit = state[2] ^ state[0]; // Taps for maximal-length sequence
assign q = state;

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Reset to a non-zero state for maximal-length sequence
    end else begin
        // Update state with next state bit and shift
        state <= {next_state_bit, state[4:1]};
    end
end

endmodule
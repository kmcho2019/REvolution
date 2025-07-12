module TopModule (
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset the LFSR to 1
    end else begin
        // Calculate the next state
        reg [4:0] next_state;
        next_state[0] = state[4]; // Shift the MSB to the LSB
        next_state[1] = state[0] ^ state[1]; // Tap at position 3
        next_state[2] = state[1];
        next_state[3] = state[2] ^ state[3]; // Tap at position 5
        next_state[4] = state[3];
        state <= next_state;
    end
end

assign q = state;

endmodule
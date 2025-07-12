module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Initialize with a non-zero state
    end else begin
        state[4] <= state[3]; // Shift
        state[3] <= state[2]; // Shift
        state[2] <= state[1]; // Shift
        state[1] <= state[0]; // Shift
        state[0] <= state[4] ^ state[1]; // Apply taps at positions 4 and 1
    end
end

assign q = state; // Output the current state of the LFSR

endmodule
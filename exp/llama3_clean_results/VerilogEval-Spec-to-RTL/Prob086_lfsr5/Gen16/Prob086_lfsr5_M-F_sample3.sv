module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Initialize with LSB as 1
    end else begin
        // Update the state based on the feedback from tap positions
        state[4] <= state[0] ^ state[2]; // Feedback for the MSB
        state[3] <= state[4]; // Shift
        state[2] <= state[3]; // Shift
        state[1] <= state[2]; // Shift
        state[0] <= state[1]; // Shift
    end
end

assign q = state; // Output the current state of the LFSR

endmodule
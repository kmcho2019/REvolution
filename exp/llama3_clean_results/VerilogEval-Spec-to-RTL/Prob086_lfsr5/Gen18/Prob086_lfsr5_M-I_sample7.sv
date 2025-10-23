module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Initialize with the least significant bit as 1
    end else begin
        // Update the state based on the feedback from tap positions
        state <= {state[2] ^ state[4], state[3:0]}; // Feedback for the MSB and shift
    end
end

assign q = state; // Output the current state of the LFSR

endmodule
module ring_counter(
    input clk,  // Clock signal
    input reset,  // Reset signal
    output [7:0] out  // 8-bit output
);

reg [7:0] state;  // Internal register to store the current state

// Initialize the state to the starting state when reset is high
always @(posedge reset) begin
    state <= 8'b0000_0001;  // Set the LSB to 1
end

// Update the state on each rising edge of the clock signal
always @(posedge clk) begin
    if (~reset) begin
        // Shift the set bit to the next position in the sequence
        state <= {state[6:0], state[7]};  
    end
end

// Assign the current state to the output
assign out = state;

endmodule
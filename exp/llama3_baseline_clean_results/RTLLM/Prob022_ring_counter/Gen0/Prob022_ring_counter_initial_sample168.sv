module ring_counter(
    input clk,    // Clock signal
    input reset,  // Reset signal
    output [7:0] out  // 8-bit output representing the current state
);

reg [7:0] state;  // Register to hold the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its initial state
        state <= 8'b0000_0001;
    end else begin
        // Shift the 1 to the next bit in the sequence
        state <= {state[6:0], state[7]};
    end
end

// Continuously assign the current state to the output
assign out = state;

endmodule
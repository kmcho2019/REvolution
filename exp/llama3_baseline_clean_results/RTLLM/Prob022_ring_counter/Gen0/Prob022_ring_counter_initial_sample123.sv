module ring_counter (
    input         clk,    // Clock signal
    input         reset,  // Reset signal
    output [7:0]  out     // 8-bit output
);

reg [7:0] state;  // Register to hold the current state

// Initial state when reset is high
initial state = 8'b0000_0001;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the ring counter to its initial state
        state <= 8'b0000_0001;
    end else begin
        // Shift the '1' to the next bit, wrapping around if necessary
        state <= {state[6:0], state[7]};
    end
end

assign out = state;  // Output the current state

endmodule